
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

#renv::install("idea-analytics/ideadata@main") as works
```

## Example

Here’s how you connect to a table in the warehouse.

``` r
library(ideadata)

schools <- get_schools()

head(schools)
```

The `schools` object above is `tbl` object. That means it works with
`dplyr` verbs and functions, but that what happens in the background is
that `dplyr` and `dbplyr` generate slq that is sent to the databvase you
are connected and all computation (e.g., filtering, selecting, joining,
calculations) are on the remote SQL Server instance and **not** on your
computer.

You will eventually want to pull that data down onto your machine, when
you want to use R or Python do what they can do (like modeling or
graphics) that the database can’t do. Pulling that data down is easy
with \[dplyr::collect()\]

``` r
schools_df <- schools %>% 
  collect() %>% 
  janitor::clean_namnes()
```

(Here `janitor::clean_names()` snake\_cases all the column names).

### What if I am pulling down lots fo data (say, millions of rows)?

In this isntance the database connection may fail. It’s not ideal, but
it happens. One way to deal with this is to pull down the data
peicemeal. The `collector()` function in `ideadata` makes this task
trivial. It takes one argument, which is a column name form the table
you want to pull down, which is used to break up the data into smaller
sets of data that are pulled down from the database onto your computer
and then recomined into a single table.

``` r
Stu_att_conn <- get_student_daily_attendance()

stu_att <- Stu_att_conn %>% 
  filter(AcademicYear == "2020-2021) %>% 
  select(StudentNumber, AttDate)
  collector(AttDate) %>% 
  janitor::clean_names()
```
