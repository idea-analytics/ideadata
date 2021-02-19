## code to prepare `DATASET` dataset goes here
library(readr)
library(here)
library(glue)
library(dplyr)

base_dir <- here()

data_warehouse_details <- read_csv(glue("{base_dir}/data-raw/data_warehouse_details.csv"))
server_urls <- read_csv(glue("{base_dir}/data-raw/server_urls.csv"))
rna_dbs <- read_csv(glue("{base_dir}/data-raw/rna_dbs.csv"))

dw_databases <- data_warehouse_details %>%
  select(server_name,
         database_name) %>%
  distinct()

db_locations <- dw_databases %>%
  left_join(server_urls, by = "server_name") %>%
  bind_rows(., rna_dbs)

# Add  URLS to data_warehouse_detailsls
data_warehouse_details <- data_warehouse_details %>%
  left_join(server_urls, by = "server_name")

usethis::use_data(db_locations, overwrite = TRUE)
usethis::use_data(data_warehouse_details, overwrite = TRUE)
