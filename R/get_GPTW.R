utils::globalVariables("conn_GPTW")




#' Connect to `ResultsView` View or other tables  in `GPTW` on `RGVPDRA-DASQL` which provides
#' a tidy (i.e. a long ) view of non-OE responses from the 2020-21 GPTW survey
#'
#'
#'
#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the school db with \code{conn_GPTW} connection
#' \dontrun{
#' gptw <- get_gptw()
#' }
#'
get_gptw <- function(){

  out <- get_table("ResultsView", .database_name = "GPTW")

  out

}



#' @describeIn get_gptw  `OEQuestions` table in `GPTW` on `RGVPDRA-DASQL`
get_gptw_oe_questions <- function(){


  out <- get_table("OEQuestions", .database_name = "GPTW")

  out

}




#' @describeIn get_gptw  `OEResponses` table in `GPTW` on `RGVPDRA-DASQL`
get_gptw_oe_responses <- function(){


  out <- get_table("OEResponses", .database_name = "GPTW")


  out

}


#' @describeIn get_gptw  `Questions` table in `GPTW` on `RGVPDRA-DASQL`
get_gptw_questions <- function(){

  out <- get_table("Questions", .database_name = "GPTW")


  out

}


#' @describeIn get_gptw  `Results` table in `GPTW` on `RGVPDRA-DASQL`
get_gptw_results <- function(){


  out <- get_table(.table_name = "Results",
                   .database_name = "GPTW",
                   .schema = "dbo",
                   .server_name = "RGVPDRA-DASQL")


  out

}

#' @describeIn get_gptw  `Sections` table in `GPTW` on `RGVPDRA-DASQL`
get_gptw_sections <- function(){


  out <- get_table(.table_name = "Sections",
                   .database_name = "GPTW",
                   .schema = "dbo",
                   .server_name = "RGVPDRA-DASQL")


  out

}


