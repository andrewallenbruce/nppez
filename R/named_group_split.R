#' Split a Table by Groups with Named List Output
#'
#' This function takes a table, groups it by one or more variables, and then
#' splits the grouped data into a list. The resulting list has names derived
#' from the unique combinations of the grouping variables.
#'
#' @param .tbl A data table or tibble.
#'
#' @param ... One or more unquoted variables by which to group and then split `.tbl`.
#'            Variables can be separated by commas.
#'
#' @returns A named list of tibbles/data tables, where each item corresponds to a unique combination
#'          of the grouping variables. The names of the list items are derived from the unique
#'          combinations of the grouping variables, separated by " / ".
#' @autoglobal
#'
#' @export
named_group_split <- function(.tbl, ...) {

  grouped <- dplyr::group_by(.tbl, ...)

  names <- rlang::inject(
    paste(
      !!!dplyr::group_keys(grouped),
      sep = " / ")
    )

  grouped |>
    dplyr::group_split() |>
    rlang::set_names(names)
}
