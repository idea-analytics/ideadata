#' Get's creds from environment variable
#'
#' @description
#'
#' @return a names list iwht uid (userid) and pwd (passord)
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

  list(uid = uid, pwd = pwd)
}



#' retrieves database URL and server name
#'
#' @param .database_name
#'
#' @return a data frame, with on road providing the `server_name`, `database_name`
#' and `url` of the database given by `.database_name`
#'
#' @export
#'
#' @examples
#' get_db_url("PROD1")

get_db_url <- function(.database_name){
  db_locations %>%
    filter(database_name == .database_name)
}


#' Create connection to database
#'
#' @param .database_name name of the database you want to connect to
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
create_connection <- function(.database_name){

  creds <- get_creds()

  kinit(creds$uid, creds$pwd)

  driver <- "{ODBC Driver 17 for SQL Server}"
  server <- get_db_url(.database_name) %>% pull(url)

  connection_string <- glue::glue(
    "Driver={driver};",
    "Server={server};",
    "UID={creds$uid};",
    "PWD={creds$pwd};",
    "Trusted_Connection=yes;",
    "database={.database_name}"
  )


  connection_name <- glue::glue("conn_{.database_name}")



  conn <- DBI::dbConnect(odbc::odbc(),
                         .connection_string = connection_string
                         )

  # Using a call to global so that this connection object is only made once
  # and is available for all get_* functions
  do.call("<<-", list(connection_name, conn))
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
check_get_connection <- function(.database_name){

  connection_name <- glue::glue("conn_{.database_name}")

  if (!exists(connection_name)) {
    create_connection(.database_name) # if not, create connection
  } else { # Check if esixint connection is still open
    if (!DBI::dbIsValid(get(connection_name))) {
      create_connection(.database_name) # if not, create connection
    }
  }
}
