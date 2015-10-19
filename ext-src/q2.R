## Copyright (c) Konrad Grzanek
## Created 2015-10-19

# library(data.table)
# library(ggplot2)
# library(Rcpp)
#
# DATAFILE <- "input.csv"
#
# readData <- function() {
#   dt <- fread(DATAFILE)
#   x  <- dt[[1]]
#   as.numeric(gsub(",", ".", x))
# } aaa
#
# normalizeTo1 <- function(x) {
#   max.x <- max(x)
#   if (max.x > 1) x <- x / max.x
#   x
# }

# loglog <- function(x, k = 100, from = -4, to = 0) {
#   logy <- seq(from = from, to = to, length.out = k)
#   y    <- exp(logy)
#   f    <- numeric(k)
#   for (i in seq_along(f)) f[i] <- FY2(x, y[i])
#
#   data.table(LogY = logy, LogFY = log(f))
# }
#
# ## WCZYTANIE DANYCH
# x <- normalizeTo1(readData())
#
# ## WERSJA NA 1 RDZEŃ
# system.time(ll <- loglog(x, k = 100, from = -12, to = 0))
# ## OK. 25.5 s na moim 1 rdzeniu AMD E-450
#
# ## ggplot(ll, aes(LogY, LogFY)) + geom_point()
# ## ggsave("Fig1.pdf")
#
# ## WYZNACZAMY WSPÓŁCZYNNIK NACHYLENIA NA CZĘŚCI LINIOWEJ, TUTAJ TO
# ## JEST PRZEDZIAŁ [-10, -2.5]
# llin <- ll[LogY >= -10.0 & LogY <= -2.5]
# ## ggplot(llin, aes(LogY, LogFY)) + geom_point() + stat_smooth(method = lm)
# ## ggsave("Fig2.pdf")
#
# cor(llin$LogY, llin$LogFY) ## 0.9998858 - B. ZNACZNA KORELACJA, MAMY LINIĘ
# fit <- lm(LogFY ~ LogY, data = llin)
#
# ## STATYSTYCZNIE ZNACZĄCE NACHYLENIE WYNOSI 0.958:
# summary(fit)
# ## Call:
# ## lm(formula = LogFY ~ LogY, data = llin)
#
# ## Residuals:
# ##       Min        1Q    Median        3Q       Max
# ## -0.052254 -0.026775 -0.000752  0.030878  0.043374
#
# ## Coefficients:
# ##             Estimate Std. Error t value Pr(>|t|)
# ## (Intercept)  1.39153    0.01235   112.6   <2e-16 ***
# ## LogY         0.95801    0.00187   512.4   <2e-16 ***
# ## ---
# ## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# ## Residual standard error: 0.03193 on 60 degrees of freedom
# ## Multiple R-squared:  0.9998,	Adjusted R-squared:  0.9998
# ## F-statistic: 2.626e+05 on 1 and 60 DF,  p-value: < 2.2e-16
#
# ## WERSJA ZRÓWNOLEGLONA.
# ## library(snow)
#
# ## loglogPar <- function(cl, clustSize, x, k = 100, from = -4, to = 0) {
# ##   logy <- seq(from = from, to = to, length.out = k)
# ##   y    <- exp(logy)
# ##   f    <- numeric(k)
#
# ##   ## Przygotowanie zadań
# ##   tsize <- as.integer(k / clustSize) # Rozmiar zakresu indeksów dla zadania
# ##   tasks <- list()
# ##   for (i in 1:clustSize) {
# ##     i1 <- (i - 1) * tsize + 1 # początek zakresu indeksów dla zadania
# ##     i2 <- i1 + tsize - 1      # koniec   zakresu indeksów dla zadania
# ##     tasks[[i]] <- c(i1, i2)
# ##   }
#
# ##   taskFn <- function(t, x, y, tsize) {
# ##     tryCatch({
# ##       i1   <- t[1]
# ##       i2   <- t[2]
# ##       args <- numeric(tsize)
# ##       vals <- numeric(tsize)
#
# ##       for (i in seq_along(i1:i2)) {
# ##         args[i] <- y[i]
# ##         vals[i] <- FY2(x, y[i])
# ##       }
#
# ##       result <- list()
# ##       result$args <- args
# ##       result$vals <- vals
# ##       result
# ##     },
# ##     error=function(e) {
# ##       print(e)
# ##       stop(e)
# ##     })
# ##   }
#
# ##   results <- clusterApply(cl, tasks, taskFn, x, y, tsize)
# ##   results
# ## }
#
# ## CLUST_SIZE <- 2
# ## cl <- makeMPIcluster(clustSize)
# ## clusterEvalQ(cl,{
# ##   library(Rcpp)
# ##   cppFunction('double FY2(NumericVector x, double y) {
# ##     const int N = x.size();
# ##     int count = 0;
#
# ##     for (int i = 1; i <= N - 1; i++) {
# ##       for (int j = i + 1; j <= N; j++) {
# ##         if (std::abs(x[i] - x[j]) <= y) {
# ##           count += 1;
# ##         }
# ##       }
# ##     }
#
# ##     return 2.0 / (N * (N - 1)) * count;
# ##   }')
# ## })
#
# ## loglogPar(cl, 2, x)
#
# ## stopCluster(cl)
#
# ## # DALSZE POSTĘPOWANIE JAK W PRZYPADKU
