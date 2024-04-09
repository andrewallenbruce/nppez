
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nppez <a href="https://andrewallenbruce.github.io/nppez/"><img src="man/figures/logo.png" align="right" height="200" alt="nppez website" /></a>

> Tidy NPPES NPI Registry Data Files

<!-- badges: start -->
<!-- badges: end -->

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
#> Download Time: 0.35 sec elapsed

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
  files = "NPPES_Deactivated_NPI_Report_040824.zip",
  path  = test
  )
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp
#> ├── NPPES_Data_Dissemination_April_2024.csv
#> └── NPPES_Deactivated_NPI_Report_040824.zip

y
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Data_Dissemination_April_2024.csv
#> C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Deactivated_NPI_Report_040824.zip
```

### Peek

``` r
nppez::peek(path = test)
#> $NPPES_Deactivated_NPI_Report_040824.zip
#> # A tibble: 1 × 4
#>   zipfile                                 filename       compressed uncompressed
#>   <chr>                                   <chr>          <fs::byte>  <fs::bytes>
#> 1 NPPES_Deactivated_NPI_Report_040824.zip NPPES Deactiv…      1.98M        4.11M
```

### Prune

``` r
nppez::prune(dir = test)
#> # A tibble: 1 × 4
#>   parent_zip                          filename compressed_size uncompressed_size
#>   <chr>                               <chr>              <dbl>             <dbl>
#> 1 NPPES_Deactivated_NPI_Report_04082… NPPES D…         2073236           4313447
```

### Dispense

``` r
nppez::dispense(test, "NPPES Deactivated NPI Report 20240408.xlsx")
```

## Load

``` r
readxl::read_xlsx(
  path = fs::path(
    test, 
    "NPPES Deactivated NPI Report 20240408.xlsx"), 
  skip = 1) |> 
  janitor::clean_names() |>
  dplyr::mutate(nppes_deactivation_date = lubridate::mdy(nppes_deactivation_date))
#> Error: `path` does not exist: 'C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES Deactivated NPI Report 20240408.xlsx'
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
