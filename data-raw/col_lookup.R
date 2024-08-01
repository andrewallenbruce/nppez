## code to prepare `col_lookup` dataset goes here

data("weeklycolnames")

col_lookup <- dplyr::tibble(col = weeklycolnames) |>
  dplyr::mutate(npi = stringr::str_detect(col, "(npi)|(entity)|(ein)")) |>
  dplyr::mutate(organization = stringr::str_detect(col,
                                "(organization)|(authoff)")) |>
  dplyr::mutate(individual = stringr::str_detect(col,
                             "(credential)|(gender)|(is_sole_proprietor)")) |>
  dplyr::mutate(name = stringr::str_detect(col, "name")) |>
  dplyr::mutate(address = stringr::str_detect(col, "address")) |>
  dplyr::mutate(identifier = stringr::str_detect(col,
                                      "(identifier)|(identifier)")) |>
  dplyr::mutate(taxonomy = stringr::str_detect(col, "(taxonomy)|(license)")) |>
  dplyr::mutate(other = stringr::str_detect(col, "other")) |>
  dplyr::mutate(date = stringr::str_detect(col, "date")) |>
  dplyr::mutate(dplyr::across(
    dplyr::where(is.logical), ~ dplyr::case_when(col == "npi" ~ TRUE, .default = .x))) |>
  dplyr::mutate(dplyr::across(
    dplyr::where(is.logical), ~ dplyr::if_else(.x == TRUE, 1, 0))) |>
  janitor::adorn_totals(where = "col", name = "total") |>
  janitor::untabyl()

usethis::use_data(col_lookup, overwrite = TRUE)




library(nppez)
library(fs)
library(tidyverse)
library(janitor)

df2chr <- function(df) {
  df |>
    dplyr::mutate(
      dplyr::across(
        dplyr::where(is.numeric), as.character))
}

test <- path(path_wd(), "inst/tmp")

dir_create(test)

test

x <- nppez::ask(
  save = TRUE,
  path = test
)

x$url

y <- nppez::grab(
  obj   = x,
  path  = test
)

y

z <- nppez::peek(
  path = test
)

z

files <- z$NPPES_Data_Dissemination_030424_031024_Weekly.zip |>
  dplyr::filter(
    stringr::str_detect(
      filename,
      ".csv"
    )
  ) |>
  dplyr::pull(filename)

zip::unzip(
  zipfile = y[1], # from nppez::grab()
  exdir = test,
  files = files
)

headers <- stringr::str_c(
  test,
  stringr::str_subset(
    files,
    "fileheader"
  ),
  sep =
    "/"
)

headers_names <- headers |>
  basename() |>
  stringr::str_remove_all(
    pattern = stringr::fixed(".csv")
  )

names(headers) <- headers_names

headers

files_to_read <- stringr::str_c(
  test, stringr::str_subset(
    files,
    "fileheader",
    negate = TRUE
  ),
  sep = "/"
)

files_to_read_names <- files_to_read |>
  basename() |>
  stringr::str_remove_all(
    pattern = stringr::fixed(
      ".csv"
    )
  )

names(files_to_read) <- files_to_read_names

files_to_read

nppes <- files_to_read |>
  purrr::map(
    readr::read_csv,
    col_types = "c"
  ) |>
  purrr::map(df2chr)

nppes_headers <- headers |>
  purrr::map(
    readr::read_csv,
    col_types = "c"
  ) |>
  purrr::map(
    janitor::clean_names
  )

nppes$`pl_pfile_20240304-20240310` |>
  janitor::clean_names()

nppes$`endpoint_pfile_20240304-20240310` |>
  janitor::clean_names()

nppes$`othername_pfile_20240304-20240310` |>
  janitor::clean_names()

nppes$`npidata_pfile_20240304-20240310` |>
  janitor::clean_names()

fs::dir_delete(test)
