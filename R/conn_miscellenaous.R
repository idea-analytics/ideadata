get_renstar_math <- function(){


    check_get_connection("SRC_AR")

    out <- dplyr::tbl(conn_SRC_AR, dbplyr::in_schema(dplyr::sql("SRC_AR"),
                                             dplyr::sql("StarMathV2")))

    out

  }
