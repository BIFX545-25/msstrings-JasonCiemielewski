#' add_w_noise
#' Add two numbers together plus some noise
#'
#' @param x A number.
#' @param y A number.
#'
#' @returns A numeric vector.
#' @export
#' @importFrom utils rnorm
add_w_noise <- function(x, y) {
  x + y + rnorm()
}
