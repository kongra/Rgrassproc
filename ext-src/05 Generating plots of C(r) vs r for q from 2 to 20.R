## Copyright (c) Konrad Grzanek
## Created 2015-10-26

library(data.table)
library(ggplot2)

dt <- fread("output.csv")

plot.q <- function(dt, q, ext = ".pdf") {
  xcol  <- "log.r"
  ycol  <- paste("log.Cr.", q, sep = "")
  fname <- paste("q=", q, ext, sep = "")
  title <- paste("Correlation integral versus r for q = ", q, sep = "")

  p <- ggplot(data = dt, aes_string(xcol , ycol)) +
    geom_point() +
    ggtitle(title) +
    xlab("log r") +
    ylab(expression(log~hat(C)~"(r)"))

  ggsave(plot = p, filename = fname)
}

for (q in 2:20) plot.q(dt, q, ext = ".png")
for (q in 2:20) plot.q(dt, q, ext = ".pdf")
