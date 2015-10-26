## Copyright (c) Konrad Grzanek
## Created 2015-10-26

library(data.table)

dt2 <- fread("2.csv")
dt <- data.table(log.r = dt2$log.r, log.Cr.2 = dt2$log.Cr)

for (q in 3:20) {
  fileName <- paste(q, ".csv", sep = "")
  colname  <- paste("log.Cr.", q, sep = "")
  dt[[colname]] <- fread(fileName)$log.Cr
}

write.csv(dt, "output.csv", row.names = FALSE)
