
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

# Background

The **ampir** (short for **a**nti**m**icrobial **p**eptide prediction
**i**n **r** ) package was designed to be a fast and user-friendly
method to predict AMPs (antimicrobial peptides) from any given size
protein dataset. **ampir** uses a *supervised statistical machine
learning* approach to predict antimicrobial peptides (AMPs). It
incorporates a model that has been trained on publicly available
antimicrobial peptide data.

**ampir** uses protein sequences as input and produces a table with the
sequence names and the probability of that sequence to be an AMP as
output.

## Usage

``` r
library(ampir)
```

Read protein sequences from a FASTA formatted file with the function
`read_faa()`.

``` r
my_protein <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
```

| seq\_name     | seq\_aa                             |
| :------------ | :---------------------------------- |
| G1P6H5\_MYOLU | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLAD |

My protein

Calculate the probability that each protein is an antimicrobial peptide
with `predict_amps()`

``` r
my_prediction <- predict_amps(my_protein)
#> Proteins less than five amino acids long were removed and totalled at: 0
```

| seq\_name     | prob\_AMP |
| :------------ | --------: |
| G1P6H5\_MYOLU |     0.934 |

My
prediction

### Optional step: Extract AMP sequences using a set probability threshold (default \>= 0.50)

`extract_amps()` uses the output from `read_faa()` and `predict_amps()`
as parameters to create a new dataframe which contains the sequence name
and sequence of the identified antimicrobial peptides at a set
probability threshold of \>= 0.50. The default threshold of \>= 0.50 can
be changed with the “prob”
parameter.

``` r
my_predicted_amps <- extract_amps(df_w_seq = my_protein, df_w_prob = my_prediction, prob = 0.55)
```

| seq\_name     | seq\_aa                             |
| :------------ | :---------------------------------- |
| G1P6H5\_MYOLU | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLAD |

My predicted AMPs

### Optional step: Save sequences as FASTA format file

`df_to_faa()` writes a dataframe containing the sequence and
corresponding sequence name to a FASTA file.

``` r
df_to_faa(my_predicted_amps, "my_predicted_amps.fasta")
```
