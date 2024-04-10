tmp <- fs::path(fs::path_wd(), "inst/tmp")
fs::dir_create(tmp)

nppes <- readr::read_csv(fs::path(tmp, "npidata_pfile_20050523-20240407.csv")) |>
  janitor::clean_names()
