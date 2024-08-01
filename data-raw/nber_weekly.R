source(here::here("data-raw", "pins_functions.R"))

# fs::dir_create("D:/NBER_NPI_Archives/weekly/unzipped")
dir_base  <- "D:/NBER_NPI_Archives/weekly"

dir_unzip <- fs::path(dir_base, "unzipped")

zip_paths <- fs::dir_ls(path = dir_base, glob = "*.zip")


# Makes tidy names for zips
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

#----------- NPIData Base ####
npidata <- dplyr::filter(unzipped_files, file == "npidata_pfile")

release_id <- tools::file_path_sans_ext(basename(npidata$path[1]))

npi_raw <- tidytable::fread(
  npidata$path[1],
  colClasses = list(character = 1:330)) |>
  janitor::clean_names() |>
  fuimus::remove_quiet() |>
  purrr::map_dfr(fuimus::na_if_common) |>
  dplyr::mutate(id = id, .before = 1)

entity_levels <- c("Ind" = "1", "Org" = "2")

npi_base <- npi_raw |>
  dplyr::reframe(
    npi,
    updated = as.Date(last_update_date, format = "%m/%d/%Y"),
    certified = as.Date(certification_date, format = "%m/%d/%Y"),
    entity = forcats::fct(entity_type_code, levels = c("1", "2")) |> forcats::fct_recode(!!!levels),
    npi_rep = replacement_npi,
    enum_date = as.Date(provider_enumeration_date, format = "%m/%d/%Y"),
    deact_date = as.Date(npi_deactivation_date, format = "%m/%d/%Y"),
    react_date = as.Date(npi_reactivation_date, format = "%m/%d/%Y"),
    deact_code = npi_deactivation_reason_code,
    # ein = employer_identification_number_ein,
    sole_prop = is_sole_proprietor,
    org_sub = is_organization_subpart,
    parent_org_lbn = parent_organization_lbn,
    # parent_org_tin = parent_organization_tin,
    prov_org_lbn = provider_organization_name_legal_business_name,
    gender = provider_gender_code,
    prefix = provider_name_prefix_text,
    first = provider_first_name,
    middle = provider_middle_name,
    last = provider_last_name_legal_name,
    suffix = provider_name_suffix_text,
    credential = provider_credential_text
    ) |>
  fuimus::remove_quiet()

npi_base

collapse::fnunique(npi_ess$npi)

npi_other <- npi_raw |>
  dplyr::reframe(
    npi,
    other_org_name = provider_other_organization_name,
    other_org_type = provider_other_organization_name_type_code,
    other_prefix = provider_other_name_prefix_text,
    other_first = provider_other_first_name,
    other_middle = provider_other_middle_name,
    other_last = provider_other_last_name,
    other_last_type = provider_other_last_name_type_code,
    other_suffix = provider_other_name_suffix_text,
    other_credential = provider_other_credential_text
    ) |>
  dplyr::rowwise() |>
  dplyr::mutate(na_count = list(sum(is.na(dplyr::c_across(other_org_name:other_credential))))) |>
  tidyr::unnest(na_count) |>
  dplyr::filter(na_count < 9) |>
  dplyr::select(-na_count) |>
  fuimus::remove_quiet()

npi_other

npi_authorized_official <- npi_raw |>
  dplyr::reframe(
    npi,
    ao_prefix = authorized_official_name_prefix_text,
    ao_first = authorized_official_first_name,
    ao_middle = authorized_official_middle_name,
    ao_last = authorized_official_last_name,
    ao_suffix = authorized_official_name_suffix_text,
    ao_credential = authorized_official_credential_text,
    ao_title = authorized_official_title_or_position,
    ao_phone = authorized_official_telephone_number
    ) |>
  dplyr::rowwise() |>
  dplyr::mutate(na_count = list(sum(is.na(dplyr::c_across(ao_prefix:ao_phone))))) |>
  tidyr::unnest(na_count) |>
  dplyr::filter(na_count < 8) |>
  dplyr::select(-na_count) |>
  fuimus::remove_quiet()

npi_authorized_official

npi_address <- npi_raw |>
  dplyr::reframe(
    npi,
    mail_1 = provider_first_line_business_mailing_address,
    mail_2 = provider_second_line_business_mailing_address,
    mail_city = provider_business_mailing_address_city_name,
    mail_state = provider_business_mailing_address_state_name,
    mail_zip = provider_business_mailing_address_postal_code,
    mail_country = provider_business_mailing_address_country_code_if_outside_u_s,
    mail_phone = provider_business_mailing_address_telephone_number,
    mail_fax = provider_business_mailing_address_fax_number,
    prac_1 = provider_first_line_business_practice_location_address,
    prac_2 = provider_second_line_business_practice_location_address,
    prac_city = provider_business_practice_location_address_city_name,
    prac_state = provider_business_practice_location_address_state_name,
    prac_zip = provider_business_practice_location_address_postal_code,
    prac_country = provider_business_practice_location_address_country_code_if_outside_u_s,
    prac_phone = provider_business_practice_location_address_telephone_number,
    prac_fax = provider_business_practice_location_address_fax_number
  ) |>
  fuimus::combine(mail_address, c("mail_1", "mail_2"), sep = " ") |>
  fuimus::combine(prac_address, c("prac_1", "prac_2"), sep = " ") |>
  fuimus::remove_quiet()

npi_address

#----------- NPIData Taxonomy/License ####
npi_taxonomy_license <- npi_raw |>
  dplyr::select(npi,
    dplyr::matches(
      fuimus::single_line_string(
        "healthcare_provider_taxonomy_code|
        provider_license_number|
        provider_license_number_state_code|
        healthcare_provider_primary_taxonomy_switch|
        healthcare_provider_taxonomy_group")
      )
    ) |>
  fuimus::remove_quiet() |>
  dplyr::mutate(row_id = dplyr::row_number(), .before = 1) |>
  tidyr::pivot_longer(
    cols = healthcare_provider_taxonomy_code_1:healthcare_provider_taxonomy_group_15,
    names_to = c("variable", "group_id"),
    names_pattern = "(^[a-zA-Z_]+)_(.*)",
    values_to = "value",
    names_transform = list(group_id = as.integer)) |>
  dplyr::filter(!is.na(value)) |>
  dplyr::mutate(
    variable = dplyr::case_match(
      variable,
      "healthcare_provider_primary_taxonomy_switch" ~ "taxonomy_primary",
      "healthcare_provider_taxonomy_code"           ~ "taxonomy_code",
      "healthcare_provider_taxonomy_group"          ~ "taxonomy_group",
      "provider_license_number"                     ~ "license_number",
      "provider_license_number_state_code"          ~ "license_state",
      .default = variable)) |>
  dplyr::group_by(npi, group_id) |>
  tidyr::pivot_wider(
    names_from = variable,
    values_from = value
  ) |>
  dplyr::ungroup() |>
  dplyr::reframe(
    npi,
    taxonomy_code,
    taxonomy_group = substr(taxonomy_group, 1, 10),
    taxonomy_primary = forcats::fct(
      taxonomy_primary,
      levels = c("Y", "N", "X")),
    license_number,
    license_state
    )

npi_taxonomy_license

#----------- NPIData Other Identifiers ####
npi_identifiers <- npi_raw |>
  dplyr::select(npi,
    dplyr::matches("other_provider_identifier_")) |>
  fuimus::remove_quiet() |>
  dplyr::mutate(row_id = dplyr::row_number(), .before = 1) |>
  tidyr::pivot_longer(
    cols = dplyr::starts_with("other_provider_identifier_"),
    names_to = c("variable", "group_id"),
    names_pattern = "(^[a-zA-Z_]+)_(.*)",
    values_to = "value",
    names_transform = list(group_id = as.integer)) |>
  dplyr::filter(!is.na(value)) |>
  dplyr::mutate(
    variable = dplyr::case_match(
      variable,
      "other_provider_identifier"           ~ "other_id",
      "other_provider_identifier_type_code" ~ "other_id_code",
      "other_provider_identifier_issuer"    ~ "other_id_issuer",
      "other_provider_identifier_state"     ~ "other_id_state",
      .default = variable
    )
  ) |>
  dplyr::group_by(npi, group_id) |>
  tidyr::pivot_wider(
    names_from = variable,
    values_from = value
  ) |>
  dplyr::ungroup() |>
  dplyr::reframe(
    npi,
    other_id,
    other_id_code,
    other_id_state,
    other_id_issuer
  )

npi_identifiers

#----------- Weekly Release pin ####
npi_wk_040124 <- list(
  release = release_id,
  base = npi_base,
  addr = npi_address,
  other = npi_other,
  ao = npi_authorized_official,
  tax = npi_taxonomy_license,
  ids = npi_identifiers
)

pin_update(
  x = npi_wk_040124,
  name = "npi_wk_040124",
  title = "NBER NPI Weekly Release 04-01-24"
)
