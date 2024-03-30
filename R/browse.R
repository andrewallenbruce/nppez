#' List the most recent NPPES Data Dissemination releases
#'
#' @param save `<chr>` write to disk using `readr::write_csv()` ; default is `FALSE`
#'
#' @param path `<chr>` path to save to; default is `here::here()`
#'
#' @return tibble with
#'
#' @examplesIf interactive()
#' nppez::ask()
#'
#' @autoglobal
#' @export
ask <- function(save = FALSE,
                path = here::here("./")) {

  tictoc::tic("Download Time")

  url <- "https://download.cms.gov/nppes/NPI_Files.html"
  html <- rvest::read_html(url)

  tictoc::toc()

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

  results <- dplyr::tibble(
    name  = names[4:8],
    file = substr(links[4:8], 3, 50) |>
      stringr::str_replace(".zi$", ".zip"),
    url = paste0("https://download.cms.gov/nppes/", file),
    date_wk1 = stringr::str_extract(name, "\\d{6}") |>
      clock::date_parse(format = "%m%d%y"),
    date = stringr::str_extract(name, months_regex()) |>
      clock::date_parse(format = "%B %d, %Y") %>%
      dplyr::if_else(is.na(.), date_wk1, .),
    size = strex::str_after_last(name, "[(]") |>
      stringr::str_remove_all("[)]") |>
      stringr::str_remove_all("[,]") |>
      fs::fs_bytes()
    ) |>
    dplyr::select(-date_wk1, -name)

  if (save) {
    readr::write_csv(
      results,
      file = paste0(
        path,
        stringr::str_replace(
          results[[1]][[1]],
          ".zip",
          ".csv"
          )
        )
      )
  }
  return(results)
}

#' Download NPPES ZIP files to a local directory
#'
#' @param dir path to local directory to download ZIPs to
#'
#' @return tibble
#'
#' @examplesIf interactive()
#' nppez::grab(dir = tempdir())
#'
#' @autoglobal
#' @export
grab <- function(dir) {

  zips <- nppez::ask()$url

  curl::multi_download(
    urls = zips,
    destfiles = stringr::str_c(
      dir,
      basename(zips)
      )
    )
}

#' Peek inside the downloaded NPPES ZIPs before unzipping
#'
#' @param dir path to directory of ZIPs
#'
#' @return tibble
#'
#' @examplesIf interactive()
#' nppez::peek()
#'
#' @autoglobal
#' @export
peek <- function(dir) {

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
      size_compressed = fs::fs_bytes(compressed_size),
      size_uncompressed = fs::fs_bytes(uncompressed_size)
      ) |>
    dplyr::select(
      parent_zip,
      filename,
      size_compressed,
      size_uncompressed
      )
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
        months_regex())) |>
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

# browse <- function() {
#
#   url  <- "https://download.cms.gov/nppes/NPI_Files.html"
#   html <- rvest::read_html(url)
#
#   names <- html |>
#     rvest::html_elements("li") |>
#     rvest::html_text2()
#
#   links <- html |>
#     rvest::html_elements("a") |>
#     rvest::html_attr("href")
#
#
#   df <- dplyr::tribble(
#     ~full,    ~links,
#     names[4], links[5],
#     names[5], links[6],
#     names[6], links[7])
#
#   prefix       <- "https://download.cms.gov/nppes"
#   months_regex <- single_line_string("(Jan(?:uary)?|Feb(?:ruary)?|
#                   Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|
#                   Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|
#                   Dec(?:ember)?)\\s+(\\d{1,2})\\,\\s+(\\d{4})")
#
#   results <- df |>
#     dplyr::mutate(
#       date1 = stringr::str_extract(
#         full,
#         months_regex
#       ),
#       date1 = clock::date_parse(
#         date1,
#         format = "%B %d, %Y"
#       ),
#       date2 = stringr::str_extract(
#         full,
#         "\\d{6}"
#       ),
#       date2 = clock::date_parse(
#         date2,
#         format = "%m%d%y"
#       ),
#       name = stringr::str_extract(
#         full,
#         "(NPPES Data Dissemination)"
#       ),
#       type = stringr::str_extract(
#         full,
#         "(Monthly Deactivation Update|Weekly Update)"
#       ),
#       size = strex::str_after_last(
#         full,
#         "[(]"
#       ),
#       size = stringr::str_remove_all(
#         size,
#         "[)]"
#       ),
#       size = stringr::str_remove_all(
#         size,
#         "[,]"
#       ),
#       size = fs::fs_bytes(size),
#       zip_url = stringr::str_replace(
#         links,
#         ".",
#         prefix
#       ),
#       links = NULL,
#       full = NULL
#     ) |>
#     tidyr::unite(
#       "file",
#       name:type,
#       remove = TRUE,
#       sep = " ",
#       na.rm = TRUE
#     ) |>
#     tidyr::unite(
#       "date",
#       date1:date2,
#       remove = TRUE,
#       sep = "",
#       na.rm = TRUE
#     ) |>
#     dplyr::mutate(
#       date = clock::date_parse(date),
#       current_date = clock::date_today("")
#     ) |>
#     dplyr::rename(
#       release_date = date,
#       file_size = size
#     ) |>
#     dplyr::mutate(
#       file_age = clock::date_count_between(
#         release_date,
#         current_date,
#         "day"
#       ),
#       current_date = NULL
#     ) |>
#     dplyr::relocate(
#       file_age,
#       .after = release_date
#     )
#   return(results)
# }



