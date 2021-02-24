globalVariables("conn_GPTW")




#' Connect to `ResultsView` View in `GPTW` on `791150-hqvra` which provides
#' a tidy (i.e.) a long view of non-OE responses from the 2020-21 GPTW survey
#'
#'
#'
#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the school db with \code{conn_Dashboard} connection
#' gptw <- get_gptw()
get_gptw <- function(){

  check_get_connection(.database_name = "GPTW",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("GPTW")

  out <- dplyr::tbl(conn_GPTW,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("ResultsView"))
  )

  out

}



#' @describeIn get_gptw  `OEQuestions` table in `GPTW` on `791150-hqvra`
get_gptw_oe_questions <- function(){

  check_get_connection(.database_name = "GPTW",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("GPTW")

  out <- dplyr::tbl(conn_Dashboard,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("OEQuestions"))
  )

  out

}

#' @describeIn get_gptw  `OERegionResponses` table in `GPTW` on `791150-hqvra`
get_gptw_oe_region_responses <- function(){

  check_get_connection(.database_name = "GPTW",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("GPTW")

  out <- dplyr::tbl(conn_Dashboard,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("OERegionResponses"))
  )

  out

}


#' @describeIn get_gptw  `OEResponses` table in `GPTW` on `791150-hqvra`
get_gptw_oe_responses <- function(){

  check_get_connection(.database_name = "GPTW",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("GPTW")

  out <- dplyr::tbl(conn_Dashboard,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("OEResponses"))
  )

  out

}


#' @describeIn get_gptw  `Questions` table in `GPTW` on `791150-hqvra`
get_gptw_questions <- function(){

  check_get_connection(.database_name = "GPTW",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("GPTW")

  out <- dplyr::tbl(conn_Dashboard,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("Questions"))
  )

  out

}


#' @describeIn get_gptw  `Results` table in `GPTW` on `791150-hqvra`
get_gptw_results <- function(){

  check_get_connection(.database_name = "GPTW",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("GPTW")

  out <- dplyr::tbl(conn_Dashboard,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("Results"))
  )

  out

}

#' @describeIn get_gptw  `Sections` table in `GPTW` on `791150-hqvra`
get_gptw_sections <- function(){

  check_get_connection(.database_name = "GPTW",
                       r_and_a_server = TRUE)

  schema_string <- generate_schema("GPTW")

  out <- dplyr::tbl(conn_Dashboard,
                    dbplyr::in_schema(dbplyr::sql(schema_string),
                                      dbplyr::sql("Sections"))
  )

  out

}


