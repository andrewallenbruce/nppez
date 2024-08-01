# fs::dir_create("D:/NBER_NPI_Archives/weekly/unzipped")
dir_base  <- "D:/NBER_NPI_Archives/weekly"

dir_unzip <- fs::path(dir_base, "unzipped")

zip_paths <- fs::dir_ls(path = dir_base, glob = "*.zip")

zip_names <- basename(zip_paths) |>
  stringr::str_remove_all(".zip|week") |>
  stringr::str_replace_all("_", "__") |>
  strex::str_split_by_numbers() |>
  purrr::list_transpose() |>
  purrr::discard_at(2) |>
  purrr::set_names(c("start", "end")) |>
  purrr::map(lubridate::mdy) |>
  purrr::map(stringr::str_replace_all, "-", ".") |>
  purrr::list_transpose() |>
  purrr::map(paste0, collapse = "_") |>
  purrr::map(yasp::wrap, left = "week_", right = "") |>
  unlist(use.names = FALSE)

purrr::map(
  zip_paths,
  ~zip::unzip(zipfile = .x, exdir = dir_unzip)
)

# Corrupted Files:
# week123019_010520.zip
# week122622_010123.zip
# week122820_010321.zip
# week122721_010222.zip
# week122616_010117.zip
# week123118_010619.zip
# week122815_010316.zip

idx_corrupt <- stringr::str_which(
  string = zip_paths,
  pattern = stringr::str_c(
    "week123019_010520.zip",
    "week122622_010123.zip",
    "week122820_010321.zip",
    "week122721_010222.zip",
    "week122616_010117.zip",
    "week123118_010619.zip",
    "week122815_010316.zip",
    "week080315_080915.zip",
    sep = "|",
    collapse = "|"
    )
  )

zip_next <- zip_paths[rlang::seq2_along(max(idx_corrupt) + 1, zip_paths)]

length(zip_paths) - length(zip_next)

purrr::map(
  zip_next,
  ~zip::unzip(zipfile = .x, exdir = dir_unzip)
)

idx_unknown <- stringr::str_which(
  string = zip_paths,
  pattern = stringr::str_c(
    "week080315_080915",
    "week092815_100415",
    "week030716_031316",
    "week112315_112915",
    "week052316_052916",
    "week092523_100123",
    "week041822_042422",
    "week041122_041722",
    "week040615_041215",
    "week091018_091618",
    "week032723_040223",
    "week010719_011319",
    "week102521_103121",
    "week010322_010922",
    "week053016_060516",
    "week100316_100916",
    "week010217_010817",
    "week052917_060417",
    "week081417_082017",
    "week090417_091017",
    "week021918_022518",
    "week042318_042918",
    "week072318_072918",
    "week112717_120317",
    "week092418_093018",
    "week111218_111818",
    "week031119_031719",
    "week080519_081119",
    "week100719_101319",
    "week121619_122219",
    "week022420_030120",
    "week051820_052420",
    "week072020_072620",
    "week091420_092020",
    "week111620_112220",
    "week030821_031421",
    "week051021_051621",
    "week071921_072521",
    "week092021_092621",
    "week011722_012322",
    "week030722_031322",
    "week071122_071722",
    "week100322_100922",
    "week021323_021923",
    "week012516_013116",
    "week110915_111515",
    "week090516_091116",
    "week020617_021217",
    "week050817_051417",
    "week100217_100817",
    "week011518_012118",
    "week052118_052718",
    "week122418_123018",
    "week061019_061619",
    "week091619_092219",
    "week011320_011920",
    "week042020_042620",
    "week080320_080920",
    "week110220_110820",
    "week031521_032121",
    "week062121_062721",
    "week080921_081521",
    "week053022_060522",
    "week082922_090422",
    "week021720_022320",
    "week012323_012923",
    "week112816_120416",
    "week022717_030517",
    "week042919_050519",
    "week070119_070719",
    "week102218_102818",
    "week041921_042521",
    "week032816_040316",
    "week102416_103016",
    "week101617_102217",
    "week100520_101120",
    "week052024_052624",
    "week112822_120422",
    "week070416_071016",
    "week070317_070917",
    "week121916_122516",
    "week060418_061018",
    "week012819_020319",
    "week081219_081819",
    "week062920_070520",
    "week081020_081620",
    "week101022_101622",
    "week083115_090615",
    "week071017_071617",
    "week040218_040818",
    "week033020_040520",
    "week121420_122020",
    "week091321_091921",
    "week020116_020716",
    "week082216_082816",
    "week111521_112121",
    "week080822_081422",
    "week022618_030418",
    "week062722_070322",
    "week041017_041617",
    "week111819_112419",
    "week122115_122715",
    "week060120_060720",
    sep = "|",
    collapse = "|"
  )
)

zip_again <- zip_paths[idx_unknown]

purrr::map(
  zip_again,
  ~zip::unzip(zipfile = .x, exdir = dir_unzip),
  .progress = TRUE
)

unzip_output <- .Last.value

names(unzip_output)
which(as.character(zip_paths) == names(unzip_output))
all(zip_next[zip_next %in% zip_again] == zip_next)

which(zip_next[zip_next %in% zip_paths] != zip_next)


length(zip_paths) - length(zip_next)

fs::file_delete(here::here(fs::dir_ls(glob = "*.zip|*.xlsx")))


# TEST ####
fs::dir_info(dir_unzip) |>
  fuimus::remove_quiet() |>
  dplyr::reframe(
    path,
    size,
    modification_time,
    change_time
    )

npidate_pfile <- fs::dir_ls(dir_unzip, glob = "*npi*") |>
  stringr::str_subset("FileHeader|fileheader", negate = TRUE)

npidata_pfile_20240101_20240107 <- readr::read_csv(npidate_pfile[1], col_types = "c")

readr::problems(npidata_pfile_20240101_20240107)

week_list <- basename(zip_paths) |>
  stringr::str_remove_all(".zip|week") |>
  stringr::str_replace_all("_", "__") |>
  strex::str_split_by_numbers() |>
  purrr::list_transpose() |>
  purrr::discard_at(2) |>
  purrr::set_names(c("start", "end")) |>
  purrr::map(lubridate::mdy)

zip_weekly_dates <- dplyr::tibble(
  zip_name = basename(zip_paths),
  week_start = week_list$start,
  week_end = week_list$end,
  year_start = as.integer(lubridate::year(week_list$start)),
  year_end = as.integer(lubridate::year(week_list$end)),
  month_start = as.integer(lubridate::month(week_list$start)),
  month_end = as.integer(lubridate::month(week_list$end)),
  n_days = as.integer(week_list$end - week_list$start)
)

zip_weekly_dates

npidata_pfile_20240101_20240107 |>
  janitor::clean_names() |>
  fuimus::remove_quiet()
  dplyr::count(replacement_npi)

purrr::map(read_csv, col_types = "c")
