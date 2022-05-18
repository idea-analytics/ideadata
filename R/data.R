#' Locations of databases in IDEA's data warehouse
#'
#' A dataset containing the server name, IP address of all IDEA databases
#'
#' @format A data frame with 132 rows and 3 variables:
#' \describe{
#'   \item{server_name}{the server name that hosts the data base in `database_name`}
#'   \item{database_name}{the name of a database, natch}
#'   \item{url}{the IP Address of the server for the data base in `database_name`}
#'   ...
#' }
"db_locations"



#' Field level details of all non-R&A databases in IDEA's data warehouse
#'
#' A dataset containing the fields and their locations (tables, databases, servers)
#'
#' @format A data frame with 69,591 rows and 7 variables:
#' \describe{
#'   \item{server_name}{the server name that hosts the data base in `database_name`}
#'   \item{database_name}{the name of a database, natch}
#'   \item{table_name}{the name of a table, natch}
#'   \item{column_name}{the name of a column, natch}
#'   \item{data_type}{the column's data_type in SQL Server (not R)}
#'   \item{is_nullable}{can the column contain NULL values?}
#'   \item{url}{the IP Address of the server for the data base in `database_name`}
#'   ...
#' }
"data_warehouse_details"



