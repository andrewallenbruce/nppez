#' @examples
#' rename_seq(n = 5, # can also be 25:300 etc.
#'            new = "identifier_issuer_",
#'            old = "other_provider_identifier_issuer_",
#'            between = " = ")
#' @autoglobal
#' @noRd
rename_seq <- function(n, new, old, between) {

  stringr::str_c(new, seq(n),
                 between,
                 old, seq(n),
                 collapse = ", ")

}
#' @examples
#' dplyr::tibble(x = 1:10, y = 1:10, z = letters[1:10]) |> count_prop(x)
#' @autoglobal
#' @noRd
count_prop <- function(df, var, sort = FALSE) {
  df |>
    dplyr::count({{ var }}, sort = sort) |>
    dplyr::mutate(prop = n / sum(n))
}
#' @examples
#' dplyr::tibble(x = 1:10, y = 1:10, z = letters[1:10]) |> count_missing(z, x)
#' @autoglobal
#' @noRd
count_missing <- function(df, group_vars, x_var) {
  df |>
    dplyr::group_by(dplyr::pick({{ group_vars }})) |>
    dplyr::summarize(
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
    )
}
#' @examples
#' ggplot2::diamonds |> count_wide(c(clarity, color), cut)
#' @noRd
#' @autoglobal
count_wide <- function(data, rows, cols) {
  data |>
    dplyr::count(dplyr::pick(c({{ rows }}, {{ cols }}))) |>
    tidyr::pivot_wider(
      names_from = {{ cols }},
      values_from = n,
      names_sort = TRUE,
      values_fill = 0
    )
}
#' @examples
#' clean_number(c("20%", "21,125,458", "$123"))
#' @noRd
#' @autoglobal
clean_number <- function(x) {
  is_pct <- stringr::str_detect(x, "%")
  num <- x |>
    stringr::str_remove_all("%") |>
    stringr::str_remove_all(",") |>
    stringr::str_remove_all(stringr::fixed("$")) |>
    as.numeric(x)
  dplyr::if_else(is_pct, num / 100, num)
}
#' @examples
#' dplyr::tibble(x = 1:10, y = 1:10, z = letters[1:10]) |> show_missing(z)
#' @autoglobal
#' @noRd
show_missing <- function(df,
                         group_vars,
                         summary_vars = dplyr::everything()) {
  df |>
    dplyr::group_by(dplyr::pick({{ group_vars }})) |>
    dplyr::summarize(
      dplyr::across({{ summary_vars }}, \(x) sum(is.na(x))),
      .groups = "drop"
    ) |> dplyr::select(dplyr::where(\(x) any(x > 0)))
}
#' @examples
#' dplyr::tibble(x = 1:10, y = 1:10) |> df_types()
#' @autoglobal
#' @noRd
df_types <- function(df) {
  dplyr::tibble(
    col_name = names(df),
    col_type = purrr::map_chr(df, vctrs::vec_ptype_full),
    n_miss = purrr::map_int(df, \(x) sum(is.na(x)))
  )
}
#' @examples
#' is_directory("D:/")
#' @autoglobal
#' @noRd
is_directory <- function(x) {
  file.info(x)$isdir
}
#' @examples
#' is_readable("D:/")
#' @autoglobal
#' @noRd
is_readable <- function(x) {
  file.access(x, 4) == 0
}
