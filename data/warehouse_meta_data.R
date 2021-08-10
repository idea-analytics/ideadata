# Creates the meta

#uid <- Sys.getenv("IDEA_RNA_DB_UID")
#pwd <- Sys.getenv("IDEA_RNA_DB_PWD")




# create ODBC Connection String
connection_string <- glue::glue(
  "Driver={Sys.getenv('IDEA_RNA_ODBC_DRIVER')};",
  #"Server=791150-HQVRA.IPS.ORG;",
  "Server=RGVPDRA-DASQL.IPS.ORG;",
  # "UID={creds$uid};",
  #  "PWD={utils::URLencode(creds$pwd)};",
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
warehouse_meta_data <- janitor::clean_names(warehouse_meta_data)
#meta_data <- dplyr::collect(meta_data)

#odbc::dbDisconnect(conn)
rm(conn)
