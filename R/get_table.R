get_table <- function(.table_name, .database_name = NULL, .schema = NULL, ...){
  if(is.null(.database_name) | is.null(.schema)){

    #check_get_hidden_connection()
    #data_warehouse_details <- tbl(get("conn_Documentation", envir = as.environment("package:ideadata")), "MetaData")

    table_in_dbs <- id_tables_in_dbs(.table_name, .database_name, .schema)
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
      print(glue::glue_data_col(table_in_dbs, '\ \ get_table(.table_name = "{crayon::green(TableName)}", .database_name = "{crayon::green(DatabaseName)}", .schema = "{crayon::green(Schema)}")'))

      return() # returns early with alerts, since we can't id unique table in warehoue

    } else {
      # case where there is actually only one table
      .table_name <- table_in_dbs$TableName
      .database_name <- table_in_dbs$DatabaseName
      .schema <- table_in_dbs$Schema
    }

   #recursivley call this function, since we have all needed data
   out <-get_table(.table_name, .database_name, .schema, db_detail = table_in_dbs)

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
    print(glue::glue_data_col(db_detail, '\ \ .table_name = "{crayon::green(TableName)}", .database_name = "{crayon::green(DatabaseName)}", .schema = "{crayon::green(Schema)}"'))

    return()

  }

  #is R&A Server?
  is_r_and_a_server <- db_detail$ServerName == "791150-HQVRA"

  check_get_connection(.database_name = db_detail$DatabaseName,
                       r_and_a_server = is_r_and_a_server)

  schema_string <- glue::glue("[{db_detail$ServerName}].[{.database_name}].[{.schema}]")

  connection_name <- glue::glue("conn_{.database_name}")

  out <- dplyr::tbl(src = get(connection_name, envir = globalenv()),
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql(.table_name))
                    )

  out

}


id_tables_in_dbs <- function(.table_name, .database_name = NULL, .schema = NULL){

  check_get_hidden_connection()
  data_warehouse_details <- tbl(get("conn_Documentation", envir = as.environment("package:ideadata")),
                                "MetaData")

  table_in_dbs <- data_warehouse_details %>%
  dplyr::select(ServerName, DatabaseName, Schema, TableName) %>%
  dplyr::filter(TableName == .table_name) %>%
  dplyr::distinct()

  #extra filtering when we have more details.
  if (!is.null(.database_name)) table_in_dbs <- table_in_dbs %>% filter(DatabaseName == .database_name)
  if (!is.null(.schema)) table_in_dbs <- table_in_dbs %>% filter(Schema == .schema)

  out <- table_in_dbs %>% distinct() %>% collect()

  # Return
  out


}
