
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nppez

> Tidy NPPES NPI Registry Data Files

<!-- badges: start -->
<!-- badges: end -->

## :package: Installation

You can install **nppez** from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("andrewallenbruce/northstar")
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
#> Download Time: 0.33 sec elapsed

x
#> # A tibble: 5 × 4
#>   file                                              url       date          size
#>   <chr>                                             <chr>     <date>     <fs::b>
#> 1 NPPES_Data_Dissemination_March_2024.zip           https://… 2024-03-11 935.96M
#> 2 NPPES_Deactivated_NPI_Report_031124.zip           https://… 2024-03-11   1.96M
#> 3 NPPES_Data_Dissemination_030424_031024_Weekly.zip https://… 2024-03-04   3.83M
#> 4 NPPES_Data_Dissemination_031124_031724_Weekly.zip https://… 2024-03-11    3.8M
#> 5 NPPES_Data_Dissemination_031824_032424_Weekly.zip https://… 2024-03-18   4.31M
```

### Grab

Download NPPES ZIP files to a local directory

``` r
y <- nppez::grab(
  obj   = x, 
  files = "NPPES_Data_Dissemination_030424_031024_Weekly.zip",
  path  = test
  )
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp
#> ├── NPPES_Data_Dissemination_030424_031024_Weekly.zip
#> ├── NPPES_Data_Dissemination_March_2024.csv
#> └── NPPES_Download_Log_2024-03-30.csv

y
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Data_Dissemination_030424_031024_Weekly.zip
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Data_Dissemination_March_2024.csv
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Download_Log_2024-03-30.csv
```

### Peek

``` r
nppez::peek(path = test)
#> $NPPES_Data_Dissemination_030424_031024_Weekly.zip
#> # A tibble: 10 × 4
#>    zipfile                                      filename compressed uncompressed
#>    <chr>                                        <chr>    <fs::byte>  <fs::bytes>
#>  1 NPPES_Data_Dissemination_030424_031024_Week… pl_pfil…    202.92K       616.5K
#>  2 NPPES_Data_Dissemination_030424_031024_Week… pl_pfil…        160          578
#>  3 NPPES_Data_Dissemination_030424_031024_Week… otherna…     41.15K       119.9K
#>  4 NPPES_Data_Dissemination_030424_031024_Week… otherna…         53           86
#>  5 NPPES_Data_Dissemination_030424_031024_Week… npidata…      2.61M        28.5M
#>  6 NPPES_Data_Dissemination_030424_031024_Week… npidata…      1.35K          12K
#>  7 NPPES_Data_Dissemination_030424_031024_Week… endpoin…     75.46K         401K
#>  8 NPPES_Data_Dissemination_030424_031024_Week… endpoin…        154          431
#>  9 NPPES_Data_Dissemination_030424_031024_Week… NPPES_D…    459.91K       556.2K
#> 10 NPPES_Data_Dissemination_030424_031024_Week… NPPES_D…    460.77K       543.7K
```

<br><br>

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

### Prune

``` r
nppez::prune(dir = "<path-to-downloaded-zip-files>")
```

### Dispense

``` r
nppez::dispense(from = "<path-to-downloaded-zip-files>",
                to = "<path-to-unzip-files-to>")
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
