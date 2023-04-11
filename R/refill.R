# Scrape download links ---------------------------------------------------

html <- rvest::read_html("https://download.cms.gov/nppes/NPI_Files.html")

names <- html |>
  rvest::html_elements("li") |>
  rvest::html_text2()

links <- html |>
  rvest::html_elements("a") |>
  rvest::html_attr("href")

prefix <- "https://download.cms.gov/nppes"

df <- tibble::tribble(
  ~description,    ~links,
  names[4],         links[5],
  names[5],         links[6],
  names[6],         links[7])

df |>
  dplyr::mutate(zip_url = stringr::str_replace(links, ".", prefix)) |>
  tidyr::separate_wider_delim(name, delim = " - ",
                              names = c("names", "desc", "date_format"),
                              too_few = "align_start", too_many = "merge") |>
  tidyr::unite("description", names:desc, remove = TRUE, sep = " ")
