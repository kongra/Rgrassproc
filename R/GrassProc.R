## Copyright (c) Konrad Grzanek
## Created 2015-10-19

##' @import data.table
##' @import Rmpfr
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
  for (i in seq_along(Cr)) Cr[i] <- corrSum(x, r[i])

  data.table(log.r = logr, log.Cr = log(Cr))
}

##' Returns a value of a generalized correlation sum with an additional q
##' parameter. Uses Rmpfr with precBits. Assumes no NAs in x.
##' @export
corrSumG <- function(x, r, q, precBits = 128) {
  N  <- length(x)
  N1 <- mpfr(N, precBits)
  m  <- N1 * ((N1 - 1) ^ (q - 1))

  counts <- corrPartialCounts(x, r)
  1.0 / m * sum(mpfr(counts, precBits) ^ (q - 1))
}

##' Generalized version of \code{rCr}. For variable values of q.
##' Uses Rmpfr with precBits. Assumes no NAs in x.
##' @export
rCrG <- function(x, k = 100, from = -4, to = 0, q, precBits = 128) {
  logr <- seq(from = from, to = to, length.out = k)
  r    <- exp(logr)
  Cr   <- mpfr(rep(0, k), precBits)
  for (i in seq_along(Cr)) Cr[i] <- corrSumG(x, r[i], q, precBits)

  data.table(log.r = logr, log.Cr = log(Cr))
}
