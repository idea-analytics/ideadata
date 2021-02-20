

on_connection_opened <- function(con, code) {
  library(odbc)
  # RStudio v1.1 generic connection interface --------------------------------
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
      host <- con@info$servername

      observer$connectionOpened(
        # connection type
        type = con@info$dbms.name,

        # name displayed in connection pane
        displayName = con@info$dbname,

        # host key
        host = host,

        # icon for connection
        icon = odbc::odbcConnectionIcon(con),

        # connection code
        connectCode = code,

        # disconnection code
        disconnect = function() {
          dbDisconnect(con)
        },

        listObjectTypes = function () {
          odbcListObjectTypes(con)
        },

        # table enumeration code
        listObjects = function(...) {
          odbcListObjects(con, ...)
        },

        # column enumeration code
        listColumns = function(table, ...) {
          odbcListColumns(con, ...)
        },

        # table preview code
        previewObject = function(rowLimit, ...) {
          odbcPreviewObject(con, rowLimit, ...)
        },

        # other actions that can be executed on this connection
        actions = odbcConnectionActions(con),

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
