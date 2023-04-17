
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

# Ask

``` r
nppez::ask()
```

| release_date | file_age | filesize | filename                                          |
|:-------------|---------:|---------:|:--------------------------------------------------|
| 2023-04-10   |        6 |  851.05M | NPPES_Data_Dissemination_April_2023.zip           |
| 2023-04-10   |        6 |    1.78M | NPPES_Deactivated_NPI_Report_041023.zip           |
| 2023-04-03   |       13 |    3.62M | NPPES_Data_Dissemination_040323_040923_Weekly.zip |

# Grab

``` r
nppez::grab(dir = "C:/<folder-to-save-zip-files-to>")
```

| download_date |    size | filename                                                             |
|:--------------|--------:|:---------------------------------------------------------------------|
| 2023-04-12    |   3.62M | D:/nppez_data/zips/NPPES_Data_Dissemination_040323_040923_Weekly.zip |
| 2023-04-12    | 851.05M | D:/nppez_data/zips/NPPES_Data_Dissemination_April_2023.zip           |
| 2023-04-12    |   1.78M | D:/nppez_data/zips/NPPES_Deactivated_NPI_Report_041023.zip           |

``` r
fs::path_ext("D:/nppez_data/zips/NPPES_Data_Dissemination_040323_040923_Weekly.zip")
#> [1] "zip"
fs::dir_create("D:/nppez_data/zips/testing")
fs::dir_ls("D:/nppez_data/zips/testing")
#> character(0)
fs::dir_exists("D:/nppez_data/zips/testing")
#> D:/nppez_data/zips/testing 
#>                       TRUE
```

# Peek

``` r
nppez::peek(dir = "<path-to-downloaded-zip-files>")
#> Error: [ENOENT] Failed to search directory '<path-to-downloaded-zip-files>': no such file or directory
```

| parent_zip                                        | size_compressed | size_uncompressed |
|:--------------------------------------------------|----------------:|------------------:|
| NPPES_Data_Dissemination_040323_040923_Weekly.zip |           2.72M |            29.16M |
| NPPES_Data_Dissemination_April_2023.zip           |         850.15M |             8.84G |

| parent_zip                              | filename                              | size_compressed | size_uncompressed |
|:----------------------------------------|:--------------------------------------|----------------:|------------------:|
| NPPES_Data_Dissemination_April_2023.zip | othername_pfile_20050523-20230409.csv |           8.97M |            25.88M |
| NPPES_Data_Dissemination_April_2023.zip | endpoint_pfile_20050523-20230409.csv  |          17.53M |            96.76M |
| NPPES_Data_Dissemination_April_2023.zip | pl_pfile_20050523-20230409.csv        |             22M |            65.51M |
| NPPES_Data_Dissemination_April_2023.zip | npidata_pfile_20050523-20230409.csv   |         801.64M |             8.66G |

# Prune

``` r
nppez::prune(dir = "D:/nppez_data/zips/")
#> [1] "othername_pfile_20050523-20230409.csv"
#> [2] "endpoint_pfile_20050523-20230409.csv" 
#> [3] "pl_pfile_20050523-20230409.csv"       
#> [4] "npidata_pfile_20050523-20230409.csv"
```

# Dispense

``` r
nppez::dispense(zip_dir = "D:/nppez_data/zips/",
                unzip_dir =  "D:/nppez_data/unzips/")
```

| date       |    size | filename                              |
|:-----------|--------:|:--------------------------------------|
| 2023-04-11 |  96.76M | endpoint_pfile_20050523-20230409.csv  |
| 2023-04-12 | 330.03K | endpoint_pfile_20230403-20230409.csv  |
| 2023-04-11 |   8.66G | npidata_pfile_20050523-20230409.csv   |
| 2023-04-12 |  28.33M | npidata_pfile_20230403-20230409.csv   |
| 2023-04-11 |  25.88M | othername_pfile_20050523-20230409.csv |
| 2023-04-12 |  86.44K | othername_pfile_20230403-20230409.csv |
| 2023-04-11 |  65.51M | pl_pfile_20050523-20230409.csv        |
| 2023-04-12 | 431.35K | pl_pfile_20230403-20230409.csv        |

# Clean

## Weekly Update

Each week, a file will be available for download. This file will contain
only the new FOIA-disclosable NPPES provider data since the last weekly
or monthly file was generated.

- \[\] main
  - \[\] npi
  - \[\] entity_type
  - \[\] enumeration_date
  - \[\] certification_date
  - \[\] last_updated
  - \[\] npi_deactivation_date
  - \[\] npi_reactivation_date
  - \[\] is_sole_proprietor
  - \[\] is_organization_subpart
  - \[\] parent_organization_lbn
  - \[\] parent_organization_tin
  - \[\] organization_legal_name

## Individual Table

``` r
individual <- nppez::clean_weekly() |> 
  dplyr::select(npi, 
                entity_type, 
                prefix_name, 
                first_name, 
                middle_name, 
                last_name, 
                suffix_name, 
                gender, 
                credential) |>
  dplyr::filter(entity_type == "Individual") |> 
  dplyr::mutate(entity_type = NULL) |> 
  janitor::remove_empty()
individual
#> # A tibble: 20,225 × 8
#>    npi        prefix_name first_name middle_name last_name    suffix_name gender
#>    <chr>      <chr>       <chr>      <chr>       <chr>        <chr>       <chr> 
#>  1 1063162634 DR.         HUSSAIN    RAZA        ABIDI        <NA>        M     
#>  2 1891497467 <NA>        ZINAH      <NA>        QADER        <NA>        F     
#>  3 1720782626 <NA>        KEVIN      <NA>        WU           <NA>        M     
#>  4 1932804044 <NA>        NICOLAS    <NA>        PASCUAL-LEO… <NA>        M     
#>  5 1366145740 <NA>        AMEERA     <NA>        MISTRY       <NA>        F     
#>  6 1407550163 <NA>        ELAINE     ANNA        LIU          <NA>        F     
#>  7 1487262978 <NA>        MIAH       MELANIE     RAMSEY       <NA>        F     
#>  8 1255831962 <NA>        SELENA     PATRICIA    WELLS        <NA>        F     
#>  9 1407025497 <NA>        MATTHEW    BENJAMIN    MAIN         <NA>        M     
#> 10 1306549282 <NA>        SIMON      <NA>        LUU          <NA>        M     
#> # ℹ 20,215 more rows
#> # ℹ 1 more variable: credential <chr>
```

## Other Table

``` r
other_ind <- nppez::clean_weekly() |> 
  dplyr::select(npi, entity_type, dplyr::contains("other")) |> 
  dplyr::filter(!is.na(other_last_name)) |> 
  dplyr::mutate(entity_type = NULL) |> 
  janitor::remove_empty()

other_org <- nppez::clean_weekly() |> 
  dplyr::select(npi, entity_type, dplyr::contains("other")) |> 
  dplyr::filter(!is.na(organization_other_name)) |> 
  dplyr::mutate(entity_type = NULL) |> 
  janitor::remove_empty()
```

## Authorized Official Table

``` r
auth_off <- nppez::clean_weekly() |> 
  dplyr::select(npi, dplyr::starts_with("authoff_")) |> 
  dplyr::filter(!is.na(authoff_last_name))
auth_off
#> # A tibble: 3,989 × 9
#>    npi        authoff_last_name authoff_first_name authoff_middle_name
#>    <chr>      <chr>             <chr>              <chr>              
#>  1 1164126330 GIANG             HANH               <NA>               
#>  2 1558087916 ZHONG             JUN                <NA>               
#>  3 1124728852 WANG              QINGCHUAN          <NA>               
#>  4 1447748496 ZUHLKE            TODD               A.                 
#>  5 1720637325 DUSENBERRY        ANISSA             <NA>               
#>  6 1538863667 MANUEL            JAMAICA            LAGUNA             
#>  7 1023751724 ROMERO MICULESCU  ANA                MARIA              
#>  8 1477256873 TANYAG            CELINA JANNA MAY   <NA>               
#>  9 1720515331 WINSTEL           JOHN               <NA>               
#> 10 1750854345 WINSTEL           JOHN               D                  
#> # ℹ 3,979 more rows
#> # ℹ 5 more variables: authoff_prefix_name <chr>, authoff_suffix_name <chr>,
#> #   authoff_credential <chr>, authoff_position <chr>, authoff_phone <chr>
```

## Taxonomy Table

``` r
tx <- nppez::clean_weekly() |> 
  nppez::create_taxonomy() |> 
  datawizard::data_peek()
tx
#> Data frame with 33094 rows and 6 variables
#> 
#> Variable         | Type      | Values                                 
#> ----------------------------------------------------------------------
#> npi              | character | 1164126330, 1558087916, 1124728852, ...
#> taxonomy_code    | character | 261QA0600X, 2084P0800X, 2084P0800X, ...
#> primary_taxonomy | logical   | TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, ...
#> taxonomy_group   | character | NA, ...                                
#> license_no       | character | NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
#> license_state    | character | NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
```

## Identifiers Table

``` r
id <- nppez::clean_weekly() |> 
  nppez::create_identifiers() |> datawizard::data_peek()
id
#> Data frame with 4369 rows and 5 variables
#> 
#> Variable   | Type      | Values                                        
#> -----------------------------------------------------------------------
#> npi        | character | 1316090236, 1215901574, 1215901574, ...       
#> identifier | character | 412900800, 0921953, 0748972, 000000087511, ...
#> id_type    | character | 05, 05, 05, 01, 05, 05, 05, 01, 05, 01, ...   
#> id_state   | character | MD, OH, OH, IN, IN, IN, IN, IN, NY, NC, ...   
#> id_issuer  | character | NA, NA, NA, ANTHEM BC/BS, NA, NA, NA, ...
```

## Address Table

``` r
add <- nppez::clean_weekly() |> 
  nppez::create_address() |> 
  dplyr::bind_rows(nppez::clean_locations())
```

## Monthly Deactivations

The FOIA-disclosable data for a health care provider (individual or
organization) who deactivated an NPI will now be disclosed within the
files. For a deactivated NPI, CMS will only disclose the deactivated NPI
and the associated date of deactivation within the files.

``` r
deactivation <- clean_deactivation(dir_xlsx = "D:/nppez_data/unzips")
deactivation
#> # A tibble: 245,458 × 3
#>    npi        deactivation_date release_date
#>    <chr>      <date>            <date>      
#>  1 1053472647 2023-04-10        2023-04-10  
#>  2 1831848779 2023-04-09        2023-04-10  
#>  3 1285361154 2023-04-08        2023-04-10  
#>  4 1245817519 2023-04-08        2023-04-10  
#>  5 1487256715 2023-04-07        2023-04-10  
#>  6 1477938066 2023-04-07        2023-04-10  
#>  7 1295436434 2023-04-07        2023-04-10  
#>  8 1225739220 2023-04-07        2023-04-10  
#>  9 1093818437 2023-04-07        2023-04-10  
#> 10 1447980735 2023-04-07        2023-04-10  
#> # ℹ 245,448 more rows
```

## Monthly Endpoints

− File contains all Endpoints associated with Type 1 and Type 2 NPIs

``` r
endpoints <- nppez::clean_endpoints()
endpoints
#> # A tibble: 501,876 × 15
#>    npi        endpoint_type_descript…¹ endpoint affiliation endpoint_description
#>    <chr>      <chr>                    <chr>    <lgl>       <chr>               
#>  1 1962775213 Other URL                kliddle… FALSE       <NA>                
#>  2 1699232223 Other URL                indeal.… FALSE       email               
#>  3 1225596182 CONNECT URL              nellgil… FALSE       <NA>                
#>  4 1144788027 Other URL                N/A      FALSE       <NA>                
#>  5 1619435591 CONNECT URL              Helensh… FALSE       Business Email      
#>  6 1326506213 Direct Messaging Address jess@sc… TRUE        School of Play's se…
#>  7 1861950750 SOAP URL                 Bend     FALSE       <NA>                
#>  8 1023576915 Direct Messaging Address contact… FALSE       <NA>                
#>  9 1154889046 Direct Messaging Address Jilienn… TRUE        Work Email Address  
#> 10 1063970960 Direct Messaging Address ticonna… FALSE       <NA>                
#> # ℹ 501,866 more rows
#> # ℹ abbreviated name: ¹​endpoint_type_description
#> # ℹ 10 more variables: affiliation_legal_business_name <chr>,
#> #   use_description <chr>, other_use_description <chr>, content_type <chr>,
#> #   other_content_description <chr>, affiliation_address_street <chr>,
#> #   affiliation_address_city <chr>, affiliation_address_state <chr>,
#> #   affiliation_address_country <chr>, affiliation_address_postal_code <chr>
```

## Monthly Other Names

− File contains additional Other Names associated with Type 2 NPIs

``` r
othernames <- readr::read_csv(
  "D:/nppez_data/unzips/othername_pfile_20050523-20230409.csv", 
  col_types = "ccc",
  name_repair = janitor::make_clean_names) |> 
  dplyr::rename(other_organization_name = provider_other_organization_name,
                other_organization_type = provider_other_organization_name_type_code)
```

## Monthly Update
