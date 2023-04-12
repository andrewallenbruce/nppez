#' @examples
#' rename_seq(n = 5, # can also be 25:300 etc.
#'            new = "identifier_issuer_",
#'            old = "other_provider_identifier_issuer_",
#'            between = " = ")
#' @noRd
rename_seq <- function(n, new, old, between) {

  stringr::str_c(new, seq(n),
                 between,
                 old, seq(n),
                 collapse = ", ")

}
