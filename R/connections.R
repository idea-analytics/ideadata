if(getRversion() >= "2.15.1")  utils::globalVariables(c("db_locations",
                                                        "server_name",
                                                        "database_name",
                                                        "url"))


#' Get's creds from environment variable
#'
#' @description Looks up user credentials (and local ODBC driver to SQL Server)
#' from environmental variables imported from the user's `.Renviron` file.
#' Use [setup_creds] if this function fails; doing so will get the right entries
#' into your `.Renviron` file.
#'
#' @return a named list with uid (userid), pwd (password), and driver
#'
get_creds <- function(){

  if (any(Sys.getenv(c("IDEA_RNA_DB_UID", "IDEA_RNA_DB_PWD")) == "")) {
    stop(
      crayon::red("DB_USER or DB_PASS environment variables are missing."),
      "\n  Please read set-up vignette to configure your system."
    )
  }


  uid <- Sys.getenv("IDEA_RNA_DB_UID")
  pwd <- Sys.getenv("IDEA_RNA_DB_PWD")
  driver <- Sys.getenv("IDEA_RNA_DB_DRIVER")

  list(uid = uid, pwd = pwd, driver = driver)
}



#' retrieves database URL and server name
#'
#' @param .database_name name of the database you are hoping to connect to.
#' You can view databases by tying `View(`
#'
#' @return a data frame, with on road providing the `server_name`, `database_name`
#' and `url` of the database given by `.database_name`
#'
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' get_db_url("PROD1")

get_db_url <- function(.database_name){
  db_locations %>%
    dplyr::filter(.data$database_name == .database_name)
}


#' Create connection to database
#'
#' @param .database_name name of the database you want to connect to
#' @param r_and_a_server switch for attaching to R&A server. Default is `FALSE`
#'
#' @return returns an S4 object that inherits from DBIConnection.
#' This object is used to communicate with the database engine.
#'
#' Note that this function is called for it's side-effect: it will create
#' a connection object with the name \code{conn_\{.database_name\}} so that other
#' functions and users have access to the connection.
#'
#'
#' @export
#'
#' @examples
#' create_connection("PROD1")
create_connection <- function(.database_name,
                              r_and_a_server = FALSE){

  creds <- get_creds()

  kinit(creds$uid, creds$pwd)

  db_details <- get_db_url(.database_name)

  if(r_and_a_server){
    server <- db_details$server_name
    server <- glue::glue("{server}.IPS.ORG")
  } else {
    server <- db_details$url
  }



  connection_string <- glue::glue(
    "Driver={creds$driver};",
    "Server={server};",
    "UID={creds$uid};",
    "PWD={creds$pwd};",
    "Trusted_Connection=yes;",
    "database={.database_name}"
  )


  connection_name <- glue::glue("conn_{.database_name}")



  conn <- odbc::dbConnect(odbc::odbc(), .connection_string = connection_string)


  # Using a call to global so that this connection object is only made once
  # and is available for all get_* functions
  do.call("<-", list(connection_name, conn),
          envir = globalenv())

}

#' Check if DB connections available and valid or create new one
#'
#' @inheritParams create_connection
#'
#' @return returns an S4 object that inherits from DBIConnection.
#' This object is used to communicate with the database engine.
#'
#' Note that this function is called for it's side-effect: it will create
#' a connection object with the name \code{conn_\{.database_name\}} so that other
#' functions and users have access to the connection.
#' @export
#'
check_get_connection <- function(.database_name,
                                 r_and_a_server = FALSE){

  connection_name <- glue::glue("conn_{.database_name}")

  code <- paste('library(ideadata)',
                glue::glue('create_connection("{.database_name}", r_and_a_server={r_and_a_server})'),
                sep = '\n'     )

  if (!exists(connection_name)) {
    create_connection(.database_name, r_and_a_server) # if not, create connection


    on_connection_open(get(connection_name, envir = globalenv()), code)

  } else { # Check if existing connection is still open
    if (!DBI::dbIsValid(get(connection_name))) {
      create_connection(.database_name, r_and_a_server) # if not, create connection
      on_connection_open(get(connection_name, envir = globalenv()), code)
      }
  }
}


#' Generates server.database.dbo schema string
#'
#' @param .database_name Name of the database your want to connect to
#'
#' @return a string
#'
generate_schema <- function(.database_name){

  db_info <- get_db_url(.database_name)

  schema <- glue::glue("[{db_info$server_name}].[{.database_name}].[dbo]")

  schema
}


#' Disconnect (close) a connection from IDEA's data warehouse
#'
#'
#' @details This is a thing wrapper around [DBI::dbDisconnect()], which closes
#' the connection, discards all pending work, and frees resources (e.g., memory, sockets).
#'
#' @param con the name  [DBI::DBIConnection-class] object **as a string**
#'
#' @return nothing, as it's called for its side-effects
#' @export
#'
#' @examples
#' # The following creates a connect call `conn_PROD1` in global environment
#' regions <- get_regions()
#'
#' disconnect(conn_PROD1)
disconnect <- function(con){

  con_name <- glue::glue("conn_{con@info$dbname}")
  on_connection_closed(con)
  odbc::dbDisconnect(con)

  #con_name <- as_label(enquo(con))

  rm(list = con_name, envir = globalenv())
  cli::cli_alert_success("Connection {con_name} removed")
}
