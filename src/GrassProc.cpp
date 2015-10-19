// Copyright (c) Konrad Grzanek
// Created 2015-10-19
//
#include <Rcpp.h>
using namespace Rcpp;

//' Returns a value of the correlation sum. No NAs assumed.
//'
//' @param x the vector
//' @param r distance coefficient
//' @export
// [[Rcpp::export]]
double corrSum(NumericVector x, double r) {
  const int N = x.size();
  int count = 0;

  for (int i = 1; i <= N - 1; i++) {
    for (int j = i + 1; j <= N; j++) {
      if (std::abs(x[i] - x[j]) <= r) {
         count += 1;
       }
     }
   }

   return 2.0 / (N * (N - 1)) * count;
}