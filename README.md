
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction to ampir

The **ampir** (short for **a**nti**m**icrobial **p**eptide prediction
**i**n **r** ) package was designed to be a fast and user-friendly
method to predict AMPs (antimicrobial peptides) from large protein
dataset. **ampir** uses a *supervised statistical machine learning*
approach to predict AMPs. It incorporates a support vector machine
classification model that has been trained on publicly available
antimicrobial peptide data.

<!-- badges: start -->

\#[![Travis build
status](https://travis-ci.org/Legana/ampir.svg?branch=master)](https://travis-ci.org/Legana/ampir)
<!-- badges: end -->

## Installation

You can install the development version of ampir from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Legana/ampir")
```

``` r
library(ampir)
```

Standard input to **ampir** is a `data.frame` with sequence names in the
first column and protein sequences in the second column. A convenience
function `read_faa()` is provided to create input data by reading a
FASTA formatted
file.

``` r
my_protein_df <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
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
| G1P6H5\_MYOLU | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGAT… |     0.934 |
