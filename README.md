
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

# Peek

``` r
nppez::peek(dir = "<path-to-downloaded-zip-files>")
```

| parent_zip                                        | size_compressed | size_uncompressed |
|:--------------------------------------------------|----------------:|------------------:|
| NPPES_Data_Dissemination_040323_040923_Weekly.zip |           2.72M |            29.16M |
| NPPES_Data_Dissemination_April_2023.zip           |         850.15M |             8.84G |

<br><br>

| parent_zip                              | filename                              | size_compressed | size_uncompressed |
|:----------------------------------------|:--------------------------------------|----------------:|------------------:|
| NPPES_Data_Dissemination_April_2023.zip | othername_pfile_20050523-20230409.csv |           8.97M |            25.88M |
| NPPES_Data_Dissemination_April_2023.zip | endpoint_pfile_20050523-20230409.csv  |          17.53M |            96.76M |
| NPPES_Data_Dissemination_April_2023.zip | pl_pfile_20050523-20230409.csv        |             22M |            65.51M |
| NPPES_Data_Dissemination_April_2023.zip | npidata_pfile_20050523-20230409.csv   |         801.64M |             8.66G |

# Prune

``` r
nppez::prune(dir = "<path-to-downloaded-zip-files>")
```

    #> [1] "othername_pfile_20050523-20230409.csv"
    #> [2] "endpoint_pfile_20050523-20230409.csv" 
    #> [3] "pl_pfile_20050523-20230409.csv"       
    #> [4] "npidata_pfile_20050523-20230409.csv"

# Dispense

``` r
nppez::dispense(zip_dir   = "<path-to-downloaded-zip-files>",
                unzip_dir =  "<path-to-unzip-files-to>")
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

1.  Main Table

``` r
main <- nppez::clean_weekly() |> 
  dplyr::select(npi, 
                entity_type, 
                enumeration_date, 
                certification_date, 
                last_updated) |> 
  janitor::remove_empty() |> 
  dplyr::mutate(enumeration_age = clock::date_count_between(
    enumeration_date, 
    clock::date_today(""), "day"), 
    .after = enumeration_date)

main |> 
  dplyr::arrange(dplyr::desc(enumeration_age)) |> 
  dplyr::mutate(enumeration_duration = difftime(clock::date_today(""), 
                                                enumeration_date), 
                .after = enumeration_age) |> 
  head()
#> # A tibble: 6 × 7
#>   npi        entity_type  enumeration_date enumeration_age enumeration_duration
#>   <chr>      <chr>        <date>                     <int> <drtn>              
#> 1 1659374676 Individual   2005-05-23                  6542 6542 days           
#> 2 1811990013 Individual   2005-05-23                  6542 6542 days           
#> 3 1518960541 Individual   2005-05-23                  6542 6542 days           
#> 4 1700889656 Organization 2005-05-24                  6541 6541 days           
#> 5 1184627820 Individual   2005-05-26                  6539 6539 days           
#> 6 1619970183 Organization 2005-05-27                  6538 6538 days           
#> # ℹ 2 more variables: certification_date <date>, last_updated <date>
```

2.  Organization Table

``` r
organization <- nppez::clean_weekly() |> 
  dplyr::select(npi, 
                entity_type, 
                organization_legal_name, 
                is_organization_subpart, 
                parent_organization_lbn) |>
  dplyr::filter(entity_type == "Organization") |> 
  dplyr::mutate(entity_type = NULL) |> 
  janitor::remove_empty()

other_org <- nppez::clean_weekly() |> 
  dplyr::select(npi, entity_type, dplyr::contains("other")) |> 
  dplyr::filter(!is.na(organization_other_name)) |> 
  dplyr::mutate(entity_type = NULL) |> 
  janitor::remove_empty()

auth_off <- nppez::clean_weekly() |> 
  dplyr::select(npi, dplyr::starts_with("authoff_")) |> 
  dplyr::filter(!is.na(authoff_last_name))

othernames <- readr::read_csv(
  "D:/nppez_data/unzips/othername_pfile_20050523-20230409.csv", 
  col_types = "ccc",
  name_repair = janitor::make_clean_names) |> 
  dplyr::rename(othernames_org_name = provider_other_organization_name,
                othernames_org_type = provider_other_organization_name_type_code)

organization <- organization |> 
  dplyr::left_join(other_org) |> 
  dplyr::left_join(auth_off) |> 
  dplyr::left_join(othernames) |> 
  dplyr::mutate(is_organization_subpart = dplyr::case_when(
    is_organization_subpart == "Y" ~ TRUE,
    is_organization_subpart == "N" ~ FALSE,
    .default = NA)) |> 
  dplyr::select(npi,
                organization_legal_name,
                organization_other_name,
                othernames_org_name,
                organization_other_type,
                othernames_org_type,
                is_organization_subpart,
                parent_organization_lbn,
                authoff_last_name:authoff_phone)

organization |> head()
#> # A tibble: 6 × 16
#>   npi        organization_legal_name  organization_other_n…¹ othernames_org_name
#>   <chr>      <chr>                    <chr>                  <chr>              
#> 1 1164126330 GOLDEN ERA ADHC LLC      <NA>                   Golden Era ADHC    
#> 2 1558087916 SANCTUARY TREATMENT CEN… <NA>                   <NA>               
#> 3 1124728852 SANCTUARY TREATMENT CEN… <NA>                   <NA>               
#> 4 1447748496 PLASTIC & RECONSTRUCTIV… PLASTIC & RECONSTRUCT… PlasticsOne        
#> 5 1447748496 PLASTIC & RECONSTRUCTIV… PLASTIC & RECONSTRUCT… Plastic & Reconstr…
#> 6 1720637325 RAD X MOBILE IMAGING LLC RAD X MOBILE IMAGING … Rad X Mobile Imagi…
#> # ℹ abbreviated name: ¹​organization_other_name
#> # ℹ 12 more variables: organization_other_type <chr>,
#> #   othernames_org_type <chr>, is_organization_subpart <lgl>,
#> #   parent_organization_lbn <chr>, authoff_last_name <chr>,
#> #   authoff_first_name <chr>, authoff_middle_name <chr>,
#> #   authoff_prefix_name <chr>, authoff_suffix_name <chr>,
#> #   authoff_credential <chr>, authoff_position <chr>, authoff_phone <chr>
```

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
                credential,
                is_sole_proprietor) |>
  dplyr::filter(entity_type == "Individual") |> 
  dplyr::mutate(entity_type = NULL) |> 
  janitor::remove_empty()

other_ind <- nppez::clean_weekly() |> 
  dplyr::select(npi, entity_type, dplyr::contains("other")) |> 
  dplyr::filter(!is.na(other_last_name)) |> 
  dplyr::mutate(entity_type = NULL) |> 
  janitor::remove_empty()

individual <- individual |> 
  dplyr::left_join(other_ind) |> 
  dplyr::mutate(is_sole_proprietor = dplyr::case_when(
    is_sole_proprietor == "Y" ~ TRUE,
    is_sole_proprietor == "N" ~ FALSE,
    .default = NA))

individual |> head()
#> # A tibble: 6 × 16
#>   npi        prefix_name first_name middle_name last_name     suffix_name gender
#>   <chr>      <chr>       <chr>      <chr>       <chr>         <chr>       <chr> 
#> 1 1063162634 DR.         HUSSAIN    RAZA        ABIDI         <NA>        M     
#> 2 1891497467 <NA>        ZINAH      <NA>        QADER         <NA>        F     
#> 3 1720782626 <NA>        KEVIN      <NA>        WU            <NA>        M     
#> 4 1932804044 <NA>        NICOLAS    <NA>        PASCUAL-LEONE <NA>        M     
#> 5 1366145740 <NA>        AMEERA     <NA>        MISTRY        <NA>        F     
#> 6 1407550163 <NA>        ELAINE     ANNA        LIU           <NA>        F     
#> # ℹ 9 more variables: credential <chr>, is_sole_proprietor <lgl>,
#> #   other_last_name <chr>, other_first_name <chr>, other_middle_name <chr>,
#> #   other_prefix_name <chr>, other_suffix_name <chr>, other_credential <chr>,
#> #   other_last_name_type <chr>
```

## Address Table

``` r
add <- nppez::clean_weekly() |> 
  nppez::create_address() |> 
  dplyr::select(-entity_type)
  #dplyr::bind_rows(nppez::clean_locations())

add |> head()
#> # A tibble: 6 × 9
#>   npi        address_type address_street  address_city address_state address_zip
#>   <chr>      <chr>        <chr>           <chr>        <chr>         <chr>      
#> 1 1164126330 practice     4 UNION SQ      UNION CITY   CA            945873523  
#> 2 1558087916 practice     9375 E SHEA BL… SCOTTSDALE   AZ            852606991  
#> 3 1124728852 practice     9017 S PECOS R… HENDERSON    NV            890746621  
#> 4 1447748496 practice     16677 LOWELL B… BROOMFIELD   CO            800238053  
#> 5 1720637325 practice     7409 RALEIGH A… LUBBOCK      TX            794242303  
#> 6 1063162634 practice     720 W OAK ST S… KISSIMMEE    FL            347414998  
#> # ℹ 3 more variables: address_country <chr>, address_phone <chr>,
#> #   address_fax <chr>
```

``` r
library(rpolars)

main_pl <- pl$DataFrame(main)
lazy_main <- main_pl$lazy()
npi_type <- lazy_main$select("npi", "entity_type")


add_pl <- pl$DataFrame(add)
lazy_add <- add_pl$lazy()
add_sub <- lazy_add$select("npi", "address_state")

type_add <- npi_type$join(add_sub, on = "npi", how = "left")

type_add$groupby(
  c("entity_type", "address_state"), 
  maintain_order = TRUE
  )$agg(
    pl$col("npi")$count()
    )$collect()
#> polars DataFrame: shape: (140, 3)
#> ┌──────────────┬───────────────┬─────┐
#> │ entity_type  ┆ address_state ┆ npi │
#> │ ---          ┆ ---           ┆ --- │
#> │ str          ┆ str           ┆ u32 │
#> ╞══════════════╪═══════════════╪═════╡
#> │ Organization ┆ CA            ┆ 760 │
#> │ Organization ┆ AZ            ┆ 234 │
#> │ Organization ┆ NV            ┆ 113 │
#> │ Organization ┆ CO            ┆ 174 │
#> │ ...          ┆ ...           ┆ ... │
#> │ Individual   ┆ DEVON         ┆ 1   │
#> │ Individual   ┆ BAGMATI       ┆ 1   │
#> │ Individual   ┆ ZHEJIANG      ┆ 1   │
#> │ Individual   ┆ BC            ┆ 1   │
#> └──────────────┴───────────────┴─────┘
```

``` r
x <- type_add$groupby(
  c("entity_type", "address_state"), 
  maintain_order = TRUE
  )$agg(
    pl$col("npi")$count()
    )$collect()

x$as_data_frame() |> 
  dplyr::filter(entity_type == "Individual") |> 
  dplyr::arrange(dplyr::desc(npi))
#>    entity_type    address_state  npi
#> 1   Individual               CA 5205
#> 2   Individual               TX 3091
#> 3   Individual               NY 2922
#> 4   Individual               FL 2880
#> 5   Individual               OH 1993
#> 6   Individual               MI 1681
#> 7   Individual               PA 1354
#> 8   Individual               IL 1217
#> 9   Individual               NC 1190
#> 10  Individual               MD 1046
#> 11  Individual               MA 1038
#> 12  Individual               TN 1017
#> 13  Individual               VA  950
#> 14  Individual               NJ  910
#> 15  Individual               GA  909
#> 16  Individual               IN  835
#> 17  Individual               WA  798
#> 18  Individual               WI  773
#> 19  Individual               CO  684
#> 20  Individual               OR  657
#> 21  Individual               MN  643
#> 22  Individual               AZ  633
#> 23  Individual               SC  612
#> 24  Individual               DC  603
#> 25  Individual               KY  560
#> 26  Individual               LA  491
#> 27  Individual               CT  459
#> 28  Individual               OK  450
#> 29  Individual               MO  448
#> 30  Individual               NV  433
#> 31  Individual               AL  412
#> 32  Individual               AR  410
#> 33  Individual               UT  345
#> 34  Individual               WV  322
#> 35  Individual               KS  320
#> 36  Individual               NM  297
#> 37  Individual               MS  174
#> 38  Individual               IA  159
#> 39  Individual               PR  151
#> 40  Individual               NE  144
#> 41  Individual               RI  129
#> 42  Individual               ME  128
#> 43  Individual               ID  127
#> 44  Individual               NH  126
#> 45  Individual               DE  119
#> 46  Individual               HI  108
#> 47  Individual               VT   80
#> 48  Individual               AK   79
#> 49  Individual               MT   72
#> 50  Individual               ND   62
#> 51  Individual               WY   59
#> 52  Individual               SD   59
#> 53  Individual               AE   31
#> 54  Individual               AP    8
#> 55  Individual               AA    5
#> 56  Individual               VI    4
#> 57  Individual               GU    2
#> 58  Individual               CE    2
#> 59  Individual          ALREHAB    2
#> 60  Individual            SINDH    2
#> 61  Individual               ON    2
#> 62  Individual            MALMO    2
#> 63  Individual          ONTARIO    2
#> 64  Individual BRITISH COLUMBIA    2
#> 65  Individual      PUERTO RICO    1
#> 66  Individual             UTAH    1
#> 67  Individual  RHEINLAND PFALZ    1
#> 68  Individual       TAMIL NADU    1
#> 69  Individual  VALLE DEL CAUCA    1
#> 70  Individual          VICENZA    1
#> 71  Individual       CO. GALWAY    1
#> 72  Individual           GALWAY    1
#> 73  Individual         MENOUFIA    1
#> 74  Individual           ISRAEL    1
#> 75  Individual           PUNJAB    1
#> 76  Individual          ALBERTA    1
#> 77  Individual            CADIZ    1
#> 78  Individual           RUSSIA    1
#> 79  Individual               AB    1
#> 80  Individual         MICHIGAN    1
#> 81  Individual          IRELAND    1
#> 82  Individual            EGYPT    1
#> 83  Individual            DEVON    1
#> 84  Individual          BAGMATI    1
#> 85  Individual         ZHEJIANG    1
#> 86  Individual               BC    1

x$as_data_frame() |> 
  dplyr::filter(entity_type == "Organization") |> 
  dplyr::arrange(dplyr::desc(npi))
#>     entity_type address_state npi
#> 1  Organization            TX 785
#> 2  Organization            FL 761
#> 3  Organization            CA 760
#> 4  Organization            NY 487
#> 5  Organization            PA 276
#> 6  Organization            OH 272
#> 7  Organization            TN 259
#> 8  Organization            IL 259
#> 9  Organization            GA 247
#> 10 Organization            NC 241
#> 11 Organization            AZ 234
#> 12 Organization            MI 234
#> 13 Organization            MD 225
#> 14 Organization            VA 224
#> 15 Organization            NJ 204
#> 16 Organization            MN 185
#> 17 Organization            KY 176
#> 18 Organization            CO 174
#> 19 Organization            MA 124
#> 20 Organization            OR 116
#> 21 Organization            NV 113
#> 22 Organization            WI 107
#> 23 Organization            MO 107
#> 24 Organization            WA 106
#> 25 Organization            AL 101
#> 26 Organization            KS  99
#> 27 Organization            IN  94
#> 28 Organization            MS  88
#> 29 Organization            CT  71
#> 30 Organization            SC  70
#> 31 Organization            LA  69
#> 32 Organization            ID  66
#> 33 Organization            OK  60
#> 34 Organization            AR  59
#> 35 Organization            UT  58
#> 36 Organization            RI  51
#> 37 Organization            IA  50
#> 38 Organization            NE  44
#> 39 Organization            PR  41
#> 40 Organization            NM  35
#> 41 Organization            HI  34
#> 42 Organization            MT  32
#> 43 Organization            ME  27
#> 44 Organization            DE  27
#> 45 Organization            VT  26
#> 46 Organization            WY  20
#> 47 Organization            WV  19
#> 48 Organization            NH  16
#> 49 Organization            SD  15
#> 50 Organization            ND  12
#> 51 Organization            AK  10
#> 52 Organization            VI   4
#> 53 Organization            DC   3
#> 54 Organization       JALISCO   1
```

## Taxonomy Table

``` r
tx <- nppez::clean_weekly() |> 
  nppez::create_taxonomy()
```

## Identifiers Table

``` r
id <- nppez::clean_weekly() |> 
  nppez::create_identifiers()
```

## Monthly Deactivations

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

## Monthly Update
