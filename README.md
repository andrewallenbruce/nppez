
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nppez <a href="https://andrewallenbruce.github.io/nppez/"><img src="man/figures/logo.png" align="right" height="200" alt="nppez website" /></a>

> Regularly **Dispense** NPPES Registry Data

<!-- badges: start -->
<!-- badges: end -->

<br>

## :package: Installation

You can install **nppez** from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("andrewallenbruce/nppez")
```

## :beginner: Usage

``` r
library(nppez)
library(fs)

test <- path(path_wd(), "inst/tmp")
dir_create(test)
```

### Ask

List the most recent NPPES Data Dissemination releases

``` r
x <- nppez::ask(
  save = TRUE,
  path = test
)
#> Download Time: 0.45 sec elapsed

x
#> # A tibble: 3 × 4
#>   file                                              url       date          size
#>   <chr>                                             <chr>     <date>     <fs::b>
#> 1 NPPES_Data_Dissemination_April_2024.zip           https://… 2024-04-08 941.55M
#> 2 NPPES_Deactivated_NPI_Report_040824.zip           https://… 2024-04-08   1.98M
#> 3 NPPES_Data_Dissemination_040124_040724_Weekly.zip https://… 2024-04-01   4.03M
```

### Grab

Download NPPES ZIP files to a local directory

``` r
y <- nppez::grab(
  obj   = x, 
  path  = test
  )
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp
#> ├── NPPES_Data_Dissemination_040124_040724_Weekly.zip
#> ├── NPPES_Data_Dissemination_April_2024.csv
#> ├── NPPES_Data_Dissemination_April_2024.zip
#> └── NPPES_Deactivated_NPI_Report_040824.zip

y
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Data_Dissemination_040124_040724_Weekly.zip
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Data_Dissemination_April_2024.csv
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Data_Dissemination_April_2024.zip
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Deactivated_NPI_Report_040824.zip
```

### Peek

``` r
nppez::peek(path = test)
#> $NPPES_Data_Dissemination_040124_040724_Weekly.zip
#> # A tibble: 10 × 4
#>    zipfile                                      filename compressed uncompressed
#>    <chr>                                        <chr>    <fs::byte>  <fs::bytes>
#>  1 NPPES_Data_Dissemination_040124_040724_Week… npidata…      2.92M        32.5M
#>  2 NPPES_Data_Dissemination_040124_040724_Week… npidata…      1.35K          12K
#>  3 NPPES_Data_Dissemination_040124_040724_Week… endpoin…     68.52K       365.5K
#>  4 NPPES_Data_Dissemination_040124_040724_Week… endpoin…        154          431
#>  5 NPPES_Data_Dissemination_040124_040724_Week… otherna…      35.4K       100.2K
#>  6 NPPES_Data_Dissemination_040124_040724_Week… otherna…         53           86
#>  7 NPPES_Data_Dissemination_040124_040724_Week… pl_pfil…    201.73K       603.2K
#>  8 NPPES_Data_Dissemination_040124_040724_Week… pl_pfil…        160          578
#>  9 NPPES_Data_Dissemination_040124_040724_Week… NPPES_D…    459.91K       556.2K
#> 10 NPPES_Data_Dissemination_040124_040724_Week… NPPES_D…     368.5K       397.2K
#> 
#> $NPPES_Data_Dissemination_April_2024.zip
#> # A tibble: 10 × 4
#>    zipfile                                 filename      compressed uncompressed
#>    <chr>                                   <chr>         <fs::byte>  <fs::bytes>
#>  1 NPPES_Data_Dissemination_April_2024.zip endpoint_pfi…     21.27M      105.97M
#>  2 NPPES_Data_Dissemination_April_2024.zip endpoint_pfi…        154          431
#>  3 NPPES_Data_Dissemination_April_2024.zip npidata_pfil…    884.34M        9.24G
#>  4 NPPES_Data_Dissemination_April_2024.zip npidata_pfil…      1.35K       11.98K
#>  5 NPPES_Data_Dissemination_April_2024.zip pl_pfile_200…      26.1M       77.26M
#>  6 NPPES_Data_Dissemination_April_2024.zip pl_pfile_200…        160          578
#>  7 NPPES_Data_Dissemination_April_2024.zip othername_pf…      9.03M       27.47M
#>  8 NPPES_Data_Dissemination_April_2024.zip othername_pf…         53           86
#>  9 NPPES_Data_Dissemination_April_2024.zip NPPES_Data_D…    459.91K      556.21K
#> 10 NPPES_Data_Dissemination_April_2024.zip NPPES_Data_D…     368.5K      397.21K
#> 
#> $NPPES_Deactivated_NPI_Report_040824.zip
#> # A tibble: 1 × 4
#>   zipfile                                 filename       compressed uncompressed
#>   <chr>                                   <chr>          <fs::byte>  <fs::bytes>
#> 1 NPPES_Deactivated_NPI_Report_040824.zip NPPES Deactiv…      1.98M        4.11M
```

### Prune

``` r
# nppez::prune(dir = test_zip)
```

### Dispense

``` r
nppez::dispense(test)

fs::dir_tree(test)
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp
#> ├── endpoint_pfile_20050523-20240407.csv
#> ├── endpoint_pfile_20050523-20240407_fileheader.csv
#> ├── endpoint_pfile_20240401-20240407.csv
#> ├── endpoint_pfile_20240401-20240407_fileheader.csv
#> ├── npidata_pfile_20050523-20240407.csv
#> ├── npidata_pfile_20050523-20240407_fileheader.csv
#> ├── npidata_pfile_20240401-20240407.csv
#> ├── npidata_pfile_20240401-20240407_fileheader.csv
#> ├── NPPES Deactivated NPI Report 20240408.xlsx
#> ├── NPPES_Data_Dissemination_040124_040724_Weekly.zip
#> ├── NPPES_Data_Dissemination_April_2024.csv
#> ├── NPPES_Data_Dissemination_April_2024.zip
#> ├── NPPES_Data_Dissemination_CodeValues.pdf
#> ├── NPPES_Data_Dissemination_Readme.pdf
#> ├── NPPES_Deactivated_NPI_Report_040824.zip
#> ├── othername_pfile_20050523-20240407.csv
#> ├── othername_pfile_20050523-20240407_fileheader.csv
#> ├── othername_pfile_20240401-20240407.csv
#> ├── othername_pfile_20240401-20240407_fileheader.csv
#> ├── pl_pfile_20050523-20240407.csv
#> ├── pl_pfile_20050523-20240407_fileheader.csv
#> ├── pl_pfile_20240401-20240407.csv
#> └── pl_pfile_20240401-20240407_fileheader.csv
```

## Load

> <ins>
> <b>Deactivated NPI Report</b>
> </ins>
>
> : <i>04-08-2024</i>

``` r
readxl::read_xlsx(
  path = fs::path(
    test, 
    "NPPES Deactivated NPI Report 20240408.xlsx"), 
  skip = 1) |> 
  janitor::clean_names() |>
  dplyr::mutate(nppes_deactivation_date = lubridate::mdy(nppes_deactivation_date))
#> # A tibble: 274,370 × 2
#>    npi        nppes_deactivation_date
#>    <chr>      <date>                 
#>  1 1982265062 2024-04-07             
#>  2 1457064735 2024-04-06             
#>  3 1134278393 2024-04-06             
#>  4 1104676717 2024-04-05             
#>  5 1275385866 2024-04-05             
#>  6 1396440467 2024-04-05             
#>  7 1376395137 2024-04-05             
#>  8 1184356867 2024-04-05             
#>  9 1750581948 2024-04-05             
#> 10 1629001540 2024-04-05             
#> # ℹ 274,360 more rows
```

> <ins>
> <b>Practice Location Reference File</b>
> </ins>
>
> : <i>05-23-2005 to 04-07-2024</i> All non-primary Practice Locations
> associated with Type 1 & 2 NPIs

``` r
readr::read_csv(
  fs::path(
    test, 
    "pl_pfile_20050523-20240407.csv"
    )
  ) |> 
  janitor::clean_names()
#> # A tibble: 845,499 × 10
#>         npi provider_secondary_p…¹ provider_secondary_p…² provider_secondary_p…³
#>       <dbl> <chr>                  <chr>                  <chr>                 
#>  1   1.15e9 7800 Sheridan St       <NA>                   Pembroke Pines        
#>  2   1.15e9 500 N Hiatus Rd Ste 2… <NA>                   Pembroke Pines        
#>  3   1.70e9 2200 Cedarcrest Dr     Ste A                  Rice Lake             
#>  4   1.70e9 757 Lakeland Dr Ste B  <NA>                   Chippewa Falls        
#>  5   1.12e9 31 S Stanfield Rd Ste… <NA>                   Troy                  
#>  6   1.12e9 3333 W Tech Blvd       <NA>                   Miamisburg            
#>  7   1.06e9 560 Riverside Dr Ste … <NA>                   Salisbury             
#>  8   1.14e9 226 S Woods Mill Rd    Suite 49W              Chesterfield          
#>  9   1.87e9 329 23rd Ave No, Suit… <NA>                   Nashville             
#> 10   1.70e9 1960 S 16th St         <NA>                   Wilmington            
#> # ℹ 845,489 more rows
#> # ℹ abbreviated names:
#> #   ¹​provider_secondary_practice_location_address_address_line_1,
#> #   ²​provider_secondary_practice_location_address_address_line_2,
#> #   ³​provider_secondary_practice_location_address_city_name
#> # ℹ 6 more variables:
#> #   provider_secondary_practice_location_address_state_name <chr>, …
```

> <ins>
> <b>Other Name Reference File</b>
> </ins>
>
> : : <i>05-23-2005 to 04-07-2024</i> Additional Other Names associated
> with Type 2 NPIs

``` r
readr::read_csv(
  fs::path(
    test, 
    "othername_pfile_20050523-20240407.csv"
    )
  ) |> 
  janitor::clean_names()
#> # A tibble: 639,667 × 3
#>           npi provider_other_organization_name         provider_other_organiza…¹
#>         <dbl> <chr>                                                        <dbl>
#>  1 1023011053 Vine Discount Pharmacy & Medical Supply                          3
#>  2 1023011178 PROVIDENCE PALLIATIVE CARE NAPA VALLEY                           3
#>  3 1023011178 Providence Hospice Napa Valley                                   3
#>  4 1023011178 Napa Valley Hospice & Adult Day Services                         4
#>  5 1043213093 HOME IV SPECIALISTS INC                                          3
#>  6 1053314252 Alliance HomeCare                                                3
#>  7 1134122328 Horizon Coral Springs LLC                                        3
#>  8 1144223199 Major County EMS                                                 5
#>  9 1174526107 Open Imaging Layton                                              3
#> 10 1174526107 RAYUS RADIOLOGY                                                  3
#> # ℹ 639,657 more rows
#> # ℹ abbreviated name: ¹​provider_other_organization_name_type_code
```

> <ins>
> <b>Endpoint Reference File</b>
> </ins>
>
> : : <i>05-23-2005 to 04-07-2024</i> Endpoints associated with Type 1 &
> 2 NPIs

``` r
readr::read_csv(
  fs::path(
    test, 
    "endpoint_pfile_20050523-20240407.csv"
    )
  ) |> 
  janitor::clean_names()
#> # A tibble: 545,028 × 19
#>           npi endpoint_type endpoint_type_description endpoint       affiliation
#>         <dbl> <chr>         <chr>                     <chr>          <chr>      
#>  1 1154324382 DIRECT        Direct Messaging Address  rclose13800@M… N          
#>  2 1154324382 DIRECT        Direct Messaging Address  Richard.Close… N          
#>  3 1962405175 DIRECT        Direct Messaging Address  fredericstelz… N          
#>  4 1699778894 DIRECT        Direct Messaging Address  aawomolo@dire… N          
#>  5 1134122336 DIRECT        Direct Messaging Address  Narasimha.Red… Y          
#>  6 1396748596 DIRECT        Direct Messaging Address  CHRISTIANO.CA… N          
#>  7 1205839404 FHIR          FHIR URL                  https://epicp… Y          
#>  8 1841293040 CONNECT       CONNECT URL               Jennifer.Gile… N          
#>  9 1306849591 DIRECT        Direct Messaging Address  svogel89246@d… N          
#> 10 1003819038 DIRECT        Direct Messaging Address  lgoldberg1086… N          
#> # ℹ 545,018 more rows
#> # ℹ 14 more variables: endpoint_description <chr>,
#> #   affiliation_legal_business_name <chr>, use_code <chr>,
#> #   use_description <chr>, other_use_description <chr>, content_type <chr>,
#> #   content_description <chr>, other_content_description <chr>,
#> #   affiliation_address_line_one <chr>, affiliation_address_line_two <chr>,
#> #   affiliation_address_city <chr>, affiliation_address_state <chr>, …
```

> <ins>
> <b>Complete NPI Data Dissemination File</b>
> </ins>
>
> : : <i>April 2024</i> Data for all active Type 1 & 2 NPIs

``` r
readr::read_csv(
  fs::path(
    test, 
    "npidata_pfile_20050523-20240407.csv"
    )
  ) |> 
  janitor::clean_names()
```

------------------------------------------------------------------------

## :balance_scale: Code of Conduct

Please note that the `nppez` project is released with a [Contributor
Code of
Conduct](https://andrewallenbruce.github.io/northstar/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## :classical_building: Governance

This project is primarily maintained by [Andrew
Bruce](https://github.com/andrewallenbruce). Other authors may
occasionally assist with some of these duties.
