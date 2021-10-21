
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ideadata <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->
<!-- badges: end -->

`ideadata` helps data analysts at IDEA Public Schools access and use
data stored in IDEA’s data warehouse. `ideadata` does so in a
[tidyverse](https://www.tidyverse.org/) friendly way.

`ideadata` is an anagram for “data aide”. Hench the logo. Ooooh Yeah!

<img src='https://media3.giphy.com/media/Zx0BgEPhIevlAVEbnq/giphy.gif' align="center" height = "200" />

## Installation

Since `ideadata` is an internal IDEA package there is only a development
version, which is installed from [GitHub](https://github.com/) with:

``` r
#install.pacakges("remotes")
remotes::install_github("idea-analytics/ideadata")

#renv::install("idea-analytics/ideadata@main") also works
```

## Example

Here’s how you connect to a table in the warehouse.

``` r
library(dplyr)
#> Warning: package 'dplyr' was built under R version 4.0.2
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(ideadata)

schools <- get_schools()
#> christopher.haid's Kereberos TGT is current

head(schools)
#> # Source:   lazy query [?? x 25]
#> # Database: Microsoft SQL Server
#> #   13.00.5888[IPS\christopher.haid@1065574-SQLPRD1/PROD1]
#>   SchoolNumber SchoolName      SchoolShortName StateSchoolNumb… SchoolAbbreviat…
#>          <int> <chr>           <chr>                      <int> <chr>           
#> 1         -101 "Unknown\r\n"    <NA>                       -101 "Unknown\r\n"   
#> 2            2 "IDEA College … "Donna"                108807001 "ICP"           
#> 3            3 "IDEA Academy … "Donna"                108807101 "IA"            
#> 4           41 "IDEA Academy"  "Donna"                108807001 "IMS"           
#> 5           50 "IDEA Academy … "Donna"                108807101 "IPK"           
#> 6           99 "Example High … ""                             0 "EXHS"          
#> # … with 20 more variables: SchoolLowestGrade <int>, SchoolHighestGrade <int>,
#> #   SchoolStreet <chr>, SchoolCity <chr>, SchoolState <chr>,
#> #   SchoolZipCode <dbl>, SchoolPhone <chr>, SchoolFax <chr>,
#> #   PrincipalName <chr>, PrincipalPhone <chr>, PrincipalEmail <chr>,
#> #   CountyNumber <int>, CountyName <chr>, RegionID <dbl>, VPofSchools <dbl>,
#> #   ExecutiveDirector <dbl>, RegionDirectorOfOperations <dbl>,
#> #   CollegeSuccessDirector <dbl>, Area <chr>, RegionAltID <dbl>
```

The `schools` object above is `tbl` object. That means it works with
`dplyr` verbs and functions, but what happens in the background is that
`dplyr` and `dbplyr` generate SQL that is sent to the database you are
connected to and that all computation (e.g., filtering, selecting,
joining, calculations, aggregation) are completed on the remote SQL
Server instance and **not** on your computer.

Nevertheless, you will eventually want to pull that data down onto your
machine when you want to use R or Python do what they can do (like
modeling or graphics) that the database can’t do.

Pulling that data down is easy with \[dplyr::collect()\]

``` r
library(dplyr)

schools_df <- schools %>% 
  collect() %>% 
  janitor::clean_names()
```

(Here `janitor::clean_names()` snake\_cases all the column names).

### What if I am pulling down lots fo data (say, millions of rows)?

In this instance the database connection may fail. It’s not ideal, but
it happens. One way to deal with this is to pull down the data
piecemeal. The `collector()` function in `ideadata` makes this task
trivial. It takes one argument, which is a column name form the table
you want to pull down, which is used to break up the data into smaller
sets of data that are pulled down from the database onto your computer
and then recombined into a single table.

``` r
schools_df <- schools %>% 
  collector(SchoolState, CountyName) %>% 
  janitor::clean_names()
#> Collecting data
#> Pulling data filtered to: is.na(SchoolState), is.na(CountyName) ...
#> Pulling data filtered to: SchoolState == 'FL', is.na(CountyName) ...
#> Pulling data filtered to: SchoolState == 'LA', is.na(CountyName) ...
#> Pulling data filtered to: SchoolState == 'LA', CountyName == 'Orleans Parish' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Bexar' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Bexar County' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Bexar ' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Cameron' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Cameron County' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Ector' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'El Paso' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'El Paso County' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Harris' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Hays' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Hidalgo' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Hidalgo County' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Hildalgo' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'MIDLAND' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'STARR' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Tarrant' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Tarrant County' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Travis' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Travis County' ...
#> Pulling data filtered to: SchoolState == 'TX', CountyName == 'Williamson' ...
#> Pulling data filtered to: SchoolState == 'Unknown\r\n', CountyName == 'Unknown\r\n' ...
#> Data collection complete
```
