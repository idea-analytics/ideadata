utils::globalVariables("conn_AEES")




#' Connect to `ResultsView` View or other tables  in `AEES` on `RGVPDRA-DASQL` which provides
#' a tidy (i.e. a long ) view of non-OE responses from the 2020-21 AEES survey
#'
#'
#'
#' @return a `tbl_sql SQL Server` object.
#' @export
#'
#' @examples
#' # This attaches to the school db with \code{conn_AEES} connection
#' \dontrun{
#' aees <- get_aees()
#' }
#'
get_aees <- function(){

  out <- get_table("ResultsView", .database_name = "AEES")

  out

}



#' @describeIn get_aees  `OEQuestions` table in `AEES` on `RGVPDRA-DASQL`
get_aees_oe_questions <- function(){


  out <- get_table("OEQuestions", .database_name = "AEES")

  out

}




#' @describeIn get_aees  `OEResponses` table in `AEES` on `RGVPDRA-DASQL`
get_aees_oe_responses <- function(){


  out <- get_table("OEResponses", .database_name = "AEES")


  out

}


#' @describeIn get_aees  `Questions` table in `AEES` on `RGVPDRA-DASQL`
get_aees_questions <- function(){

  out <- get_table("Questions", .database_name = "AEES")


  out

}


#' @describeIn get_aees  `Results` table in `AEES` on `RGVPDRA-DASQL`
get_aees_results <- function(){


  out <- get_table(.table_name = "Results",
                   .database_name = "AEES",
                   .schema = "dbo",
                   .server_name = "RGVPDRA-DASQL")


  out

}

#' @describeIn get_aees  `Sections` table in `AEES` on `RGVPDRA-DASQL`
get_aees_sections <- function(){


  out <- get_table(.table_name = "Sections",
                   .database_name = "AEES",
                   .schema = "dbo",
                   .server_name = "RGVPDRA-DASQL")


  out

}


