# https://www.nber.org/research/data/national-plan-and-provider-enumeration-system-nppes
# Source Zip Files: Monthly, Weekly: Raw zip files for 2017-2024
# https://www.nber.org/research/data/zip-code-distance-database


# weekly_paths <- download_zips(
#   table = nber_npi$weekly,
#   directory = "D:/NBER_NPI_Archives/weekly/"
#   )
#
# ondisk_zips <- list(
#   weekly = weekly_paths,
#   monthly = NULL,
#   byvar = NULL
# )


get_pin("nber_weekly_info")$unzipped[1]

npi_2024_01_01 <- get_pin("npi_2024_01_01__2024_01_07")
npi_2024_01_22 <- get_pin("npi_2024_01_22__2024_01_28")


release <- create_zip_file_names(c(npi_2024_01_01$release, npi_2024_01_22$release))

npi_2024_01_01 <- vctrs::vec_cbind(
  dplyr::tibble(release = release[1]),
  npi_2024_01_01[["base"]]
)

npi_2024_01_22 <- vctrs::vec_cbind(
  dplyr::tibble(release = release[2]),
  npi_2024_01_22[["base"]]
)

# fuimus::create_vec(names(npi_2024_01_01))

clnm <- c(
  "entity",
  "enum_date",
       "deact_date",
       "react_date",
       "sole_prop",
       "org_sub",
       "gender",
       "credential")

npi_2024_01_01 |>
  dplyr::mutate(
    credential = provider:::clean_credentials(credential)) |>
  hacksaw::count_split(
    entity,
    enum_date,
    deact_date,
    react_date,
    sole_prop,
    org_sub,
    gender,
    credential
  ) |>
  purrr::map(\(df) dplyr::filter(df, !is.na(df[1]))) |>
  purrr::map(\(df) dplyr::rename(df, val = names(df[1]))) |>
  purrr::set_names(clnm) |>
  purrr::list_rbind(names_to = "var")
