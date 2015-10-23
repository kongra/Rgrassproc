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

//' An innter loop of a generalized correlation sum. For internal use only.
//' No NAs assumed.
//' @export
// [[Rcpp::export]]
IntegerVector corrPartialCounts(NumericVector x, double r) {
  const int N = x.size();
  IntegerVector result(N);

  for (int i = 1; i <= N; i++) { // Run over every X.k.q
    const double Xkq = x[i];
    int count = 0;
    for (int j = 1; j <= N; j++) {
      if (i == j) continue; // X.k.q was sampled without replacement.
      if (std::abs(x[j] - Xkq) <= r) count += 1;
    }
    result[i] = count;
  }

  return result;
}