#' NBER NPI Dataset URLs
#'
#' @param x dataset group
#'
#' @returns url to the dataset's zip files
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
nber_urls <- function(x){

  url <- list(
    monthly = "https://data.nber.org/npi/zip/",
    weekly = "https://data.nber.org/npi/weekly/",
    byvar = "https://data.nber.org/npi/byvar/",
    zipcode = "https://data.nber.org/distance/"
  )

  url[[x]]

}

#' Get tibble of NBER NPI Dataset Information
#'
#' @param url url to dataset's zip files
#'
#' @returns data.frame
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
get_table <- function(url) {

  rvest::read_html(url) |>
    rvest::html_table() |>
    purrr::pluck(1) |>
    janitor::clean_names() |>
    dplyr::slice(
      2:dplyr::n()) |>
    fuimus::remove_quiet() |>
    dplyr::mutate(
      last_modified = anytime::anytime(last_modified),
      size = fs::as_fs_bytes(size),
      url = as.character(
        glue::glue("{url}{name}"))) |>
    dplyr::arrange(dplyr::desc(last_modified))
}

#' Summarise tibble of NBER NPI Dataset Information
#'
#' @param table url to dataset's zip files
#'
#' @param directory directory to save zip files
#'
#' @returns data.frame
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
table_sum <- function(table, directory) {

  table |>
    dplyr::summarise(
      files = dplyr::n(),
      size = sum(size, na.rm = TRUE)
    ) |>
    dplyr::mutate(
      directory = directory,
      .before = 1
    )
}

#' Return All NBER NPI Dataset Information
#'
#' @returns data.frame
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
get_all_tables <- function() {

  tables <- list(
    monthly = get_table(nber_urls("monthly")),
    weekly  = get_table(nber_urls("weekly")),
    byvar   = get_table(nber_urls("byvar")),
    zipcode = get_table(nber_urls("zipcode")))

  sums <- list(
    monthly = table_sum(tables$monthly, "monthly"),
    weekly  = table_sum(tables$weekly, "weekly"),
    byvar   = table_sum(tables$byvar, "byvar"),
    zipcode = table_sum(tables$zipcode, "zipcode")) |>
  purrr::list_rbind()

  tables <- purrr::list_rbind(
    tables,
    names_to = "dataset")

  list(
    summary  = sums,
    datasets = tables
  )
}

#' Download NBER NPI Zip Files
#'
#' @param table url to dataset's zip files
#'
#' @param directory directory to save zip files
#'
#' @returns results from [curl::multi_download()] and a vector of zip file paths
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
download_zips <- function(table, directory) {

  zip_paths <- stringr::str_glue("{directory}{table$name}")

  result <- curl::multi_download(
    urls = table$url,
    destfile = zip_paths,
    resume = TRUE,
    timeout = 60
  )
  return(c(result, zip_paths))
}

#' Create Standardized File Names
#'
#' @param file_names a vector of file names
#'
#' @param remove regex pattern to remove from file names
#'
#' @param format date format
#'
#' @param collapse delimiter
#'
#' @param left string to prepend to file names
#'
#' @param right string to append to file names
#'
#' @returns a vector of transformed file names
#'
#' @examples
#' c("week123019_010520.zip",
#    "week122622_010123.zip",
#    "week122820_010321.zip",
#    "week122721_010222.zip",
#    "week122616_010117.zip",
#    "week123118_010619.zip",
#    "week122815_010316.zip",
#    "week080315_080915.zip") |>
#    create_zip_file_names()
#'
#' @autoglobal
#'
#' @export
create_zip_file_names <- function(file_names,
                                  remove = ".zip|week|npidata_pfile_",
                                  format = "%m%d%y",
                                  collapse = "|",
                                  left = "week:",
                                  right = ""
                                  ) {

  x <- basename(file_names) |>
    stringr::str_remove_all(remove) |>
    strex::str_split_by_numbers() |>
    purrr::list_transpose() |>
    purrr::discard_at(2) |>
    purrr::set_names(c("start", "end"))

  asdate <- \(x) as.Date(x, format = format)

  x |>
    purrr::map(asdate) |>
    purrr::list_transpose() |>
    purrr::map(paste0, collapse = collapse) |>
    purrr::map(wrap, left = left, right = right) |>
    unlist(use.names = FALSE)

}

#' Clean credentials
#'
#' Removes periods ("`.`") in strings
#'
#' @param x a string vector of provider credentials
#'
#' @returns vector
#'
#' @examples
#' clean_credentials("M.D.")
#'
#' @autoglobal
#'
#' @export
clean_credentials <- function(x) {

  gsub("\\.", "", x)

}

#' Wrap strings
#'
#' @param x a vector of provider credentials
#'
#' @param left a string
#'
#' @param right a string
#'
#' @returns vector
#'
#' @examples
#' wrap(x = "M.D.", left = "(", right = ")")
#'
#' @autoglobal
#'
#' @export
wrap <- function(x, left, right) {

  paste0(left, x, right)

}
