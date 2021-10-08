utils::globalVariables(c("ServerName",
                         "DatabaseName",
                         "Schema",
                         "TableName"))

#' Get an arbitrary table from the data warehouse (more axccurate if database and schema are given)
#'
#' @param .table_name the name of a table as a quoted string that you'd like to obtain
#' @param .database_name the name of the database which hosts the table
#' @param .schema the name of the schema that hosts the table
#' @param ... other arguments passed to `get_table` (recursively); end user won't typcially use this
#'
#' @return a `tbl_sql SQL Server` object (or `Null` if there is not unique table in the warehouse)
#'
#' @details This is a workhouse function that provides direct access to any table we have in the warehouse.
#' If the table name uniquely defines that table then the function looks up the server, database, and schema
#' location and you'll get the table back; if more than one table is identified the function will
#' fail informatively, giving you the `get_table` command to run for every option in the warehouse.
#'
#'  Note well that this function makes at least 2 database calls.  The first is to look up the table location
#'  and then second to get your data.  This means that it will run slower than other `get_*` functions in
#'  this package the don't make the first call: those tables' locations are looked up on a static dateframe.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # This won't return a table, but instead an informative error show all `Students`
#' # tables (20 as of this writing) in the warehouse
#' # The warning provides code that can be copied and pasted to get a given table.
#' students <- get_tables("Students")
#'
#' # Trying again with a specific table in specific schema in a specific database
#'   get_table(.table_name = "Students",
#'             .database_name = "PROD1",
#'             .schema = "Schools")
#'
#' # And here's an example
#' }
#'


get_table <- function(.table_name, .server_name, .database_name, .schema, ...){
  if(missing(.server_name) | missing(.database_name) | missing(.schema)){

    #check_get_hidden_connection()
    #data_warehouse_details <- tbl(get("conn_Documentation", envir = as.environment("package:ideadata")), "MetaData")

    table_in_dbs <- id_tables_in_dbs(.table_name = .table_name,
                                     .database_name = .database_name,
                                     .schema = .schema,
                                     .server_name = .server_name)
      # data_warehouse_details %>%
      # dplyr::select(ServerName, DatabaseName, Schema, TableName) %>%
      # dplyr::filter(TableName == .table_name) %>%
      # dplyr::distinct() %>%
      # collect()

    n_dbs_with_tables <- nrow(table_in_dbs)

    if(n_dbs_with_tables>1) {

      cli::cli_alert_warning(glue::glue("There are {n_dbs_with_tables} tables with that name in our warehouse\n"))
      cli::cli_alert_info("You'll need to specify the database and schema name with db target.\n")
      cli::cli_alert_success("Any of these should work:\n")
      print(glue::glue_data_col(table_in_dbs, '\ \ get_table(.table_name = "{crayon::green(table_name)}", .database_name = "{crayon::green(database_name)}", .schema = "{crayon::green(schema)}", .server_name = "{crayon::green(server_name)})"'))

      return() # returns early with alerts, since we can't id unique table in warehoue

    } else {
      # case where there is actually only one table
      .table_name <- table_in_dbs$table_name
      .database_name <- table_in_dbs$database_name
      .schema <- table_in_dbs$schema
      .server_name <- table_in_dbs$server_name
    }

   #recursivley call this function, since we have all needed data
   out <-get_table(.table_name, .server_name, .database_name, .schema, db_detail = table_in_dbs)

  return(out)

  }

  # get dots if get_table called recursively
  dots <- rlang::dots_list(...)

  if(length(dots) == 0) {
    # case where not called recursively
    db_detail <- id_tables_in_dbs(.table_name, .database_name, .schema)
  } else {
    db_detail <- dots$db_detail
  }

  # double check rows
  nrow_db_detail <- nrow(db_detail)

  if(nrow_db_detail!=1) {
    cli::cli_alert_danger(glue::glue("There are {nrow_db_detail} tables with that name in our warehouse\n"))
    cli::cli_alert_warning(".dn_name, .shema, and .table_name should identify a unique table.\n")
    cli::cli_alert_warning("However, thse are in the warehouse:\n")
    print(glue::glue_data_col(db_detail, '\ \ .table_name = "{crayon::green(table_name)}", .database_name = "{crayon::green(database_name)}", .schema = "{crayon::green(schema)}"'))

    return()

  }

  #is R&A Server?
  is_r_and_a_server <- db_detail$server_name == "791150-HQVRA"

  check_get_connection(.database_name = db_detail$database_name,
                       .schema = db_detail$schema,
                       .server_name = db_detail$server_name,
                       r_and_a_server = is_r_and_a_server)

  schema_string <- glue::glue("[{db_detail$server_name}].[{.database_name}].[{.schema}]")

  connection_name <- glue::glue("conn_{.database_name}")

  out <- dplyr::tbl(src = get(connection_name, envir = globalenv()),
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql(.table_name))
                    )

  out

}


#' Identify rows with given table name, database name, or schema in the MetaData table in the R&A's documentation
#' database.
#'
#' @param .table_name the name of a table that may be located somewhere, as a quoted string
#' @param .database_name the name of a database in the warehouse , as a quoted string
#' @param .schema  the name of a schema in the warehouse, as a quoted string
#'
#' @return a tibble with all unique table, schema, database, and server combinations found in the MetaData table
#' @export
#'
#' @examples
#' \dontrun{
#' library(ideadata)
#'
#' id_tables_in_dbs("Students")
#' }

id_tables_in_dbs <- function(.table_name, .server_name, .database_name , .schema){

  if (missing(.table_name)) stop(".table_name is a required argument to id_tables_in_db")

  #check_get_hidden_connection()
  # data_warehouse_details <- dplyr::tbl(get("conn_Documentation", envir = base::as.environment("ideadata_shim")),
  #                               "MetaData")

  #table_in_dbs <- data_warehouse_details %>%
  table_in_dbs <- warehouse_meta_data %>%
  dplyr::select(server_name, database_name, schema, table_name) %>%
  dplyr::filter(table_name == .table_name) %>%
  dplyr::distinct()

  #extra filtering when we have more details.
  if (!missing(.database_name)) table_in_dbs <- table_in_dbs %>% dplyr::filter(database_name == .database_name)
  if (!missing(.schema)) table_in_dbs <- table_in_dbs %>% dplyr::filter(schema == .schema)
  if (!missing(.server_name)) table_in_dbs <- table_in_dbs %>% dplyr::filter(server_name == .server_name)

  out <- table_in_dbs %>% dplyr::distinct() #%>% dplyr::collect()

  # Return
  out


}
