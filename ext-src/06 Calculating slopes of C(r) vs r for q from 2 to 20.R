## Copyright (c) Konrad Grzanek
## Created 2015-10-26

library(data.table)

rCr.slope <- function(dt, q, interval) {
  x1  <- interval[1]
  x2  <- interval[2]
  lin <- dt[log.r >= x1 & log.r <= x2]
  m   <- lm(paste("log.Cr.", q, " ~ log.r", sep = ""), data = lin)

  coef(m)[2]
}

intervals <-
  list(c(-10, -2.5),  # q = 2
       c(-8, -2.5),   # q = 3
       c(-7.5, -2.5), # q = 4
       c(-7.5, -2.5), # q = 5
       c(-7.5, -2.5), # q = 6
       c(-7.5, -2.5), # q = 7
       c(-7.5, -2.5), # q = 8
       c(-7.5, -2.5), # q = 9
       c(-7.5, -2.5), # q = 10
       c(-7.5, -2.5), # q = 11
       c(-7.5, -2.5), # q = 12
       c(-7.5, -2.5), # q = 13
       c(-7.5, -2.5), # q = 14
       c(-7.5, -2.5), # q = 15
       c(-7.5, -2.5), # q = 16
       c(-7.5, -2.5), # q = 17
       c(-7.5, -2.5), # q = 18
       c(-7.5, -2.5), # q = 19
       c(-7.5, -2.5)) # q = 20

rCr.slopes <- function(dt) {
  results <- data.table(q = integer(19))
  for (i in seq_along(intervals)) {
    q <- i + 1
    s <- rCr.slope(dt, q, intervals[[i]])
    set(results, i = i, j = "q",         value = q)
    set(results, i = i, j = "rCr.slope", value = s)
  }
  results
}

dt <- rCr.slopes(fread("output.csv"))
##  q  rCr.slope
##  2  0.9580097
##  3  1.8628508
##  4  2.7469052
##  5  3.6311401
##  6  4.5067391
##  7  5.3754579
##  8  6.2385060
##  9  7.0967869
## 10  7.9510088
## 11  8.8017414
## 12  9.6494509
## 13 10.4945234
## 14 11.3372829
## 15 12.1780039
## 16 13.0169219
## 17 13.8542410
## 18 14.6901393
## 19 15.5247737
## 20 16.3582828

cor(dt$q, dt$rCr.slope) # 0.9999474 LINEAR DEPENDENCY OF rCr.slope and q

## rCr.slope = -0.635284 + 0.853317 * q
m <- lm(rCr.slope ~ q, data = dt)
summary(m)
## Call:
## lm(formula = rCr.slope ~ q, data = dt)

## Residuals:
##      Min       1Q   Median       3Q      Max
## -0.11334 -0.03268  0.01354  0.04123  0.05313

## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)
## (Intercept) -0.635284   0.026083  -24.36 1.17e-14 ***
## q            0.853317   0.002123  402.01  < 2e-16 ***
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Residual standard error: 0.05068 on 17 degrees of freedom
## Multiple R-squared:  0.9999,	Adjusted R-squared:  0.9999
## F-statistic: 1.616e+05 on 1 and 17 DF,  p-value: < 2.2e-16
