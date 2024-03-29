
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nppez

> Tidy NPPES NPI Registry Data Files

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install **nppez** from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("andrewallenbruce/northstar")
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
