#' @title Functions renamed in helpR 1.0.0
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' helpR 1.0.0 renamed all functions ending in "_chk" to avoid ambiguous function shorthand. These functions all now end in "_check"
#'
#' `diff_chk()` -> `diff_check()`
#'
#' `date_chk()` -> `date_check()`
#'
#' `multi_date_chk()` -> `multi_date_check()`
#'
#' `num_chk()` -> `num_check()`
#'
#' `multi_num_chk()` -> `multi_num_check()`
#'
#' @keywords internal
#' @name rename
#' @aliases NULL
NULL

#' @rdname rename
#' @export
diff_chk <- function(old = NULL, new = NULL, sort = TRUE, return = FALSE){
  lifecycle::deprecate_warn(when = "1.0.0", what = "diff_chk()", "diff_check()")
  diff_check(old = old, new = new, sort = sort, return = return)
}

#' @rdname rename
#' @export
date_chk <- function(data = NULL, col = NULL) {
  lifecycle::deprecate_warn(when = "1.0.0", what = "date_chk()", "date_check()")
  date_check(data = data, col = col)
}

#' @rdname rename
#' @export
multi_date_chk <- function(data = NULL, col_vec = NULL){
  lifecycle::deprecate_warn(when = "1.0.0", what = "multi_date_chk()", "multi_date_check()")
  multi_date_check(data = data, col_vec = col_vec)
}

#' @rdname rename
#' @export
num_chk <- function(data = NULL, col = NULL) {
  lifecycle::deprecate_warn(when = "1.0.0", what = "num_chk()", "num_check()")
  num_check(data = data, col = col)
}

#' @rdname rename
#' @export
multi_num_chk <- function(data = NULL, col_vec = NULL){
  lifecycle::deprecate_warn(when = "1.0.0", what = "multi_num_chk()", "multi_num_check()")
  multi_num_check(data = data, col_vec = col_vec)
}
