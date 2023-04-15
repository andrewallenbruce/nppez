#' Clean the Monthly NPPES NPI Deactivation File
#' @param dir_xlsx path to directory that the Monthly Deactivation Excel (.xlsx) file resides in (do not include file name at the end)
#' @return tibble of cleaned data
#' @examples
#' \dontrun{
#' clean_deactivation("D:/<directory>")
#' }
#' @autoglobal
#' @export
clean_deactivation <- function(dir_xlsx) {

  path <- list.files(dir_xlsx,
                     pattern = "[.]xlsx$",
                     full.names = TRUE)

  cols <- readxl::read_xlsx(path = path, range = "A1:B2",
                            .name_repair = janitor::make_clean_names) |>
    unlist(use.names = FALSE) |>
    janitor::make_clean_names() |>
    stringr::str_remove("nppes_")

  results <- readxl::read_xlsx(path = path, sheet = 1,
                               skip = 2, trim_ws = TRUE,
                               .name_repair = janitor::make_clean_names,
                               col_names = cols, col_types = c("text")) |>
    dplyr::mutate(deactivation_date = clock::date_parse(deactivation_date,
                                                        format = "%m/%d/%Y"))

  results$release_date <- stringr::str_extract(path, "\\d{8}") |>
    clock::date_parse(format = "%Y%m%d")

  return(results)

}

#' Clean the Monthly NPPES NPI Endpoints File
#' @param csv full path to Monthly NPPES Endpoints file (.csv)
#' @return tibble of cleaned data
#' @examples
#' \dontrun{
#' clean_endpoints("D:/<directory>/<filename>.csv")
#' }
#' @autoglobal
#' @export
clean_endpoints <- function(csv) {

  path <- list.files(xlsx,
                     pattern = "[.]xlsx$",
                     full.names = TRUE)

  cols <- readxl::read_xlsx(path = path, range = "A1:B2",
                            .name_repair = janitor::make_clean_names) |>
    unlist(use.names = FALSE) |>
    janitor::make_clean_names() |>
    stringr::str_remove("nppes_")

  results <- readxl::read_xlsx(path = path, sheet = 1,
                               skip = 2, trim_ws = TRUE,
                               .name_repair = janitor::make_clean_names,
                               col_names = cols, col_types = c("text")) |>
    dplyr::mutate(deactivation_date = clock::date_parse(deactivation_date,
                                                        format = "%m/%d/%Y"))

  results$release_date <- stringr::str_extract(path, "\\d{8}") |>
    clock::date_parse(format = "%Y%m%d")

  return(results)

}

#' Clean the Weekly NPPES NPI Update File
#' @param csv full path to Weekly NPPES NPI Update (.csv) file
#' @return tibble of cleaned data
#' @examples
#' \dontrun{
#' clean_weekly_update("D:/<directory>/<filename>.csv")
#' }
#' @autoglobal
#' @export
clean_weekly_update <- function(csv) {

  week_file <- readr::read_csv(
    "D:/nppez_data/unzips/weekly/npidata_pfile_20230403-20230409.csv",
    col_types = stringr::str_flatten(rep("c", 330)),
    name_repair = janitor::make_clean_names)

  week_file <- week_file |>
    dplyr::select(
      npi,
      entity_type = entity_type_code,
      replacement_npi,
      ein = employer_identification_number_ein,
      organization_legal_name = provider_organization_name_legal_business_name,
      last_name = provider_last_name_legal_name,
      first_name = provider_first_name,
      middle_name = provider_middle_name,
      prefix_name = provider_name_prefix_text,
      suffix_name = provider_name_suffix_text,
      credential = provider_credential_text,
      organization_other_name = provider_other_organization_name,
      organization_other_type = provider_other_organization_name_type_code,
      other_last_name = provider_other_last_name,
      other_first_name = provider_other_first_name,
      other_middle_name = provider_other_middle_name,
      other_prefix_name = provider_other_name_prefix_text,
      other_suffix_name = provider_other_name_suffix_text,
      other_credential = provider_other_credential_text,
      other_last_name_type = provider_other_last_name_type_code,
      address_mailing_line1 = provider_first_line_business_mailing_address,
      address_mailing_line2 = provider_second_line_business_mailing_address,
      address_mailing_city = provider_business_mailing_address_city_name,
      address_mailing_state = provider_business_mailing_address_state_name,
      address_mailing_zip = provider_business_mailing_address_postal_code,
      address_mailing_country = provider_business_mailing_address_country_code_if_outside_u_s,
      address_mailing_phone = provider_business_mailing_address_telephone_number,
      address_mailing_fax = provider_business_mailing_address_fax_number,
      address_practice_line1 = provider_first_line_business_practice_location_address,
      address_practice_line2 = provider_second_line_business_practice_location_address,
      address_practice_city = provider_business_practice_location_address_city_name,
      address_practice_state = provider_business_practice_location_address_state_name,
      address_practice_zip = provider_business_practice_location_address_postal_code,
      address_practice_country = provider_business_practice_location_address_country_code_if_outside_u_s,
      address_practice_phone = provider_business_practice_location_address_telephone_number,
      address_practice_fax = provider_business_practice_location_address_fax_number,
      enumeration_date = provider_enumeration_date,
      certification_date,
      last_updated = last_update_date,
      npi_deactivation_reason_code = npi_deactivation_reason_code,
      npi_deactivation_date = npi_deactivation_date,
      npi_reactivation_date = npi_reactivation_date,
      gender = provider_gender_code,
      authoff_last_name = authorized_official_last_name,
      authoff_first_name = authorized_official_first_name,
      authoff_middle_name = authorized_official_middle_name,
      authoff_prefix_name = authorized_official_name_prefix_text,
      authoff_suffix_name = authorized_official_name_suffix_text,
      authoff_credential = authorized_official_credential_text,
      authoff_position = authorized_official_title_or_position,
      authoff_phone = authorized_official_telephone_number,
      is_sole_proprietor,
      is_organization_subpart,
      parent_organization_lbn,
      parent_organization_tin,
      taxonomy_code_1 = healthcare_provider_taxonomy_code_1,
      primary_taxonomy_switch_1 = healthcare_provider_primary_taxonomy_switch_1,
      taxonomy_group_1 = healthcare_provider_taxonomy_group_1,
      license_number_1 = provider_license_number_1,
      license_state_1 = provider_license_number_state_code_1,
      taxonomy_code_2 = healthcare_provider_taxonomy_code_2,
      primary_taxonomy_switch_2 = healthcare_provider_primary_taxonomy_switch_2,
      taxonomy_group_2 = healthcare_provider_taxonomy_group_2,
      license_number_2 = provider_license_number_2,
      license_state_2 = provider_license_number_state_code_2,
      taxonomy_code_3 = healthcare_provider_taxonomy_code_3,
      primary_taxonomy_switch_3 = healthcare_provider_primary_taxonomy_switch_3,
      taxonomy_group_3 = healthcare_provider_taxonomy_group_3,
      license_number_3 = provider_license_number_3,
      license_state_3 = provider_license_number_state_code_3,
      taxonomy_code_4 = healthcare_provider_taxonomy_code_4,
      primary_taxonomy_switch_4 = healthcare_provider_primary_taxonomy_switch_4,
      taxonomy_group_4 = healthcare_provider_taxonomy_group_4,
      license_number_4 = provider_license_number_4,
      license_state_4 = provider_license_number_state_code_4,
      taxonomy_code_5 = healthcare_provider_taxonomy_code_5,
      primary_taxonomy_switch_5 = healthcare_provider_primary_taxonomy_switch_5,
      taxonomy_group_5 = healthcare_provider_taxonomy_group_5,
      license_number_5 = provider_license_number_5,
      license_state_5 = provider_license_number_state_code_5,
      taxonomy_code_6 = healthcare_provider_taxonomy_code_6,
      primary_taxonomy_switch_6 = healthcare_provider_primary_taxonomy_switch_6,
      taxonomy_group_6 = healthcare_provider_taxonomy_group_6,
      license_number_6 = provider_license_number_6,
      license_state_6 = provider_license_number_state_code_6,
      taxonomy_code_7 = healthcare_provider_taxonomy_code_7,
      primary_taxonomy_switch_7 = healthcare_provider_primary_taxonomy_switch_7,
      taxonomy_group_7 = healthcare_provider_taxonomy_group_7,
      license_number_7 = provider_license_number_7,
      license_state_7 = provider_license_number_state_code_7,
      taxonomy_code_8 = healthcare_provider_taxonomy_code_8,
      primary_taxonomy_switch_8 = healthcare_provider_primary_taxonomy_switch_8,
      taxonomy_group_8 = healthcare_provider_taxonomy_group_8,
      license_number_8 = provider_license_number_8,
      license_state_8 = provider_license_number_state_code_8,
      taxonomy_code_9 = healthcare_provider_taxonomy_code_9,
      primary_taxonomy_switch_9 = healthcare_provider_primary_taxonomy_switch_9,
      taxonomy_group_9 = healthcare_provider_taxonomy_group_9,
      license_number_9 = provider_license_number_9,
      license_state_9 = provider_license_number_state_code_9,
      taxonomy_code_10 = healthcare_provider_taxonomy_code_10,
      primary_taxonomy_switch_10 = healthcare_provider_primary_taxonomy_switch_10,
      taxonomy_group_10 = healthcare_provider_taxonomy_group_10,
      license_number_10 = provider_license_number_10,
      license_state_10 = provider_license_number_state_code_10,
      taxonomy_code_11 = healthcare_provider_taxonomy_code_11,
      primary_taxonomy_switch_11 = healthcare_provider_primary_taxonomy_switch_11,
      taxonomy_group_11 = healthcare_provider_taxonomy_group_11,
      license_number_11 = provider_license_number_11,
      license_state_11 = provider_license_number_state_code_11,
      taxonomy_code_12 = healthcare_provider_taxonomy_code_12,
      primary_taxonomy_switch_12 = healthcare_provider_primary_taxonomy_switch_12,
      taxonomy_group_12 = healthcare_provider_taxonomy_group_12,
      license_number_12 = provider_license_number_12,
      license_state_12 = provider_license_number_state_code_12,
      taxonomy_code_13 = healthcare_provider_taxonomy_code_13,
      primary_taxonomy_switch_13 = healthcare_provider_primary_taxonomy_switch_13,
      taxonomy_group_13 = healthcare_provider_taxonomy_group_13,
      license_number_13 = provider_license_number_13,
      license_state_13 = provider_license_number_state_code_13,
      taxonomy_code_14 = healthcare_provider_taxonomy_code_14,
      primary_taxonomy_switch_14 = healthcare_provider_primary_taxonomy_switch_14,
      taxonomy_group_14 = healthcare_provider_taxonomy_group_14,
      license_number_14 = provider_license_number_14,
      license_state_14 = provider_license_number_state_code_14,
      taxonomy_code_15 = healthcare_provider_taxonomy_code_15,
      primary_taxonomy_switch_15 = healthcare_provider_primary_taxonomy_switch_15,
      taxonomy_group_15 = healthcare_provider_taxonomy_group_15,
      license_number_15 = provider_license_number_15,
      license_state_15 = provider_license_number_state_code_15,
      identifier_1 = other_provider_identifier_1,
      identifier_2 = other_provider_identifier_2,
      identifier_3 = other_provider_identifier_3,
      identifier_4 = other_provider_identifier_4,
      identifier_5 = other_provider_identifier_5,
      identifier_6 = other_provider_identifier_6,
      identifier_7 = other_provider_identifier_7,
      identifier_8 = other_provider_identifier_8,
      identifier_9 = other_provider_identifier_9,
      identifier_10 = other_provider_identifier_10,
      identifier_11 = other_provider_identifier_11,
      identifier_12 = other_provider_identifier_12,
      identifier_13 = other_provider_identifier_13,
      identifier_14 = other_provider_identifier_14,
      identifier_15 = other_provider_identifier_15,
      identifier_16 = other_provider_identifier_16,
      identifier_17 = other_provider_identifier_17,
      identifier_18 = other_provider_identifier_18,
      identifier_19 = other_provider_identifier_19,
      identifier_20 = other_provider_identifier_20,
      identifier_21 = other_provider_identifier_21,
      identifier_22 = other_provider_identifier_22,
      identifier_23 = other_provider_identifier_23,
      identifier_24 = other_provider_identifier_24,
      identifier_25 = other_provider_identifier_25,
      identifier_26 = other_provider_identifier_26,
      identifier_27 = other_provider_identifier_27,
      identifier_28 = other_provider_identifier_28,
      identifier_29 = other_provider_identifier_29,
      identifier_30 = other_provider_identifier_30,
      identifier_31 = other_provider_identifier_31,
      identifier_32 = other_provider_identifier_32,
      identifier_33 = other_provider_identifier_33,
      identifier_34 = other_provider_identifier_34,
      identifier_35 = other_provider_identifier_35,
      identifier_36 = other_provider_identifier_36,
      identifier_37 = other_provider_identifier_37,
      identifier_38 = other_provider_identifier_38,
      identifier_39 = other_provider_identifier_39,
      identifier_40 = other_provider_identifier_40,
      identifier_41 = other_provider_identifier_41,
      identifier_42 = other_provider_identifier_42,
      identifier_43 = other_provider_identifier_43,
      identifier_44 = other_provider_identifier_44,
      identifier_45 = other_provider_identifier_45,
      identifier_46 = other_provider_identifier_46,
      identifier_47 = other_provider_identifier_47,
      identifier_48 = other_provider_identifier_48,
      identifier_49 = other_provider_identifier_49,
      identifier_50 = other_provider_identifier_50,
      identifier_type_1 = other_provider_identifier_type_code_1,
      identifier_type_2 = other_provider_identifier_type_code_2,
      identifier_type_3 = other_provider_identifier_type_code_3,
      identifier_type_4 = other_provider_identifier_type_code_4,
      identifier_type_5 = other_provider_identifier_type_code_5,
      identifier_type_6 = other_provider_identifier_type_code_6,
      identifier_type_7 = other_provider_identifier_type_code_7,
      identifier_type_8 = other_provider_identifier_type_code_8,
      identifier_type_9 = other_provider_identifier_type_code_9,
      identifier_type_10 = other_provider_identifier_type_code_10,
      identifier_type_11 = other_provider_identifier_type_code_11,
      identifier_type_12 = other_provider_identifier_type_code_12,
      identifier_type_13 = other_provider_identifier_type_code_13,
      identifier_type_14 = other_provider_identifier_type_code_14,
      identifier_type_15 = other_provider_identifier_type_code_15,
      identifier_type_16 = other_provider_identifier_type_code_16,
      identifier_type_17 = other_provider_identifier_type_code_17,
      identifier_type_18 = other_provider_identifier_type_code_18,
      identifier_type_19 = other_provider_identifier_type_code_19,
      identifier_type_20 = other_provider_identifier_type_code_20,
      identifier_type_21 = other_provider_identifier_type_code_21,
      identifier_type_22 = other_provider_identifier_type_code_22,
      identifier_type_23 = other_provider_identifier_type_code_23,
      identifier_type_24 = other_provider_identifier_type_code_24,
      identifier_type_25 = other_provider_identifier_type_code_25,
      identifier_type_26 = other_provider_identifier_type_code_26,
      identifier_type_27 = other_provider_identifier_type_code_27,
      identifier_type_28 = other_provider_identifier_type_code_28,
      identifier_type_29 = other_provider_identifier_type_code_29,
      identifier_type_30 = other_provider_identifier_type_code_30,
      identifier_type_31 = other_provider_identifier_type_code_31,
      identifier_type_32 = other_provider_identifier_type_code_32,
      identifier_type_33 = other_provider_identifier_type_code_33,
      identifier_type_34 = other_provider_identifier_type_code_34,
      identifier_type_35 = other_provider_identifier_type_code_35,
      identifier_type_36 = other_provider_identifier_type_code_36,
      identifier_type_37 = other_provider_identifier_type_code_37,
      identifier_type_38 = other_provider_identifier_type_code_38,
      identifier_type_39 = other_provider_identifier_type_code_39,
      identifier_type_40 = other_provider_identifier_type_code_40,
      identifier_type_41 = other_provider_identifier_type_code_41,
      identifier_type_42 = other_provider_identifier_type_code_42,
      identifier_type_43 = other_provider_identifier_type_code_43,
      identifier_type_44 = other_provider_identifier_type_code_44,
      identifier_type_45 = other_provider_identifier_type_code_45,
      identifier_type_46 = other_provider_identifier_type_code_46,
      identifier_type_47 = other_provider_identifier_type_code_47,
      identifier_type_48 = other_provider_identifier_type_code_48,
      identifier_type_49 = other_provider_identifier_type_code_49,
      identifier_type_50 = other_provider_identifier_type_code_50,
      identifier_state_1 = other_provider_identifier_state_1,
      identifier_state_2 = other_provider_identifier_state_2,
      identifier_state_3 = other_provider_identifier_state_3,
      identifier_state_4 = other_provider_identifier_state_4,
      identifier_state_5 = other_provider_identifier_state_5,
      identifier_state_6 = other_provider_identifier_state_6,
      identifier_state_7 = other_provider_identifier_state_7,
      identifier_state_8 = other_provider_identifier_state_8,
      identifier_state_9 = other_provider_identifier_state_9,
      identifier_state_10 = other_provider_identifier_state_10,
      identifier_state_11 = other_provider_identifier_state_11,
      identifier_state_12 = other_provider_identifier_state_12,
      identifier_state_13 = other_provider_identifier_state_13,
      identifier_state_14 = other_provider_identifier_state_14,
      identifier_state_15 = other_provider_identifier_state_15,
      identifier_state_16 = other_provider_identifier_state_16,
      identifier_state_17 = other_provider_identifier_state_17,
      identifier_state_18 = other_provider_identifier_state_18,
      identifier_state_19 = other_provider_identifier_state_19,
      identifier_state_20 = other_provider_identifier_state_20,
      identifier_state_21 = other_provider_identifier_state_21,
      identifier_state_22 = other_provider_identifier_state_22,
      identifier_state_23 = other_provider_identifier_state_23,
      identifier_state_24 = other_provider_identifier_state_24,
      identifier_state_25 = other_provider_identifier_state_25,
      identifier_state_26 = other_provider_identifier_state_26,
      identifier_state_27 = other_provider_identifier_state_27,
      identifier_state_28 = other_provider_identifier_state_28,
      identifier_state_29 = other_provider_identifier_state_29,
      identifier_state_30 = other_provider_identifier_state_30,
      identifier_state_31 = other_provider_identifier_state_31,
      identifier_state_32 = other_provider_identifier_state_32,
      identifier_state_33 = other_provider_identifier_state_33,
      identifier_state_34 = other_provider_identifier_state_34,
      identifier_state_35 = other_provider_identifier_state_35,
      identifier_state_36 = other_provider_identifier_state_36,
      identifier_state_37 = other_provider_identifier_state_37,
      identifier_state_38 = other_provider_identifier_state_38,
      identifier_state_39 = other_provider_identifier_state_39,
      identifier_state_40 = other_provider_identifier_state_40,
      identifier_state_41 = other_provider_identifier_state_41,
      identifier_state_42 = other_provider_identifier_state_42,
      identifier_state_43 = other_provider_identifier_state_43,
      identifier_state_44 = other_provider_identifier_state_44,
      identifier_state_45 = other_provider_identifier_state_45,
      identifier_state_46 = other_provider_identifier_state_46,
      identifier_state_47 = other_provider_identifier_state_47,
      identifier_state_48 = other_provider_identifier_state_48,
      identifier_state_49 = other_provider_identifier_state_49,
      identifier_state_50 = other_provider_identifier_state_50,
      identifier_issuer_1 = other_provider_identifier_issuer_1,
      identifier_issuer_2 = other_provider_identifier_issuer_2,
      identifier_issuer_3 = other_provider_identifier_issuer_3,
      identifier_issuer_4 = other_provider_identifier_issuer_4,
      identifier_issuer_5 = other_provider_identifier_issuer_5,
      identifier_issuer_6 = other_provider_identifier_issuer_6,
      identifier_issuer_7 = other_provider_identifier_issuer_7,
      identifier_issuer_8 = other_provider_identifier_issuer_8,
      identifier_issuer_9 = other_provider_identifier_issuer_9,
      identifier_issuer_10 = other_provider_identifier_issuer_10,
      identifier_issuer_11 = other_provider_identifier_issuer_11,
      identifier_issuer_12 = other_provider_identifier_issuer_12,
      identifier_issuer_13 = other_provider_identifier_issuer_13,
      identifier_issuer_14 = other_provider_identifier_issuer_14,
      identifier_issuer_15 = other_provider_identifier_issuer_15,
      identifier_issuer_16 = other_provider_identifier_issuer_16,
      identifier_issuer_17 = other_provider_identifier_issuer_17,
      identifier_issuer_18 = other_provider_identifier_issuer_18,
      identifier_issuer_19 = other_provider_identifier_issuer_19,
      identifier_issuer_20 = other_provider_identifier_issuer_20,
      identifier_issuer_21 = other_provider_identifier_issuer_21,
      identifier_issuer_22 = other_provider_identifier_issuer_22,
      identifier_issuer_23 = other_provider_identifier_issuer_23,
      identifier_issuer_24 = other_provider_identifier_issuer_24,
      identifier_issuer_25 = other_provider_identifier_issuer_25,
      identifier_issuer_26 = other_provider_identifier_issuer_26,
      identifier_issuer_27 = other_provider_identifier_issuer_27,
      identifier_issuer_28 = other_provider_identifier_issuer_28,
      identifier_issuer_29 = other_provider_identifier_issuer_29,
      identifier_issuer_30 = other_provider_identifier_issuer_30,
      identifier_issuer_31 = other_provider_identifier_issuer_31,
      identifier_issuer_32 = other_provider_identifier_issuer_32,
      identifier_issuer_33 = other_provider_identifier_issuer_33,
      identifier_issuer_34 = other_provider_identifier_issuer_34,
      identifier_issuer_35 = other_provider_identifier_issuer_35,
      identifier_issuer_36 = other_provider_identifier_issuer_36,
      identifier_issuer_37 = other_provider_identifier_issuer_37,
      identifier_issuer_38 = other_provider_identifier_issuer_38,
      identifier_issuer_39 = other_provider_identifier_issuer_39,
      identifier_issuer_40 = other_provider_identifier_issuer_40,
      identifier_issuer_41 = other_provider_identifier_issuer_41,
      identifier_issuer_42 = other_provider_identifier_issuer_42,
      identifier_issuer_43 = other_provider_identifier_issuer_43,
      identifier_issuer_44 = other_provider_identifier_issuer_44,
      identifier_issuer_45 = other_provider_identifier_issuer_45,
      identifier_issuer_46 = other_provider_identifier_issuer_46,
      identifier_issuer_47 = other_provider_identifier_issuer_47,
      identifier_issuer_48 = other_provider_identifier_issuer_48,
      identifier_issuer_49 = other_provider_identifier_issuer_49,
      identifier_issuer_50 = other_provider_identifier_issuer_50)

  week_file <- week_file |>
    tidyr::unite("address_mailing_street",
                 address_mailing_line1:address_mailing_line2,
                 remove = TRUE, na.rm = TRUE) |>
    tidyr::unite("address_practice_street",
                 address_practice_line1:address_practice_line2,
                 remove = TRUE, na.rm = TRUE) |>
    dplyr::mutate(ein = dplyr::na_if(ein, "<UNAVAIL>"),
                  enumeration_date = clock::date_parse(enumeration_date, format = "%m/%d/%Y"),
                  certification_date = clock::date_parse(certification_date, format = "%m/%d/%Y"),
                  last_updated = clock::date_parse(last_updated, format = "%m/%d/%Y"),
                  npi_deactivation_date = clock::date_parse(npi_deactivation_date, format = "%m/%d/%Y"),
                  npi_reactivation_date = clock::date_parse(npi_reactivation_date, format = "%m/%d/%Y"),
                  entity_type = dplyr::case_when(entity_type == "1" ~ "Individual",
                                                 entity_type == "2" ~ "Organization",
                                                 is.na(entity_type) ~ NA))
  ####### COMPARE TO DELETIONS
  week_deactivate <- week_file |>
    dplyr::filter(is.na(gender), is.na(entity_type)) |>
    dplyr::select(npi)

  ###### REMOVE DELETIONS
  week_file <- week_file |>
    dplyr::anti_join(week_deactivate)

  return(week_file)

}
