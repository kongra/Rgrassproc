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

## WCZYTANIE DANYCH
x <- normalizeTo1(readData())

## WERSJA NA 1 RDZEŃ
system.time(ll <- rCr(x, k = 100, from = -12, to = 0))
## OK. 25.5 s na moim 1 rdzeniu AMD E-450

## ggplot(ll, aes(log.r, log.Cr)) + geom_point()
## ggsave("Fig1.pdf")

## WYZNACZAMY WSPÓŁCZYNNIK NACHYLENIA NA CZĘŚCI LINIOWEJ, TUTAJ TO
## JEST PRZEDZIAŁ [-10, -2.5]
llin <- ll[log.r >= -10.0 & log.r <= -2.5]
## ggplot(llin, aes(log.r, log.Cr)) + geom_point() + stat_smooth(method = lm)
## ggsave("Fig2.pdf")

cor(llin$log.r, llin$log.Cr) ## 0.9998858 - B. ZNACZNA KORELACJA, MAMY LINIĘ
fit <- lm(log.Cr ~ log.r, data = llin)

## STATYSTYCZNIE ZNACZĄCE NACHYLENIE WYNOSI 0.958:
summary(fit)
## Call:
## lm(formula = log.Cr ~ log.r, data = llin)

## Residuals:
##       Min        1Q    Median        3Q       Max
## -0.052254 -0.026775 -0.000752  0.030878  0.043374

## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)
## (Intercept)  1.39153    0.01235   112.6   <2e-16 ***
## log.r        0.95801    0.00187   512.4   <2e-16 ***
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Residual standard error: 0.03193 on 60 degrees of freedom
## Multiple R-squared:  0.9998,	Adjusted R-squared:  0.9998
## F-statistic: 2.626e+05 on 1 and 60 DF,  p-value: < 2.2e-16
