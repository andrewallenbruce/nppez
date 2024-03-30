
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
```

### Ask

List the most recent NPPES Data Dissemination releases

``` r
x <- nppez::ask(
  save = TRUE,
  path = test
)
#> Download Time: 0.55 sec elapsed
#> Error in data.table::fwrite(obj, fs::path(path, fs::path_ext_set(obj[[1]][[1]], : No such file or directory: 'C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp/NPPES_Data_Dissemination_March_2024.csv'. Unable to create new file for writing (it does not exist already). Do you have permission to write here, is there space on the disk and does the path exist?

x
#> Error in eval(expr, envir, enclos): object 'x' not found
```

### Grab

Download NPPES ZIP files to a local directory

``` r
y <- nppez::grab(
  obj   = x, 
  files = "NPPES_Data_Dissemination_030424_031024_Weekly.zip",
  path  = test
  )
#> Error in eval(expr, envir, enclos): object 'x' not found

y
#> Error in eval(expr, envir, enclos): object 'y' not found
```

### Peek

``` r
nppez::peek(path = test)
#> Error: [ENOENT] Failed to search directory 'C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp': no such file or directory
```

    #> Error: [ENOENT] Failed to search directory 'C:/Users/Andrew/Desktop/Repositories/nppez/inst/tmp': no such file or directory

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
