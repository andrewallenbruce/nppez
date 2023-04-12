
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

| date                | file                                                                 |    size |
|:--------------------|:---------------------------------------------------------------------|--------:|
| 2023-04-12 12:28:01 | D:/nppez_data/zips/NPPES_Data_Dissemination_040323_040923_Weekly.zip |   3.62M |
| 2023-04-12 12:27:59 | D:/nppez_data/zips/NPPES_Data_Dissemination_April_2023.zip           | 851.05M |
| 2023-04-12 12:28:00 | D:/nppez_data/zips/NPPES_Deactivated_NPI_Report_041023.zip           |   1.78M |

# Peek

``` r
nppez::peek(dir = "D:/nppez_data/zips/")
```

| zip                                               | filename                                         | compressed_size | uncompressed_size |
|:--------------------------------------------------|:-------------------------------------------------|----------------:|------------------:|
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | npidata_pfile_20230403-20230409.csv              |           2.48M |            28.33M |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | npidata_pfile_20230403-20230409_fileheader.csv   |           1.35K |            11.98K |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | endpoint_pfile_20230403-20230409.csv             |          64.08K |           330.03K |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | endpoint_pfile_20230403-20230409_fileheader.csv  |             154 |               431 |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | pl_pfile_20230403-20230409.csv                   |         147.18K |           431.35K |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | pl_pfile_20230403-20230409_fileheader.csv        |             160 |               578 |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | othername_pfile_20230403-20230409.csv            |           30.7K |            86.44K |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | othername_pfile_20230403-20230409_fileheader.csv |              53 |                86 |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | NPPES_Data_Dissemination_Readme.pdf              |         459.91K |           556.21K |
| NPPES_Data_Dissemination_040323_040923_Weekly.zip | NPPES_Data_Dissemination_CodeValues.pdf          |         460.77K |           543.72K |
| NPPES_Data_Dissemination_April_2023.zip           | othername_pfile_20050523-20230409.csv            |           8.97M |            25.88M |
| NPPES_Data_Dissemination_April_2023.zip           | othername_pfile_20050523-20230409_fileheader.csv |              53 |                86 |
| NPPES_Data_Dissemination_April_2023.zip           | endpoint_pfile_20050523-20230409.csv             |          17.53M |            96.76M |
| NPPES_Data_Dissemination_April_2023.zip           | endpoint_pfile_20050523-20230409_fileheader.csv  |             154 |               431 |
| NPPES_Data_Dissemination_April_2023.zip           | pl_pfile_20050523-20230409.csv                   |             22M |            65.51M |
| NPPES_Data_Dissemination_April_2023.zip           | pl_pfile_20050523-20230409_fileheader.csv        |             160 |               578 |
| NPPES_Data_Dissemination_April_2023.zip           | npidata_pfile_20050523-20230409.csv              |         801.64M |             8.66G |
| NPPES_Data_Dissemination_April_2023.zip           | npidata_pfile_20050523-20230409_fileheader.csv   |           1.35K |            11.98K |
| NPPES_Data_Dissemination_April_2023.zip           | NPPES_Data_Dissemination_Readme.pdf              |         459.91K |           556.21K |
| NPPES_Data_Dissemination_April_2023.zip           | NPPES_Data_Dissemination_CodeValues.pdf          |         460.77K |           543.72K |
| NPPES_Deactivated_NPI_Report_041023.zip           | NPPES Deactivated NPI Report 20230410.xlsx       |           1.78M |             3.68M |

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

## Weekly Update File

## Monthly Deactivation File

## Monthly Data Dissemination Files
