## Copyright (c) Konrad Grzanek
## Created 2015-10-19

library(data.table)
library(ggplot2)
library(Rgrassproc)

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

## q = 3, NACHYLENIE 1.869522
system.time(ll <- rCrG(x, k = 100, from = -12, to = 0, q = 3, precBits = 128))
ll$log.Cr <- as.numeric(ll$log.Cr)

llin <- ll[log.r >= -10.0 & log.r <= -2.5]

cor(llin$log.r, llin$log.Cr)
fit <- lm(log.Cr ~ log.r, data = llin)
summary(fit)

## q = 4, NACHYLENIE 2.763471
system.time(ll <- rCrG(x, k = 100, from = -12, to = 0, q = 4, precBits = 128))
ll$log.Cr <- as.numeric(ll$log.Cr)

llin <- ll[log.r >= -8.0 & log.r <= -2.5]

cor(llin$log.r, llin$log.Cr)
fit <- lm(log.Cr ~ log.r, data = llin)
summary(fit)

## q = 5, NACHYLENIE 3.65240
system.time(ll <- rCrG(x, k = 100, from = -12, to = 0, q = 5, precBits = 128))
ll$log.Cr <- as.numeric(ll$log.Cr)

llin <- ll[log.r >= -8.0 & log.r <= -2.5]

cor(llin$log.r, llin$log.Cr)
fit <- lm(log.Cr ~ log.r, data = llin)
summary(fit)
