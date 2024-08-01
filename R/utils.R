#' Mount [pins][pins::pins-package] board
#'
#' @param source `<chr>` `"local"` or `"remote"`
#'
#' @param ... arguments to pass to [mount_board()]
#'
#' @returns `<pins_board_folder>` or `<pins_board_url>`
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
mount_board <- function(source = c("local", "remote"), ...) {

  source <- match.arg(source)

  switch(
    source,
    local = pins::board_folder(
      fs::path_package(
        "extdata/pins",
        package = "nppez"
      )
    ),
    remote = pins::board_url(
      "https://raw.githubusercontent.com/andrewallenbruce/nppez/main/inst/extdata/pins/"
    )
  )
}

#' List pins from a [pins][pins::pins-package] board
#'
#' @param ... arguments to pass to [mount_board()]
#'
#' @returns `<list>` of [pins][pins::pins-package]
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
list_pins <- function(...) {

  board <- mount_board(...)

  pins::pin_list(board)

}

#' Get a pinned dataset from a [pins][pins::pins-package] board
#'
#' @param pin `<chr>` string name of pinned dataset
#'
#' @param ... arguments to pass to [mount_board()]
#'
#' @returns `<tibble>`
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
get_pin <- function(pin, ...) {

  board <- mount_board(...)

  pin <- rlang::arg_match0(pin, list_pins())

  pins::pin_read(board, pin)

}
