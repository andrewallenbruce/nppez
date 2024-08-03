

dir_npiall  <- "D:/NBER_NPI_Archives/npiall"

npiall_path <- fs::dir_ls(path = dir_npiall)

tidytable::fread(npiall_path, nrows = 50) |>
  dplyr::glimpse()



read_npi_raw_csv <- \(x) {
  tidytable::fread(x, colClasses = list(character = 1:330)) |>
    janitor::clean_names() |>
    fuimus::remove_quiet() |>
    purrr::map_dfr(fuimus::na_if_common)
}


sparks <- c("\u2581", "\u2582", "\u2583", "\u2585", "\u2587")

histospark <- function(x, width = 10) {
  bins <- graphics::hist(x, breaks = width, plot = FALSE)

  factor <- cut(
    bins$counts / max(bins$counts),
    breaks = seq(0, 1, length = length(sparks) + 1),
    labels = sparks,
    include.lowest = TRUE
  )

  paste0(factor, collapse = "")
}

histospark(rnorm(100), width = 10)
