# https://www.nber.org/research/data/national-plan-and-provider-enumeration-system-nppes
# Source Zip Files: Monthly, Weekly: Raw zip files for 2017-2024

get_table <- function(url) {
  rvest::read_html(url) |>
    rvest::html_table() |>
    purrr::pluck(1) |>
    janitor::clean_names() |>
    dplyr::slice(2:dplyr::n()) |>
    fuimus::remove_quiet() |>
    dplyr::mutate(
      last_modified = anytime::anytime(last_modified),
      size = fs::as_fs_bytes(size),
      url = as.character(glue::glue("{url}{name}"))) |>
    dplyr::arrange(dplyr::desc(last_modified))
}

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

download_zips <- function(table, directory) {

  zip_paths <- stringr::str_glue("{directory}{table$name}")

  curl::multi_download(
    urls = table$url,
    destfile = zip_paths,
    resume = TRUE,
    timeout = 60
  )
  return(zip_paths)
}

nber_urls <- list(
  monthly = "https://data.nber.org/npi/zip/",
  weekly = "https://data.nber.org/npi/weekly/",
  byvar = "https://data.nber.org/npi/byvar/",
  zipcode = "https://www.nber.org/research/data/zip-code-distance-database"
)

nber_npi <- list(
  monthly = get_table(nber_urls$monthly),
  weekly = get_table(nber_urls$weekly),
  byvar = get_table(nber_urls$byvar)
)

nber_sums <- list(
  monthly = table_sum(nber_npi$monthly, "monthly"),
  weekly = table_sum(nber_npi$weekly, "weekly"),
  byvar = table_sum(nber_npi$byvar, "byvar")
)


nber_sums

nber_npi

# weekly_paths <- download_zips(
#   table = nber_npi$weekly,
#   directory = "D:/NBER_NPI_Archives/weekly/"
#   )

ondisk_zips <- list(
  weekly = weekly_paths,
  monthly = NULL,
  byvar = NULL
)
