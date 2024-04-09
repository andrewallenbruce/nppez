#' NPPES Data Dissemination releases
#'
#' @param save `<lgl>` write data to disk with `data.table::fwrite()`; default is `FALSE`
#'
#' @param path `<chr>` path to save csv to; default is `fs::path_wd()`
#'
#' @return A [tibble][tibble::tibble-package] of the search results.
#'
#' @examplesIf interactive()
#' tmp <- fs::dir_create(fs::path_temp("nppez"))
#'
#' nppez::ask(save = TRUE)
#'
#' fs::dir_delete(tmp)
#' @autoglobal
#'
#' @export
ask <- function(save = FALSE,
                path = fs::path_wd()) {

  tictoc::tic("Download Time") ########################

  url <- "https://download.cms.gov/nppes/NPI_Files.html"
  html <- rvest::read_html(url)

  tictoc::toc() ########################################

  names <- html |>
    rvest::html_elements("li") |>
    rvest::html_text2()

  links <- html |>
    rvest::html_elements("a") |>
    rvest::html_attr("href")

  # [1] "Other Name Reference File
  #      this file contains additional Other Names
  #      associated with Type 2 NPIs"
  # [2] "Practice Location Reference File
  #      this file contains all of the non-primary
  #      Practice Locations associated with Type 1 and Type 2 NPIs"
  # [3] "Endpoint Reference File
  #      this file contains all Endpoints associated
  #      with Type 1 and Type 2 NPIs."

  obj <- dplyr::tibble(
    name  = names[4:8],
    file = substr(links[4:8], 3, 50) |>
      stringr::str_replace(".zi$", ".zip"),
    url = paste0("https://download.cms.gov/nppes/", file),
    date_wk1 = stringr::str_extract(name, "\\d{6}") |>
      clock::date_parse(format = "%m%d%y"),
    date = stringr::str_extract(name, fuimus::months_regex()) |>
      clock::date_parse(format = "%B %d, %Y") %>%
      dplyr::if_else(is.na(.), date_wk1, .),
    size = strex::str_after_last(name, "[(]") |>
      stringr::str_remove_all("[)]") |>
      stringr::str_remove_all("[,]") |>
      fs::fs_bytes()
    ) |>
    dplyr::select(-date_wk1, -name)

  class(obj) <- c("nppez::ask", class(obj))

  if (save) {
    data.table::fwrite(
      obj,
      fs::path(path,
               fs::path_ext_set(
                 obj[[1]][[1]],
                 ".csv"
                 )
               )
      )
  }
  return(obj)
}

#' Download NPPES ZIP files to a local directory
#' @param obj `<tbl_df>` object of class `nppez::ask`, returned from `nppez::ask()`
#' @param files `<chr>` vector of files to download from ZIPs; default behavior is to download all files
#' @param path `<chr>` path to download ZIPs to; default is `fs::path_wd()`
#'
#' @return tibble
#'
#' @examplesIf interactive()
#' nppez::ask() |>
#' nppez::grab(files = "NPPES_Deactivated_NPI_Report_031124.zip")
#'
#' @autoglobal
#' @export
grab <- function(obj,
                 files = NULL,
                 path = fs::path_wd()) {

  stopifnot("`obj` must be of class 'ask'" = inherits(obj, "nppez::ask"))

  if (!is.null(files)) {

    stopifnot("No `files` in results" = files %in% obj$file)

    obj <- vctrs::vec_slice(obj, vctrs::vec_in(obj$file, files))

  }

  class(obj) <- c("nppez::grab", class(obj))

  log <- curl::multi_download(
    urls = obj$url,
    destfiles = fs::path(
      path,
      basename(obj$url)
      )
    )

  class(log) <- c("nppez::log", class(log))

  data.table::fwrite(
    log,
    fs::path(
      path,
      fs::path_ext_set(
        stringr::str_c(
          "NPPES_Download_Log_",
          clock::date_today("")
          ),
        ".csv"
        )
      )
    )
  return(fs::dir_tree(path))
}

#' Peek inside the downloaded NPPES ZIPs before unzipping
#'
#' @param path `<chr>` path to download ZIPs to; default is `fs::path_wd()`
#'
#' @return tibble
#'
#' @examplesIf interactive()
#' nppez::peek()
#'
#' @autoglobal
#' @export
peek <- function(path) {

  # stopifnot("`obj` must be of class 'grab'" = inherits(obj, "nppez::grab"))

  dr <- fs::dir_info(fs::path(path)) |>
    dplyr::select(path) |>
    dplyr::filter(stringr::str_detect(path, ".zip")) |>
    tibble::deframe() |>
    rlang::set_names(basename) |>
    purrr::map(zip::zip_list) |>
    purrr::list_rbind(names_to = "zipfile") |>
    dplyr::mutate(compressed = fs::fs_bytes(compressed_size),
                  uncompressed = fs::fs_bytes(uncompressed_size)) |>
    dplyr::select(zipfile,
                  filename,
                  compressed,
                  uncompressed) |>
    dplyr::tibble()

  class(dr) <- c("nppez::peek", class(dr))

    dr |> split(dr$zipfile)
  }

#' Select files to unzip inside the downloaded NPPES ZIPs before unzipping
#'
#' @param dir path to directory of ZIPs
#'
#' @return tibble
#'
#' @examplesIf interactive()
#' nppez::prune()
#'
#' @autoglobal
#' @export
prune <- function(dir) {

  fs::dir_info(dir) |>
    dplyr::select(path) |>
    dplyr::mutate(
      zip = stringr::str_ends(
        path,
        ".zip"
        )
      ) |>
    dplyr::filter(
      zip == TRUE
      ) |>
    dplyr::mutate(
      zip = NULL
      ) |>
    tibble::deframe() |>
    rlang::set_names(basename) |>
    purrr::map(
      zip::zip_list
      ) |>
    purrr::list_rbind(
      names_to = "parent_zip"
      ) |>
    dplyr::mutate(
      contains_month = stringr::str_detect(
        parent_zip,
        fuimus::months_regex())) |>
    dplyr::filter(
      contains_month == TRUE
      ) |>
    dplyr::select(filename) |>
    dplyr::mutate(
      fileheader = stringr::str_ends(
        filename,
        "fileheader[.]csv$",
        negate = FALSE
        )
      ) |>
    dplyr::mutate(
      pdf = stringr::str_ends(
        filename,
        "[.]pdf$",
        negate = FALSE
        )
      ) |>
    dplyr::filter(
      fileheader == FALSE,
      pdf == FALSE
      ) |>
    dplyr::select(filename) |>
    tibble::deframe()
}

#' Unzip NPPES ZIPs
#'
#' @param zip_dir path to directory containing ZIPs
#'
#' @param unzip_dir path to directory to unzip ZIPs
#'
#' @param files character vector of files inside a zip file to unzip
#'
#' @return invisible
#'
#' @examplesIf interactive()
#' nppez::dispense()
#'
#' @autoglobal
#' @export
dispense <- function(zip_dir,
                     unzip_dir,
                     files = NULL) {

  fs::dir_info(
    zip_dir
    ) |>
    dplyr::select(
      path
      ) |>
    tibble::deframe() |>
    purrr::walk(
      zip::unzip,
      exdir = unzip_dir,
      files = files
      )
}

#     dplyr::mutate(
#       file_age = clock::date_count_between(
#         release_date,
#         current_date,
#         "day"
#       )



