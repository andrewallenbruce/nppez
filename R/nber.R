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

#' Create Zip File Names for NBER NPI Datasets
#'
#' @param x a vector of file paths
#'
#' @returns a vector of file names
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
create_zip_file_names <- function(x){

  basename(x) |>
    stringr::str_remove_all(".zip|week|npidata_pfile_") |>
    strex::str_split_by_numbers() |>
    purrr::list_transpose() |>
    purrr::discard_at(2) |>
    purrr::set_names(c("start", "end")) |>
    purrr::map(anytime::anydate) |>
    purrr::list_transpose() |>
    purrr::map(paste0, collapse = "|") |>
    purrr::map(yasp::wrap, left = "week:", right = "") |>
    unlist(use.names = FALSE)

}

#' Clean credentials
#'
#' Replaces periods with empty strings
#'
#' @param x a vector of provider credentials
#'
#' @returns vector
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
clean_credentials <- function(x) {
  gsub("\\.", "", x)
}
