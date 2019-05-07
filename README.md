
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction to ampir

<!-- badges: start -->

<!-- badges: end -->

The **ampir** (short for **a**nti**m**icrobial **p**eptide prediction
**i**n **r** ) package was designed to be an open and user-friendly
method to predict AMPs (antimicrobial peptides) from any given size
protein dataset. **ampir** uses four sequential functions to create a
four step approach to predict AMPs.

## Installation

You can install the development version of ampir from
[GitHub](https://github.com/) with:

Note: this does not yet work as the repository is private.

``` r
# install.packages("devtools")
devtools::install_github("Legana/ampir")
```

## Brief background

**ampir** uses a *supervised statistical machine learning* approach to
predict AMPs. Basically this involves making a statistical model based
on *input* data to predict *output* data [James, Witten, Hastie &
Tibshirani 2013](http://www-bcf.usc.edu/~gareth/ISL/). The input data
are also known as *features* which are used to describe the data. To
predict AMPs, physicochemical and compositional properties of protein
sequences are used as features [Osorio, Rondón-Villarreal &
Torres 2015](https://journal.r-project.org/archive/2015/RJ-2015-001/RJ-2015-001.pdf).
Therefore, within this package, it is important to ***follow an order of
functions***.

### Order of functions to follow

1.  `read_faa()` to read FASTA amino acid files.
2.  `remove_nonstandard_aa()` to remove non standard amino acid
    sequences.
3.  `calculate_features()` to calculate data descriptors used by the
    predictive model.
4.  `predict_AMP_prob()` to predict the AMP probability of a protein.

## Example workflow

``` r
library(ampir)
```

### Step 1: Read FASTA amino acid files with `read_faa()`

`read_faa()` reads FASTA amino acid files as a
dataframe.

``` r
my_protein <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
```

| seq.name      | seq.aa                                                                              |
| :------------ | :---------------------------------------------------------------------------------- |
| G1P6H5\_MYOLU | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT |

My
protein

### Step 2: Remove non standard amino acids with `remove_nonstandard_aa()`

`remove_nonstandard_aa()` is used to remove sequences that contain
anything other than the 20 standard amino acids. These sequences are
removed to circumvent potential complications with
calculations.

| seq.name       | seq.aa                                                                              |
| :------------- | :---------------------------------------------------------------------------------- |
| G1P6H5\_MYOLU  | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT |
| fake\_sequence | MKVTHEUSYR$GXMBIJIDG\*M80-%                                                         |

Example dataframe with a nonsense protein

The table above shows a dataframe with protein sequences in it. The
second row contains a made up sequence to serve as an example. This made
up sequence will be removed with
`remove_nonstandard_aa()`.

``` r
my_clean_protein <- remove_nonstandard_aa(nonstandard_example_df)
```

| seq.name      | seq.aa                                                                              |
| :------------ | :---------------------------------------------------------------------------------- |
| G1P6H5\_MYOLU | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT |

My clean protein

### Step 3: Calculate features with `calculate_features()`

`calculate_features()` calculates a range of physicochemical properties
that are used by the predictive model within `predict_AMP_prob()` to
make its predictions (step
4).

``` r
my_protein_features <- calculate_features(my_clean_protein)
```

| seq.name      | Amphiphilicity | Hydrophobicity |    pI |       Mw | Charge | Xc1.A | Xc1.R | Xc1.N | Xc1.D | Xc1.C | Xc1.E | Xc1.Q | Xc1.G | Xc1.H | Xc1.I | Xc1.L | Xc1.K | Xc1.M | Xc1.F | Xc1.P | Xc1.S | Xc1.T | Xc1.W | Xc1.Y | Xc1.V | Xc2.lambda.1 | Xc2.lambda.2 | Xc2.lambda.3 | Xc2.lambda.4 | Xc2.lambda.5 | Xc2.lambda.6 | Xc2.lambda.7 | Xc2.lambda.8 | Xc2.lambda.9 | Xc2.lambda.10 | Xc2.lambda.11 | Xc2.lambda.12 | Xc2.lambda.13 | Xc2.lambda.14 | Xc2.lambda.15 | Xc2.lambda.16 | Xc2.lambda.17 | Xc2.lambda.18 | Xc2.lambda.19 | Xc2.lambda.20 | Xc2.lambda.21 | Xc2.lambda.22 | Xc2.lambda.23 | Xc2.lambda.24 | Xc2.lambda.25 | Xc2.lambda.26 | Xc2.lambda.27 | Xc2.lambda.28 | Xc2.lambda.29 | Xc2.lambda.30 |
| :------------ | -------------: | -------------: | ----: | -------: | -----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | -----------: | -----------: | -----------: | -----------: | -----------: | -----------: | -----------: | -----------: | -----------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: |
| G1P6H5\_MYOLU |          0.415 |          0.437 | 8.501 | 9013.757 |   4.53 | 2.257 | 1.693 |     0 | 0.846 | 2.539 |     0 | 1.693 | 1.411 | 0.282 | 1.128 | 4.232 | 0.564 | 0.564 | 0.564 | 0.846 | 1.411 | 2.539 |     0 | 0.564 | 0.282 |        0.016 |        0.016 |         0.02 |        0.021 |        0.024 |        0.023 |        0.026 |        0.026 |        0.027 |         0.027 |         0.028 |         0.028 |         0.025 |         0.027 |         0.025 |         0.023 |         0.023 |         0.022 |         0.022 |         0.025 |         0.026 |         0.026 |         0.025 |         0.025 |         0.025 |         0.022 |         0.025 |         0.024 |         0.021 |         0.026 |

My protein
features

### Step 4: Predict antimicrobial peptide probability with `predict_AMP_prob()`

`predict_AMP_prob()` uses the output from `calculate_features()` to
predict the probability of a protein to be an antimicrobial peptide.

``` r
my_protein_prediction <- predict_AMP_prob(my_protein_features)
```

| seq.name      | prob\_AMP |
| :------------ | --------: |
| G1P6H5\_MYOLU |     0.972 |

My protein prediction
