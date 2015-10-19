## Copyright (c) Konrad Grzanek
## Created 2015-10-19

##' @import data.table
##' @useDynLib Rgrassproc
##' @importFrom Rcpp sourceCpp
NULL

##' Returns a data table representing a dependency between r and C(r)
##' correlation sum on k points over the [from, to] interval. Uses logs both
##' for r and C(r).
##' @export
rCr <- function(x, k = 100, from = -4, to = 0) {
  logr <- seq(from = from, to = to, length.out = k)
  r    <- exp(logr)
  Cr   <- numeric(k)
  for (i in seq_along(f)) Cr[i] <- corrSum(x, r[i])

  data.table(log.r = logr, log.Cr = log(Cr))
}
