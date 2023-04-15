#' Retrieve info about the most recent NPPES Data Dissemination release
#' @return tibble with
#' @examples
#' nppez::browse()
#' @autoglobal
#' @export
browse <- function() {

  # Scrape download links ---------------------------------------------------
  url <- "https://download.cms.gov/nppes/NPI_Files.html"
  html <- rvest::read_html(url)

  # Construct tibble --------------------------------------------------------
  names <- html |>
    rvest::html_elements("li") |>
    rvest::html_text2()

  links <- html |>
    rvest::html_elements("a") |>
    rvest::html_attr("href")

  prefix <- "https://download.cms.gov/nppes"

  df <- dplyr::tribble(
    ~full,    ~links,
    names[4],         links[5],
    names[5],         links[6],
    names[6],         links[7])

  results <- df |>
    dplyr::mutate(
      date1 = stringr::str_extract(full,
      "(Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)\\s+(\\d{1,2})\\,\\s+(\\d{4})"),
      date1 = clock::date_parse(date1, format = "%B %d, %Y"),
      date2 = stringr::str_extract(full, "\\d{6}"),
      date2 = clock::date_parse(date2, format = "%m%d%y"),
      name = stringr::str_extract(full, "(NPPES Data Dissemination)"),
      type = stringr::str_extract(full,
                      "(Monthly Deactivation Update|Weekly Update)"),
      size = strex::str_after_last(full, "[(]"),
      size = stringr::str_remove_all(size, "[)]"),
      size = stringr::str_remove_all(size, "[,]"),
      size = fs::fs_bytes(size),
      zip_url = stringr::str_replace(links, ".", prefix),
      links = NULL,
      full = NULL) |>
    tidyr::unite("file",
                 name:type,
                 remove = TRUE,
                 sep = " ",
                 na.rm = TRUE) |>
    tidyr::unite("date",
                 date1:date2,
                 remove = TRUE,
                 sep = "",
                 na.rm = TRUE) |>
    dplyr::mutate(date = clock::date_parse(date))

  return(results)

  }

#' Download NPPES ZIP files to a local directory
#' @return tibble
#' @param dir path to local directory to download ZIPs to
#' @examples
#' \dontrun{
#' nppez::grab(dir = tempdir())
#' }
#' @autoglobal
#' @export
grab <- function(dir) {

  zips <- nppez::browse()$zip_url

  curl::multi_download(urls = zips,
                       destfiles = stringr::str_c(dir,
                       basename(zips)))

  }

#' Peek inside the downloaded NPPES ZIPs before unzipping
#' @param dir path to directory of ZIPs
#' @return tibble
#' @examples
#' \dontrun{
#' nppez::peek()
#' }
#' @autoglobal
#' @export
peek <- function(dir) {

  fs::dir_info(dir) |>
    dplyr::select(path) |>
    tibble::deframe() |>
    rlang::set_names(basename) |>
    purrr::map(zip::zip_list) |>
    purrr::list_rbind(names_to = "parent_zip") |>
    dplyr::mutate(size_compressed = fs::fs_bytes(compressed_size),
                  size_uncompressed = fs::fs_bytes(uncompressed_size)) |>
    dplyr::select(parent_zip, filename, size_compressed, size_uncompressed)

  }

#' Unzip NPPES ZIPs
#' @param zip_dir path to directory containing ZIPs
#' @param unzip_dir path to directory to unzip ZIPs
#' @return invisible
#' @examples
#' \dontrun{
#' nppez::dispense()
#' }
#' @autoglobal
#' @export
dispense <- function(zip_dir, unzip_dir) {

  fs::dir_info(zip_dir) |>
    dplyr::select(path) |>
    tibble::deframe() |>
    purrr::walk(zip::unzip, exdir = unzip_dir)

}





