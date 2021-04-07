globalVariables("conn_Dashboard")




#' Connect to `StarMathV2` or `StarReadingV2` tables in `SRC_AR` on `964592-SQLDS`
#'
#' @details Not that this is a linked server connection from  `791150-HQVRA`
#' (i.e., R&A's SQL Server instance) to `964592-SQLDS`.  Since we need to connect
#' to a database when making a connection we donncet to the `Dashboard` database
#' on `964592-SQLDS`.  Doing so results in the conn_Dashboard connection object,
#' which is fine, but a bit of a hack.
#'
#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the school db with \code{conn_Dashboard} connection
#' schools <- get_schools()
get_renstar_math <- function(){

  check_get_connection(.database_name = "Dashboard",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("SRC_AR")

  out <- dplyr::tbl(conn_Dashboard,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("StarMathV2"))
                    )

  out

}



#' @describeIn get_renstar_math  Connect to `StarReadingV2` table in `SRC_AR` on `964592-SQLDS`
#' @export
get_renstar_reading <- function(){

  check_get_connection(.database_name = "Dashboard",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("SRC_AR")

  out <- dplyr::tbl(conn_Dashboard,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("StarReadingV2"))
  )

  out

}


