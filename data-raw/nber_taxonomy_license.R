source(here::here("data-raw", "pins_functions.R"))

get_pin("nber_weekly_info")

#----------- NPIData Base ####
npidata <- dplyr::filter(get_pin("nber_weekly_info")$unzipped, file == "npidata_pfile")

release_id <- tools::file_path_sans_ext(basename(npidata$path[1]))

npi_raw <- tidytable::fread(
  npidata$path[1],
  colClasses = list(character = 1:330)) |>
  janitor::clean_names() |>
  fuimus::remove_quiet() |>
  purrr::map_dfr(fuimus::na_if_common)

entity_levels <- c("Ind" = "1", "Org" = "2")

npi_base <- npi_raw |>
  dplyr::reframe(
    npi,
    updated = as.Date(last_update_date, format = "%m/%d/%Y"),
    certified = as.Date(certification_date, format = "%m/%d/%Y"),
    entity = forcats::fct(entity_type_code, levels = c("1", "2")) |> forcats::fct_recode(!!!entity_levels),
    npi_rep = replacement_npi,
    enum_date = as.Date(provider_enumeration_date, format = "%m/%d/%Y"),
    deact_date = as.Date(npi_deactivation_date, format = "%m/%d/%Y"),
    react_date = as.Date(npi_reactivation_date, format = "%m/%d/%Y"),
    deact_code = npi_deactivation_reason_code,
    sole_prop = is_sole_proprietor,
    org_sub = is_organization_subpart,
    parent_org_lbn = parent_organization_lbn,
    prov_org_lbn = provider_organization_name_legal_business_name,
    gender = provider_gender_code,
    prefix = provider_name_prefix_text,
    first = provider_first_name,
    middle = provider_middle_name,
    last = provider_last_name_legal_name,
    suffix = provider_name_suffix_text,
    credential = clean_credentials(provider_credential_text)
  ) |>
  fuimus::remove_quiet()

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
    other_credential = clean_credentials(provider_other_credential_text)
  )

npi_other <- vctrs::vec_slice(npi_other, which(cheapr::row_na_counts(npi_other) < 9))

npi_auth_ofc <- npi_raw |>
  dplyr::reframe(
    npi,
    ao_prefix = authorized_official_name_prefix_text,
    ao_first = authorized_official_first_name,
    ao_middle = authorized_official_middle_name,
    ao_last = authorized_official_last_name,
    ao_suffix = authorized_official_name_suffix_text,
    ao_credential = clean_credentials(authorized_official_credential_text),
    ao_title = authorized_official_title_or_position,
    ao_phone = authorized_official_telephone_number
  )

npi_auth_ofc <- vctrs::vec_slice(npi_auth_ofc, which(cheapr::row_na_counts(npi_auth_ofc) < 8))

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
  purrr::map_dfr(fuimus::na_if_common) |>
  fuimus::remove_quiet()

cols_pattern <- fuimus::single_line_string("
healthcare_provider_taxonomy_code
|provider_license_number
|provider_license_number_state_code
|healthcare_provider_primary_taxonomy_switch
|healthcare_provider_taxonomy_group")

npi_tax_lis <- npi_raw |>
  dplyr::select(npi, dplyr::matches(rlang::as_string(cols_pattern))) |>
  fuimus::remove_quiet() |>
  dplyr::mutate(row_id = dplyr::row_number(), .before = 1) |>
  tidyr::pivot_longer(
    cols = dplyr::matches(rlang::as_string(cols_pattern)),
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
  tidyr::pivot_wider(names_from = variable, values_from = value) |>
  dplyr::ungroup() |>
  dplyr::reframe(
    npi,
    taxonomy_code,
    taxonomy_group = substr(taxonomy_group, 1, 10),
    taxonomy_primary = forcats::fct(taxonomy_primary, levels = c("Y", "N", "X")),
    license_number,
    license_state) |>
  dplyr::arrange(npi, taxonomy_primary)

npi_identifiers <- npi_raw |>
  dplyr::select(npi, dplyr::starts_with("other_provider_identifier_")) |>
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
      .default = variable)) |>
  dplyr::group_by(npi, group_id) |>
  tidyr::pivot_wider(names_from = variable, values_from = value) |>
  dplyr::ungroup() |>
  dplyr::reframe(
    npi,
    other_id,
    other_id_code,
    other_id_state,
    other_id_issuer
  )

create_zip_file_names(release_id, format = "%Y%m%d")

aweek::date2week("2024-01-01")

npidata |>
  dplyr::mutate(
    year_week = grates::as_yearweek(week_start), .before = 2,
    )
# aweek = aweek::date2week(week_start, factor = TRUE, floor_day = TRUE),

aweek::date2week(npidata$week_start[1])
grates::as_yearweek(npidata$week_start[1]
  # as.Date(npidata$week_start[1])
  )
#----------- Weekly Release pin ####
npi_week <- list(
  release = create_zip_file_names(release_id, format = "%Y%m%d"),
  basic = npi_base,
  address = npi_address,
  other = npi_other,
  authorized = npi_auth_ofc,
  taxonomy = npi_tax_lis,
  identifier = npi_identifiers
)

pin_update(
  x = npi_week,
  name = "wk20240101",
  title = "NBER NPI Weekly Release 2024-01-01"
)
