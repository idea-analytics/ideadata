#' table level details of all databases in IDEA's data warehouse
#'
#' @name warehouse_meta_data
#' @details A dataset containing the fields and their locations (tables, databases, servers)
#'
#'
#' @format A data frame and 4 variables:
#' \describe{
#'   \item{server_name}{the server name that hosts the data base in `database_name`}
#'   \item{database_name}{the name of a database, natch}
#'   \item{schema}{the name of a schema, natch}
#'   \item{table_name}{the name of a table, natch}
#' }
#' @source generated from MetaData view in the R&A SQL Server instance
NULL
