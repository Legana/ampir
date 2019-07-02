
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction to ampir

<!-- badges: start -->

[![Build
Status](https://travis-ci.com/Legana/ampir.svg?token=fesxqj9vWJzeRTtyzLHt&branch=master)](https://travis-ci.com/Legana/ampir)
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

### Additional optional functions

5.  `extract_amps()` to extract predicted AMP sequences based on a set
    probability.
6.  `df_to_faa()` to write a dataframe of sequences as a local FASTA
    file.

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
my_clean_protein <- remove_nonstandard_aa(df = nonstandard_example_df)
```

| seq.name      | seq.aa                                                                              |
| :------------ | :---------------------------------------------------------------------------------- |
| G1P6H5\_MYOLU | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT |

My clean protein

### Step 3: Calculate features with `calculate_features()`

`calculate_features()` calculates a range of physicochemical properties
that are used by the predictive model within `predict_AMP_prob()` to
make its predictions (step 4). It removes sequences less than 20 amino
acids long and reports the quantity of these.

``` r
my_protein_features <- calculate_features(df = my_clean_protein)
#> Proteins less than twenty amino acids long were removed and totalled at: 0
```

| seq.name      | Amphiphilicity | Hydrophobicity |    pI |       Mw | Charge | Xc1.A | Xc1.R | Xc1.N | Xc1.D | Xc1.C | Xc1.E | Xc1.Q | Xc1.G | Xc1.H | Xc1.I | Xc1.L | Xc1.K | Xc1.M | Xc1.F | Xc1.P | Xc1.S | Xc1.T | Xc1.W | Xc1.Y | Xc1.V | Xc2.lambda.1 | Xc2.lambda.2 | Xc2.lambda.3 | Xc2.lambda.4 | Xc2.lambda.5 | Xc2.lambda.6 | Xc2.lambda.7 | Xc2.lambda.8 | Xc2.lambda.9 | Xc2.lambda.10 | Xc2.lambda.11 | Xc2.lambda.12 | Xc2.lambda.13 | Xc2.lambda.14 | Xc2.lambda.15 | Xc2.lambda.16 | Xc2.lambda.17 | Xc2.lambda.18 | Xc2.lambda.19 |
| :------------ | -------------: | -------------: | ----: | -------: | -----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | ----: | -----------: | -----------: | -----------: | -----------: | -----------: | -----------: | -----------: | -----------: | -----------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: | ------------: |
| G1P6H5\_MYOLU |          0.415 |          0.437 | 8.501 | 9013.757 |   4.53 | 3.093 |  2.32 |     0 |  1.16 |  3.48 |     0 |  2.32 | 1.933 | 0.387 | 1.546 | 5.799 | 0.773 | 0.773 | 0.773 |  1.16 | 1.933 |  3.48 |     0 | 0.773 | 0.387 |        0.021 |        0.021 |        0.027 |        0.029 |        0.033 |        0.032 |        0.035 |        0.035 |        0.036 |         0.037 |         0.038 |         0.038 |         0.035 |         0.037 |         0.034 |         0.032 |         0.031 |          0.03 |          0.03 |

My protein
features

### Step 4: Predict antimicrobial peptide probability with `predict_AMP_prob()`

`predict_AMP_prob()` uses the output from `calculate_features()` as a
parameter to predict the probability of a protein to be an antimicrobial
peptide.

``` r
my_prediction <- predict_AMP_prob(df = my_protein_features)
```

| seq.name      | prob\_AMP |
| :------------ | --------: |
| G1P6H5\_MYOLU |     0.895 |

My protein
prediction

### Optional step 5: Extract AMP sequences using a set probability threshold (default \>= 0.50)

`extract_amps()` uses the output from `read_faa()` and
`predict_AMP_prob()` as parameters to create a new dataframe which
contains the sequence name and sequence of the identified antimicrobial
peptides at a set probability threshold of \>= 0.50. The default
threshold of \>= 0.50 can be changed with the “prob”
parameter.

``` r
my_predicted_amps <- extract_amps(df_w_seq = my_protein, df_w_prob = my_prediction, prob = 0.55)
```

| seq.name      | seq.aa                              |
| :------------ | :---------------------------------- |
| G1P6H5\_MYOLU | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLAD |

My predicted AMPs

### Optional step 6: Save sequences as FASTA format file

`df_to_faa()` writes a dataframe containing the sequence and
corresponding sequence name to a FASTA file.

``` r
df_to_faa(my_predicted_amps, "my_predicted_amps.fasta")
```
