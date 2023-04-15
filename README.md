
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {nppez}

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the development version of {nppez} from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("andrewallenbruce/nppez")
```

``` r
library(nppez)
```

# Browse

``` r
nppez::browse()
```

| date       | file                                                 |    size | zip_url                                                                            |
|:-----------|:-----------------------------------------------------|--------:|:-----------------------------------------------------------------------------------|
| 2023-04-10 | NPPES Data Dissemination                             | 851.05M | <https://download.cms.gov/nppes/NPPES_Data_Dissemination_April_2023.zip>           |
| 2023-04-10 | NPPES Data Dissemination Monthly Deactivation Update |   1.78M | <https://download.cms.gov/nppes/NPPES_Deactivated_NPI_Report_041023.zip>           |
| 2023-04-03 | NPPES Data Dissemination Weekly Update               |   3.62M | <https://download.cms.gov/nppes/NPPES_Data_Dissemination_040323_040923_Weekly.zip> |

# Grab

``` r
nppez::grab(dir = "D:/nppez_data/zips/")
```

| date       |    size | filename                                                             |
|:-----------|--------:|:---------------------------------------------------------------------|
| 2023-04-12 |   3.62M | D:/nppez_data/zips/NPPES_Data_Dissemination_040323_040923_Weekly.zip |
| 2023-04-12 | 851.05M | D:/nppez_data/zips/NPPES_Data_Dissemination_April_2023.zip           |
| 2023-04-12 |   1.78M | D:/nppez_data/zips/NPPES_Deactivated_NPI_Report_041023.zip           |

# Peek

``` r
peek <- nppez::peek(dir = "D:/nppez_data/zips/")
```

``` r
peek |> 
  dplyr::group_by(parent_zip) |> 
  dplyr::mutate(csv = stringr::str_extract_all(filename, "[.]csv$")) |> 
  tidyr::unnest(csv) |>
  dplyr::mutate(fileheader = stringr::str_ends(filename, "fileheader[.]csv$", negate = TRUE)) |> 
  dplyr::filter(fileheader == TRUE) |>
  dplyr::mutate(csv = NULL, fileheader = NULL) |> 
  dplyr::summarise(size_compressed = sum(size_compressed),
                   size_uncompressed = sum(size_uncompressed)) |> 
  gluedown::md_table()
```

| parent_zip                                        | size_compressed | size_uncompressed |
|:--------------------------------------------------|----------------:|------------------:|
| NPPES_Data_Dissemination_040323_040923_Weekly.zip |           2.72M |            29.16M |
| NPPES_Data_Dissemination_April_2023.zip           |         850.15M |             8.84G |

``` r
peek |> 
  dplyr::filter(parent_zip == "NPPES_Data_Dissemination_040323_040923_Weekly.zip") |> 
  dplyr::mutate(csv = stringr::str_extract_all(filename, "[.]csv$")) |> 
  tidyr::unnest(csv) |>
  dplyr::mutate(fileheader = stringr::str_ends(filename, "fileheader[.]csv$", negate = TRUE)) |> 
  dplyr::filter(fileheader == TRUE) |>
  dplyr::mutate(csv = NULL, fileheader = NULL) |> 
  gluedown::md_table()
```

| parent_zip                                        | filename                              | size_compressed | size_uncompressed |
|:--------------------------------------------------|:--------------------------------------|----------------:|------------------:|
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | npidata_pfile_20230403-20230409.csv   |           2.48M |             28.3M |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | endpoint_pfile_20230403-20230409.csv  |          64.08K |              330K |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | pl_pfile_20230403-20230409.csv        |         147.18K |            431.4K |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | othername_pfile_20230403-20230409.csv |           30.7K |             86.4K |

``` r
peek |> 
dplyr::filter(parent_zip == "NPPES_Data_Dissemination_April_2023.zip") |> 
  dplyr::mutate(csv = stringr::str_extract_all(filename, "[.]csv$")) |> 
  tidyr::unnest(csv) |>
  dplyr::mutate(fileheader = stringr::str_ends(filename, "fileheader[.]csv$", negate = TRUE)) |> 
  dplyr::filter(fileheader == TRUE) |>
  dplyr::mutate(csv = NULL, fileheader = NULL) |> 
  gluedown::md_table()
```

| parent_zip                              | filename                              | size_compressed | size_uncompressed |
|:----------------------------------------|:--------------------------------------|----------------:|------------------:|
| NPPES_Data_Dissemination_April_2023.zip | othername_pfile_20050523-20230409.csv |           8.97M |            25.88M |
| NPPES_Data_Dissemination_April_2023.zip | endpoint_pfile_20050523-20230409.csv  |          17.53M |            96.76M |
| NPPES_Data_Dissemination_April_2023.zip | pl_pfile_20050523-20230409.csv        |             22M |            65.51M |
| NPPES_Data_Dissemination_April_2023.zip | npidata_pfile_20050523-20230409.csv   |         801.64M |             8.66G |

# Dispense

``` r
nppez::dispense(zip_dir = "D:/nppez_data/zips/",
                unzip_dir =  "D:/nppez_data/unzips/")
```

| date       | file                                                                  |    size |
|:-----------|:----------------------------------------------------------------------|--------:|
| 2023-04-11 | D:/nppez_data/unzips/endpoint_pfile_20050523-20230409.csv             |  96.76M |
| 2023-04-11 | D:/nppez_data/unzips/endpoint_pfile_20050523-20230409_fileheader.csv  |     431 |
| 2023-04-12 | D:/nppez_data/unzips/endpoint_pfile_20230403-20230409.csv             | 330.03K |
| 2023-04-12 | D:/nppez_data/unzips/endpoint_pfile_20230403-20230409_fileheader.csv  |     431 |
| 2023-04-11 | D:/nppez_data/unzips/npidata_pfile_20050523-20230409.csv              |   8.66G |
| 2023-04-11 | D:/nppez_data/unzips/npidata_pfile_20050523-20230409_fileheader.csv   |  11.98K |
| 2023-04-12 | D:/nppez_data/unzips/npidata_pfile_20230403-20230409.csv              |  28.33M |
| 2023-04-12 | D:/nppez_data/unzips/npidata_pfile_20230403-20230409_fileheader.csv   |  11.98K |
| 2023-04-11 | D:/nppez_data/unzips/NPPES Deactivated NPI Report 20230410.xlsx       |   3.68M |
| 2023-04-11 | D:/nppez_data/unzips/NPPES_Data_Dissemination_CodeValues.pdf          | 543.72K |
| 2023-04-11 | D:/nppez_data/unzips/NPPES_Data_Dissemination_Readme.pdf              | 556.21K |
| 2023-04-11 | D:/nppez_data/unzips/othername_pfile_20050523-20230409.csv            |  25.88M |
| 2023-04-11 | D:/nppez_data/unzips/othername_pfile_20050523-20230409_fileheader.csv |      86 |
| 2023-04-12 | D:/nppez_data/unzips/othername_pfile_20230403-20230409.csv            |  86.44K |
| 2023-04-12 | D:/nppez_data/unzips/othername_pfile_20230403-20230409_fileheader.csv |      86 |
| 2023-04-11 | D:/nppez_data/unzips/pl_pfile_20050523-20230409.csv                   |  65.51M |
| 2023-04-11 | D:/nppez_data/unzips/pl_pfile_20050523-20230409_fileheader.csv        |     578 |
| 2023-04-12 | D:/nppez_data/unzips/pl_pfile_20230403-20230409.csv                   | 431.35K |
| 2023-04-12 | D:/nppez_data/unzips/pl_pfile_20230403-20230409_fileheader.csv        |     578 |
| 2023-04-11 | D:/nppez_data/unzips/weekly                                           |       0 |

# Clean

## Weekly Update

Each week, a file will be available for download. This file will contain
only the new FOIA-disclosable NPPES provider data since the last weekly
or monthly file was generated.

## Monthly Deactivations

The FOIA-disclosable data for a health care provider (individual or
organization) who deactivated an NPI will now be disclosed within the
files. For a deactivated NPI, CMS will only disclose the deactivated NPI
and the associated date of deactivation within the files.

``` r
deactivation <- clean_deactivation(dir_xlsx = "D:/nppez_data/unzips")
deactivation <- datawizard::data_peek(deactivation)
deactivation
```

Data frame with 245458 rows and 3 variables

## Variable \| Type \| Values

npi \| character \| 1053472647, 1831848779, 1285361154, …
deactivation_date \| date \| 2023-04-10, 2023-04-09, 2023-04-08, …
release_date \| date \| 2023-04-10, 2023-04-10, 2023-04-10, …

## Monthly Endpoints

− File contains all Endpoints associated with Type 1 and Type 2 NPIs

``` r
endpoints <- readr::read_csv(
  "D:/nppez_data/unzips/endpoint_pfile_20050523-20230409.csv", 
  col_types = "ccc",
  name_repair = janitor::make_clean_names) |> 
  dplyr::arrange(npi)
endpoints <- datawizard::data_peek(endpoints)
endpoints
```

Data frame with 501876 rows and 19 variables

## Variable \| Type \| Values

npi \| character \| 1003000225, …  
endpoint_type \| character \| SOAP, DIRECT, DIRECT, …  
endpoint_type_description \| character \| SOAP URL, …  
endpoint \| character \| <https://careepicwest.k>, … affiliation \|
character \| Y, N, N, N, N, Y, Y, …  
endpoint_description \| character \| Carequality, …  
affiliation_legal_business_name \| character \| The Permanente Medical,
… use_code \| character \| HIE, DIRECT, NA, …  
use_description \| character \| Health Information Exc, …
other_use_description \| character \| NA, NA, NA, NA, NA, …  
content_type \| character \| OTHER, OTHER, NA, …  
content_description \| character \| Other, Other, NA, …  
other_content_description \| character \| C-CDA, CCDA, NA, …  
affiliation_address_line_one \| character \| 275 W MacArthur Blvd, …  
affiliation_address_line_two \| character \| NA, NA, NA, NA, NA, …  
affiliation_address_city \| character \| Oakland, Mentor, …  
affiliation_address_state \| character \| CA, OH, KY, SC, TX, …  
affiliation_address_country \| character \| US, US, US, US, US, …  
affiliation_address_postal_code \| character \| 946115641, 440608714, …

## Monthly Other Names

− File contains additional Other Names associated with Type 2 NPIs

``` r
othernames <- readr::read_csv(
  "D:/nppez_data/unzips/othername_pfile_20050523-20230409.csv", 
  col_types = "ccc",
  name_repair = janitor::make_clean_names) |> 
  dplyr::rename(other_organization_name = provider_other_organization_name,
                other_organization_type = provider_other_organization_name_type_code)
othernames <- datawizard::data_peek(othernames)
othernames
```

Data frame with 603052 rows and 3 variables

## Variable \| Type \| Values

npi \| character \| 1194815423, 1205924446, …  
other_organization_name \| character \| EMPIRE HOME HEALTH SERVICES, …
other_organization_type \| character \| 3, 5, 3, 3, 5, 3, 3, 3, 3, 3, …

## Monthly Practice Locations

− File contains all of the non-primary Practice Locations associated
with Type 1 and Type 2 NPIs.

``` r
locations <- readr::read_csv(
  "D:/nppez_data/unzips/pl_pfile_20050523-20230409.csv", 
  #col_types = "ccc",
  name_repair = janitor::make_clean_names) |> 
  janitor::remove_empty()
locations <- datawizard::data_peek(locations)
locations
```

Data frame with 716002 rows and 10 variables

## Variable \| Type \| Values

npi \| numeric \| , …
provider_secondary_practice_location_address_address_line_1 \| character
\| , … provider_secondary_practice_location_address_address_line_2 \|
character \| , … provider_secondary_practice_location_address_city_name
\| character \| , …
provider_secondary_practice_location_address_state_name \| character \|
, … provider_secondary_practice_location_address_postal_code \|
character \| , …
provider_secondary_practice_location_address_country_code_if_outside_u\_s
\| character \| , …
provider_secondary_practice_location_address_telephone_number \|
character \| , …
provider_secondary_practice_location_address_telephone_extension \|
numeric \| , … provider_practice_location_address_fax_number \| numeric
\| , …

## Monthly Update
