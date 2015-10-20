## Copyright (c) Konrad Grzanek
## Created 2015-10-19

library(data.table)
library(ggplot2)
library(Rgrassproc)
library(snow)

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

## WCZYTANIE DANYCH
x <- normalizeTo1(readData())

## WERSJA ZRÓWNOLEGLONA.
rCrPar <- function(cl, clustSize, x, k = 100, from = -4, to = 0) {
  logr <- seq(from = from, to = to, length.out = k)
  r    <- exp(logr)

  ## Przygotowanie zadań
  tsize <- as.integer(k / clustSize) # Rozmiar zakresu indeksów dla zadania
  tasks <- list()
  for (i in 1:clustSize) {
    i1 <- (i - 1) * tsize + 1 # początek zakresu indeksów dla zadania
    i2 <- i1 + tsize - 1      # koniec   zakresu indeksów dla zadania
    tasks[[i]] <- c(i1, i2)
  }

  taskFn <- function(t, x, r, tsize) {
    tryCatch({
      i1   <- t[1]
      i2   <- t[2]

      Crs <- numeric(tsize)
      for (i in seq_along(i1:i2)) Crs[i] <- corrSum(x, r[i + i1 - 1])
      Crs
    },
    error = function(e) {
      print(e)
      stop(e)
    })
  }

  Crs.list  <- clusterApply(cl, tasks, taskFn, x, r, tsize)
  Cr.result <- numeric()
  for (Crs in Crs.list) Cr.result <- c(Cr.result, Crs)
  data.table(log.r = logr, log.Cr = log(Cr.result))
}

## CLUST_SIZE <- 2
## cl <- makeMPIcluster(CLUST_SIZE)
## cl <- makeCluster(2, type = "MPI")

cl <- makeCluster(c("localhost", "localhost"), type = "SOCK")
clusterEvalQ(cl,{
  library(Rgrassproc)
})

system.time(ll.par <- rCrPar(cl, 2, x, from = -12, to = 0))

stopCluster(cl)
