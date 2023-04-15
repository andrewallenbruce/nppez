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
