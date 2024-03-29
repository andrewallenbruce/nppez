#' Generate a sequence of numbers with a new prefix
#'
#' @param n `<int>` Number of sequences to generate
#' @param new `<chr>` New prefix
#' @param old `<chr>` Old prefix
#' @param between `<chr>` Separator between `new` and `old`, default `" = "`
#' @param enclose `<chr>` *(optional)* Vector `length(x) == 2` with which to enclose output
#' @param collapse `<chr>` Separator between sequences, default `", "`
#' @param style `<lgl>` Apply `styler::style_text()` to output, default `TRUE`
#'
#' @return `<chr>` collapsed vector of `n` sequences
#'
#' @examples
#' x <- rename_seq(
#' n        = 3, # can also be 25:300 etc.
#' new      = "id_issuer_",
#' old      = "Other.ID.Issuer.",
#' between  = " = ",
#' enclose  = c("x = c(", ")"),
#' collapse = ",\n ",
#' style    = TRUE)
#'
#' @autoglobal
#' @export
rename_seq <- function(n,
                       new,
                       old,
                       between = " = ",
                       enclose = NULL,
                       collapse = ", ",
                       style = TRUE) {

  x <- stringr::str_c(
    new,
    seq(n),
    between,
    old,
    seq(n),
    collapse = collapse)

  if (!is.null(enclose)) {x <- stringr::str_c(enclose[1], x, enclose[2])}
  if (style) {x <- styler::style_text(x)}
  return(x)
}

#' Format multiple line character vector to single line
#'
#' @param `<chr>` character vector with line breaks (`\n`)
#'
#' @returns `<chr>` single line character vector
#'
#' @examplesIf interactive()
#' is_directory("D:/")
#'
#' @autoglobal
#' @export
#' @keywords internal
single_line_string <- function(x) {

  stringr::str_remove_all(
    x,
    r"(\n\s*)"
    )

}

#' @autoglobal
#' @noRd
months_regex <- function() {
  single_line_string(
    "(Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|
     Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|
     Dec(?:ember)?)\\s+(\\d{1,2})\\,\\s+(\\d{4})")
}

#' Test if a path is a directory
#'
#' @param x `<chr>` path to check
#'
#' @returns named `<lgl>` vector, where the names give the paths. If the given
#'    object does not exist, `NA` is returned.
#'
#' @examplesIf interactive()
#' is_directory("D:/")
#'
#' @autoglobal
#' @export
is_directory <- function(x) {fs::is_dir(x)}

#' Test if a path is readable
#'
#' @param x `<chr>` vector of one or more paths
#'
#' @returns `<lgl>` vector, with names corresponding to input path.
#'
#' @examplesIf interactive()
#' is_readable("D:/")
#'
#' @autoglobal
#' @export
is_readable <- function(x) {fs::file_exists(x)}

#' Clean character vector of numbers
#'
#' @param x `<chr>` vector of numbers
#'
#' @return `<dbl>` vector of numbers
#'
#' @examples
#' clean_number(c("20%", "21,125,458", "$123"))
#'
#' @export
#' @autoglobal
clean_number <- function(x) {

  is_pct <- stringr::str_detect(x, "%")

  x <- x |>
    stringr::str_remove_all("%") |>
    stringr::str_remove_all(",") |>
    stringr::str_remove_all(stringr::fixed("$")) |>
    as.numeric(x)

  dplyr::if_else(is_pct, x / 100, x)
}

#' @examplesIf interactive()
#' dplyr::tibble(x = 1:10,
#'               y = 1:10,
#'               z = letters[1:10]) |>
#'               count_prop(x)
#' @autoglobal
#' @noRd
count_prop <- function(df, var, sort = FALSE) {
  df |>
    dplyr::count({{ var }}, sort = sort) |>
    dplyr::mutate(prop = n / sum(n))
}

#' @examplesIf interactive()
#' dplyr::tibble(x = 1:10,
#'               y = 1:10,
#'               z = letters[1:10]) |>
#'               count_missing(z, x)
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

#' @examplesIf interactive()
#' ggplot2::diamonds |>
#' count_wide(c(clarity, color), cut)
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

#' @examplesIf interactive()
#' dplyr::tibble(x = 1:10,
#'               y = 1:10,
#'               z = letters[1:10]) |>
#'               show_missing(z)
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

#' @examplesIf interactive()
#' dplyr::tibble(x = 1:10,
#'               y = 1:10) |>
#'               df_types()
#' @autoglobal
#' @noRd
df_types <- function(df) {
  dplyr::tibble(
    col_name = names(df),
    col_type = purrr::map_chr(df, vctrs::vec_ptype_full),
    n_miss = purrr::map_int(df, \(x) sum(is.na(x)))
  )
}
