## Copyright (c) Konrad Grzanek
## Created 2015-10-26

library(data.table)
library(Rgrassproc)

## LET's GENERATE DATA FOR q IN 2:20
DATAFILE <- "input.csv"

readData <- function() {
  dt <- fread(DATAFILE)
  x  <- dt[[1]]
  as.numeric(gsub(",", ".", x))
}

normalizeTo1 <- function(x) {
  max.x <- max(x)
  if (max.x > 1) x <- x / max.x
  x
}

x <- normalizeTo1(readData())

procq <- function(q) {
  dt        <- rCrG(x, k = 100, from = -12, to = 0, q = q, precBits = 128)
  dt$log.Cr <- as.numeric(dt$log.Cr)
  fileName  <- paste(q, ".csv", sep = "")
  write.csv(dt, fileName)
}

for (q in 2:20) system.time(procq(q))
