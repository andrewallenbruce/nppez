source(here::here("data-raw", "pins_functions.R"))

# fs::dir_create("D:/NBER_NPI_Archives/weekly/unzipped")
dir_base  <- "D:/NBER_NPI_Archives/weekly"

dir_unzip <- fs::path(dir_base, "unzipped")

zip_paths <- fs::dir_ls(path = dir_base, glob = "*.zip")

#----------- UNZIPPING ####
# purrr::map(
#   zip_paths,
#   ~zip::unzip(zipfile = .x, exdir = dir_unzip)
# )
#
# # Not available on site:
# idx_corrupt <- stringr::str_which(
#   string = zip_paths,
#   pattern = stringr::str_c(
#     "week123019_010520.zip",
#     "week122622_010123.zip",
#     "week122820_010321.zip",
#     "week122721_010222.zip",
#     "week122616_010117.zip",
#     "week123118_010619.zip",
#     "week122815_010316.zip",
#     "week080315_080915.zip",
#     sep = "|",
#     collapse = "|"
#     )
#   )
#
# zip_next <- zip_paths[rlang::seq2_along(max(idx_corrupt) + 1, zip_paths)]
#
# length(zip_paths) - length(zip_next)
#
# purrr::map(
#   zip_next,
#   ~zip::unzip(zipfile = .x, exdir = dir_unzip)
# )
#
# zip_again <- zip_paths[idx_unknown]
#
# purrr::map(
#   zip_again,
#   ~zip::unzip(zipfile = .x, exdir = dir_unzip),
#   .progress = TRUE
# )
#
# unzip_output <- .Last.value
# names(unzip_output)
# which(as.character(zip_paths) == names(unzip_output))
# all(zip_next[zip_next %in% zip_again] == zip_next)
# which(zip_next[zip_next %in% zip_paths] != zip_next)
# length(zip_paths) - length(zip_next)


week_list <- basename(zip_paths) |>
  stringr::str_remove_all(".zip|week") |>
  stringr::str_replace_all("_", "__") |>
  strex::str_split_by_numbers() |>
  purrr::list_transpose() |>
  purrr::discard_at(2) |>
  purrr::set_names(c("start", "end")) |>
  purrr::map(lubridate::mdy)

zip_weekly_dates <- dplyr::tibble(
  file = basename(zip_paths),
  year = as.integer(lubridate::year(week_list$start)),
  month = lubridate::month(week_list$start, abbr = TRUE, label = TRUE),
  week_start = week_list$start,
  week_end = week_list$end,
  size = fs::file_size(zip_paths),
  path = zip_paths,
  modified = fs::file_info(zip_paths)$modification_time,
  changed = fs::file_info(zip_paths)$change_time
)

unzipped_files <- fs::dir_info(dir_unzip) |>
  fuimus::remove_quiet() |>
  dplyr::reframe(
    size,
    modified = modification_time,
    changed = change_time,
    path,
    ext = tools::file_ext(path),
    file = strex::str_before_nth(basename(path), "_", 2),
    file = dplyr::if_else(
      stringr::str_detect(path, "fileheader|FileHeader"), "fileheader", file),
    week_dates = stringr::str_extract_all(path, stringr::regex("[0-9]{8}[-][0-9]{8}"))) |>
  tidyr::unnest(week_dates, keep_empty = TRUE) |>
  dplyr::mutate(
    week_start = strex::str_before_first(week_dates, "-") |> lubridate::ymd(),
    week_end = strex::str_after_first(week_dates, "-") |> lubridate::ymd(),
    week_dates = NULL,
    year = lubridate::year(week_start) |> as.integer(),
    month = lubridate::month(week_start, abbr = TRUE, label = TRUE),
    ) |>
  dplyr::filter(
    file != "fileheader",
    ext != "pdf"
  ) |>
  dplyr::select(
    file,
    # ext,
    year,
    month,
    week_start,
    week_end,
    size,
    path,
    modified,
    changed
  )

#----------- Weekly File Info pin ####
weekly_files <- list(
  zipped   = zip_weekly_dates,
  unzipped = unzipped_files
)

pin_update(
  x = weekly_files,
  name = "nber_weekly_info",
  title = "NBER NPI Weekly Data Information"
  )
