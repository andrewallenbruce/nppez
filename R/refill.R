#' Retrieve info about the most recent NPPES Data Dissemination release
#'
#' @return tibble with
#' @examples
#' nppez::refill()
#' @autoglobal
#' @export
refill <- function() {

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

  df <- tibble::tribble(
  ~full,    ~links,
  names[4],         links[5],
  names[5],         links[6],
  names[6],         links[7])

  results <- df |>
  dplyr::mutate(
    date = stringr::str_extract(full, "(Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)\\s+(\\d{1,2})\\,\\s+(\\d{4})"),
    date = clock::date_parse(date, format = "%B %d, %Y"),
    name = stringr::str_extract(full, "(NPPES Data Dissemination)"),
    type = stringr::str_extract(full, "(Monthly Deactivation Update|Weekly Update)"),
    size = strex::str_after_last(full, "[(]"),
    size = stringr::str_remove_all(size, "[)]"),
    size = stringr::str_remove_all(size, "[,]"),
    size = fs::fs_bytes(size),
    zip_url = stringr::str_replace(links, ".", prefix),
    links = NULL,
    full = NULL) |>
    tidyr::unite("file", name:type, remove = TRUE, sep = " ", na.rm = TRUE) |>
    tidyr::fill(date, .direction = "down")

  return(results)

}
