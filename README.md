
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{nppez}`

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the development version of nppez from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("andrewallenbruce/nppez")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(nppez)
```

``` r
nppez::browse()
```

    #> # A tibble: 3 × 4
    #>   date       file                                                   size zip_url
    #>   <date>     <chr>                                               <fs::b> <chr>  
    #> 1 2023-04-10 NPPES Data Dissemination                            851.05M https:…
    #> 2 2023-04-10 NPPES Data Dissemination Monthly Deactivation Upda…   1.78M https:…
    #> 3 2023-04-10 NPPES Data Dissemination Weekly Update                3.62M https:…
