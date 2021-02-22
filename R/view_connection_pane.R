

on_connection_open <- function(con, code) {
  library(odbc)
  # RStudio v1.1 generic connection interface --------------------------------
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
      #host <- con@info$servername

      observer$connectionOpened(
        # connection type
        type = con@info$dbms.name,

        # name displayed in connection pane
        displayName = con@info$dbname,

        # host key
        host =  odbc:::computeHostName(con),

        # icon for connection
        icon = odbc::odbcConnectionIcon(con),

        # connection code
        connectCode = code,

        # disconnection code
        disconnect = function() {
          disconnect(con)
        },

        listObjectTypes = function () {
          odbc::odbcListObjectTypes(con)
        },

        # table enumeration code
        listObjects = function(...) {
          odbc::odbcListObjects(con, ...)
        },

        # column enumeration code
        listColumns = function(...) {
          odbc::odbcListColumns(con, ...)
        },

        # table preview code
        previewObject = function(rowLimit, ...) {
          odbc::odbcPreviewObject(con, rowLimit, ...)
        },

        # other actions that can be executed on this connection
        actions = odbc::odbcConnectionActions(con),

        # raw connection object
        connectionObject = con
      )
  }
}


on_connection_closed <- function(con) {
  # make sure we have an observer
  observer <- getOption("connectionObserver")
  if (is.null(observer))
    return(invisible(NULL))

  type <- con@info$dbms.name
  host <- odbc:::computeHostName(con)
  observer$connectionClosed(type, host)
}

on_connection_updated <- function(con, hint) {
  # make sure we have an observer
  observer <- getOption("connectionObserver")
  if (is.null(observer))
    return(invisible(NULL))

  type <- con@info$dbms.name
  host <- odbc:::computeHostName(con)
  observer$connectionUpdated(type, host, hint = hint)
}
