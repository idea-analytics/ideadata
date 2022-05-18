
get_warehouse_meta_data <- function(){
  tryCatch({
  # create ODBC Connection String
  connection_string <- glue::glue(
    "Driver={Sys.getenv('IDEA_RNA_ODBC_DRIVER')};",

    "Server=RGVPDRA-DASQL.IPS.ORG;",

    "Trusted_Connection=yes;",
    "database=Documentation"
  )



  # Create ODBC Connection

    conn <- odbc::dbConnect(odbc::odbc(), .connection_string = connection_string)



    warehouse_meta_data  <- dplyr::tbl(conn,
                                       dbplyr::in_schema(dbplyr::sql("[RGVPDRA-DASQL].[Documentation].[dbo]"),
                                                         dbplyr::sql("Metadata"))
    )
    #meta_data <- ideadata::get_table(.table_name = "Metadata", .database_name = "Documentation", .schema = "dbo")
    warehouse_meta_data <-  dplyr::distinct(warehouse_meta_data, ServerName, DatabaseName, Schema, TableName)
    warehouse_meta_data <- dplyr::collect(warehouse_meta_data)
    warehouse_meta_data <- janitor::clean_names(warehouse_meta_data)



    #odbc::dbDisconnect(conn)
    rm(conn)
    rm(connection_string)

    warehouse_meta_data
  },
  error = function(e) {

    if(stringr::str_detect(e$message, "Server is not found")) {

      cli::cli_alert_warning("Are you behind the firewall?\n\n")
      cli::cli_alert_warning(
        crayon::red(
          crayon::bgYellow("When loading ideadata you need to behind IDEA's firewall!!!\nCheck your VPN connection")
        )
      )
      stop(e)
    }
  }
  )




}

