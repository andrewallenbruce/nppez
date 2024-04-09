
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
#> Download Time: 0.34 sec elapsed

x
#> # A tibble: 5 × 4
#>   file                                                url     date          size
#>   <chr>                                               <chr>   <date>     <fs::b>
#> 1 "NPPES_Data_Dissemination_April_2024.zip"           https:… 2024-04-08 941.55M
#> 2 "NPPES_Deactivated_NPI_Report_040824.zip"           https:… 2024-04-08   1.98M
#> 3 "NPPES_Data_Dissemination_040124_040724_Weekly.zip" https:… 2024-04-01   4.03M
#> 4 ""                                                  https:… NA              NA
#> 5  <NA>                                               https:… NA              NA
```

### Grab

Download NPPES ZIP files to a local directory

``` r
y <- nppez::grab(
  obj   = x, 
  files = "NPPES_Data_Dissemination_030424_031024_Weekly.zip",
  path  = test
  )
#> Error in nppez::grab(obj = x, files = "NPPES_Data_Dissemination_030424_031024_Weekly.zip", : No `files` in results

y
#> Error in eval(expr, envir, enclos): object 'y' not found
```

### Peek

``` r
nppez::peek(path = test)
#> Error in `dplyr::mutate()`:
#> ℹ In argument: `compressed = fs::fs_bytes(compressed_size)`.
#> Caused by error:
#> ! object 'compressed_size' not found
```

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
