
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction to ampir

<!-- badges: start -->

[![Build
Status](https://travis-ci.com/Legana/ampir.svg?token=fesxqj9vWJzeRTtyzLHt&branch=master)](https://travis-ci.com/Legana/ampir)
<!-- badges: end -->

## Installation

You can install the development version of ampir from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Legana/ampir")
```

## Usage

``` r
library(ampir)
```

Standard input to **ampir** is a `data.frame` with sequence names in the
first column and protein sequences in the second column. A convenience
function `read_faa()` is provided to create input data by reading a
FASTA formatted
file.

``` r
```

| seq\_name     | seq\_aa                                        |
| :------------ | :--------------------------------------------- |
| G1P6H5\_MYOLU | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGAT… |

Calculate the probability that each protein is an antimicrobial peptide
with
`predict_amps()`

``` r
my_prediction <- predict_amps(my_protein_df)
```

| seq\_name     | seq\_aa                                        | prob\_AMP |
| :------------ | :--------------------------------------------- | --------: |
| G1P6H5\_MYOLU | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGAT… |     0.895 |
