## Copyright (c) Konrad Grzanek
## Created 2015-10-19

library(data.table)
library(ggplot2)
library(Rgrassproc)

## LET's GENERATE DATA FOR q IN 2:20
## DATAFILE <- "input.csv"

## readData <- function() {
##   dt <- fread(DATAFILE)
##   x  <- dt[[1]]
##   as.numeric(gsub(",", ".", x))
## }

## normalizeTo1 <- function(x) {
##   max.x <- max(x)
##   if (max.x > 1) x <- x / max.x
##   x
## }

## ## x <- normalizeTo1(readData())

## procq <- function(q) {
##   dt        <- rCrG(x, k = 100, from = -12, to = 0, q = q, precBits = 128)
##   dt$log.Cr <- as.numeric(dt$log.Cr)
##   fileName  <- paste(q, ".csv", sep = "")
##   write.csv(dt, fileName)
## }

## for (q in 2:20) system.time(procq(q))

## READ ALL CSVs, MERGE INTO ONE AND SAVE
## dt2 <- fread("2.csv")
## dt <- data.table(log.r = dt2$log.r, log.Cr.2 = dt2$log.Cr)
## for (q in 3:20) {
##   fileName <- paste(q, ".csv", sep = "")
##   colname  <- paste("log.Cr.", q, sep = "")
##   dt[[colname]] <- fread(fileName)$log.Cr
## }
## write.csv(dt, "qN-output.csv", row.names = FALSE)

## READ COMPLETE CVS
dt <- fread("qN-output.csv")

## GENERATE PLOT FOR EACH q IN 2 .. 20
## plot.q <- function(dt, q, ext = ".pdf") {
##   xcol  <- "log.r"
##   ycol  <- paste("log.Cr.", q, sep = "")
##   fname <- paste("q=", q, ext, sep = "")
##   title <- paste("Correlation integral versus r for q = ", q, sep = "")

##   p <- ggplot(data = dt, aes_string(xcol , ycol)) +
##     geom_point() +
##     ggtitle(title) +
##     xlab("log r") +
##     ylab(expression(log~hat(C)~"(r)"))

##   ggsave(plot = p, filename = fname)
## }
## for (q in 2:20) plot.q(dt, q, ext = ".png")


## ## q = 4, NACHYLENIE 2.763471
## system.time(ll <- rCrG(x, k = 100, from = -12, to = 0, q = 4, precBits = 128))
## ll$log.Cr <- as.numeric(ll$log.Cr)

## llin <- ll[log.r >= -8.0 & log.r <= -2.5]

## cor(llin$log.r, llin$log.Cr)
## fit <- lm(log.Cr ~ log.r, data = llin)
## summary(fit)

## ggplot(ll, aes(log.r, log.Cr)) + geom_point()
## ggsave("Fig1.pdf")
