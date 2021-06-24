
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="inst/logo/ampir_hex.png" width="90" align="right" height="100" />

# Introduction to ampir

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/Legana/ampir.svg?branch=master)](https://travis-ci.com/Legana/ampir)
[![codecov](https://codecov.io/gh/Legana/ampir/branch/master/graph/badge.svg)](https://codecov.io/gh/Legana/ampir)
[![License: GPL
v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![CRAN_Release_Badge](http://www.r-pkg.org/badges/version-ago/ampir)](https://CRAN.R-project.org/package=ampir?color=yellow)
![CRAN_Download_Badge](http://cranlogs.r-pkg.org/badges/grand-total/ampir?color=red)
<!-- badges: end -->

The **ampir** (short for **a**nti**m**icrobial **p**eptide prediction
**i**n **r** ) package was designed to be a fast and user-friendly
method to predict antimicrobial peptides (AMPs) from any given size
protein dataset. **ampir** uses a *supervised statistical machine
learning* approach to predict AMPs. It incorporates two support vector
machine classification models, “precursor” and “mature” that have been
trained on publicly available antimicrobial peptide data. The default
model, “precursor” is best suited for full length proteins and the
“mature” model is best suited for small mature proteins (\<60 amino
acids). **ampir** also accepts custom (user trained) models based on the
[caret](https://github.com/topepo/caret) package. Please see the
**ampir** *“How to train your model”*
[vignette](https://CRAN.R-project.org/package=ampir/vignettes/train_model.html)
for details.

ampir’s associated paper is available in the *Bioinformatics* journal as
[btaa653](https://academic.oup.com/bioinformatics/article-abstract/doi/10.1093/bioinformatics/btaa653/5873588)

## Installation

You can install the released version of ampir from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("ampir")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Legana/ampir")
```

``` r
library(ampir)
```

## Usage

Standard input to **ampir** is a `data.frame` with sequence names in the
first column and protein sequences in the second column.

Read in a FASTA formatted file as a `data.frame` with `read_faa()`

``` r
my_protein_df <- read_faa(system.file("extdata/little_test.fasta", package = "ampir"))
```

| seq_name         | seq_aa                                         |
|:-----------------|:-----------------------------------------------|
| G1P6H5_MYOLU     | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGAT… |
| L5L3D0_PTEAL     | MKPLLIVFVFLIFWDPALAGLNPISSEMYKKCYGNGICRLECYTS… |
| A0A183U1F1_TOXCA | LLRLYSPLVMFATRRVLLCLLVIYLLAQPIHSSWLKKTYKKLENS… |
| Q5F4I1_DROPS     | MNFYKIFIFVALILAISVGQSEAGWLKKLGKRLERVGQHTRDATI… |
| A7S075_NEMVE     | MFLKVVVVLLAVELSVAQSARQRVRPLDRKAGRKRFAPIFPRQCS… |
| F1DFM9_9CNID     | MKVLVILFGAMLVLMEFQKASAATLLEDFDDDDDLLDDGGDFDLE… |
| Q5XV93_ARATH     | MSKREYERQLANEEDEQLRNFQAAVAARSAILHEPKEAALPPPAP… |
| Q2XXN9_POGBA     | MRFLYLLFAVAFLFSVQAEDAELEQEQQGDPWEGLDEFQDQPPDD… |

Calculate the probability that each protein is an antimicrobial peptide
with `predict_amps()`. Since these proteins are all full length
precursors rather than mature peptides we use `ampir`’s built-in
precursor model.

*Note that amino acid sequences that are shorter than 10 amino acids
long and/or contain anything other than the standard 20 amino acids are
not evaluated and will contain an `NA` as their `prob_AMP` value.*

``` r
my_prediction <- predict_amps(my_protein_df, model = "precursor")
```

| seq_name         | seq_aa                                         | prob_AMP |
|:-----------------|:-----------------------------------------------|---------:|
| G1P6H5_MYOLU     | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGAT… |    0.612 |
| L5L3D0_PTEAL     | MKPLLIVFVFLIFWDPALAGLNPISSEMYKKCYGNGICRLECYTS… |    0.945 |
| A0A183U1F1_TOXCA | LLRLYSPLVMFATRRVLLCLLVIYLLAQPIHSSWLKKTYKKLENS… |    0.088 |
| Q5F4I1_DROPS     | MNFYKIFIFVALILAISVGQSEAGWLKKLGKRLERVGQHTRDATI… |    0.998 |
| A7S075_NEMVE     | MFLKVVVVLLAVELSVAQSARQRVRPLDRKAGRKRFAPIFPRQCS… |    0.032 |
| F1DFM9_9CNID     | MKVLVILFGAMLVLMEFQKASAATLLEDFDDDDDLLDDGGDFDLE… |    0.223 |
| Q5XV93_ARATH     | MSKREYERQLANEEDEQLRNFQAAVAARSAILHEPKEAALPPPAP… |    0.009 |
| Q2XXN9_POGBA     | MRFLYLLFAVAFLFSVQAEDAELEQEQQGDPWEGLDEFQDQPPDD… |    0.733 |

Predicted proteins with a specified predicted probability value could
then be extracted and written to a FASTA file:

``` r
my_predicted_amps <- my_protein_df[which(my_prediction$prob_AMP >= 0.8),]
```

|     | seq_name     | seq_aa                                         |
|:----|:-------------|:-----------------------------------------------|
| 2   | L5L3D0_PTEAL | MKPLLIVFVFLIFWDPALAGLNPISSEMYKKCYGNGICRLECYTS… |
| 4   | Q5F4I1_DROPS | MNFYKIFIFVALILAISVGQSEAGWLKKLGKRLERVGQHTRDATI… |

Write the `data.frame` with sequence names in the first column and
protein sequences in the second column to a FASTA formatted file with
`df_to_faa()`

``` r
df_to_faa(my_predicted_amps, "my_predicted_amps.fasta")
```
