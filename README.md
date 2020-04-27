
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

[![Travis build
status](https://travis-ci.org/Legana/ampir.svg?branch=master)](https://travis-ci.org/Legana/ampir)
[![codecov](https://codecov.io/gh/Legana/ampir/branch/master/graph/badge.svg)](https://codecov.io/gh/Legana/ampir)
[![License: GPL
v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![CRAN\_Release\_Badge](http://www.r-pkg.org/badges/version-ago/ampir)](https://CRAN.R-project.org/package=ampir?color=yellow)
![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/grand-total/ampir?color=red)
<!-- badges: end -->

## Installation

Install from CRAN:

``` r
install.packages("ampir")
```

Or install the development version from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("Legana/ampir")
```

``` r
library(ampir)
```

# Background

The **ampir** (short for **a**nti**m**icrobial **p**eptide prediction
**i**n **r** ) package was designed to be a fast and user-friendly
method to predict antimicrobial peptides (AMPs) from any given size
protein dataset. **ampir** uses a *supervised statistical machine
learning* approach to predict AMPs. It incorporates support vector
machine classification models that have been trained on publicly
available antimicrobial peptide data, and also accepts custom (user
trained) models based on the [caret](https://github.com/topepo/caret)
package.

## Usage

Standard input to **ampir** is a `data.frame` with sequence names in the
first column and protein sequences in the second column.

Read in a FASTA formatted file as a `data.frame` with
`read_faa()`

``` r
my_protein_df <- read_faa(system.file("extdata/little_test.fasta", package = "ampir"))
```

| seq\_name                                                                                | seq\_aa                                        |
| :--------------------------------------------------------------------------------------- | :--------------------------------------------- |
| ADV51532.1 preprodamicornin \[Pocillopora damicornis\]                                   | MKVLVILFGAMLVLMEFQKASAATLLEDFDDDDDLLDDGGDFDLE… |
| sp|C0HKQ8|CECA2\_DROME Cecropin-A2 OS=Drosophila melanogaster OX=7227 GN=CecA2 PE=2 SV=1 | MNFYNIFVFVALILAITIGQSEAGWLKKIGKKIERVGQHTRDATI… |
| sp|Q0MWV8|AURE\_AURAU Aurelin OS=Aurelia aurita OX=6145 PE=1 SV=1                        | MGCFKVLVLFAAILCMSLLVCAEDEVNLQAQIEEGPMEAIRSRRA… |
| sp|P36192|DEFI\_DROME Defensin OS=Drosophila melanogaster OX=7227 GN=Def PE=3 SV=1       | MKFFVLVAIAFALLACVAQAQPVSDVDPIPEDHVLVHEDAHQEVL… |
| sp|B3RFR8|HYDMA\_HYDVU Hydramacin-1 OS=Hydra vulgaris OX=6087 PE=1 SV=1                  | MRTVVFFILVSIFLVALKPTGTQAQIVDCWETWSRCTKWSQGGTG… |
| sp|Q492F0|UREF\_BLOPB                                                                    | MCADHGISSVLSLMQLVSSNFPVGSFAYSRGLEWAVENNWVNSVE… |
| sp|C4LIS3|RISB\_CORK4                                                                    | MSGEGSPTITIEPGSAHGLRVAIVVSEWNRDITDELASQAQQAGE… |
| sp|Q9P7J3|CG121\_SCHPO                                                                   | MILPLFPETQVHVFVYENVSNCAAIHEQLISQNPIYDYAFLDAAT… |
| sp|P10055|RL11\_PROVU                                                                    | MAKKVQAYIKLQVSAGMANPSPPVGPALGQQGVNIMEFCKAFNAK… |
| sp|P23938|NG1\_DROME                                                                     | MKITVVLVLLATFLGCVMIHESEASTTTTSTSASATTTTSASATT… |

Calculate the probability that each protein is an antimicrobial peptide
with `predict_amps()`. Since these proteins are all full length
precursors rather than mature peptides we use `ampir`’s built-in
precursor model.

*Note that amino acid sequences that are shorter than five amino acids
long and/or contain anything other than the standard 20 amino acids are
not evaluated and will contain an `NA` as their `prob_AMP`
value.*

``` r
my_prediction <- predict_amps(my_protein_df, model="precursor")
```

| seq\_name                                                                      | seq\_aa                                        | prob\_AMP |
| :----------------------------------------------------------------------------- | :--------------------------------------------- | --------: |
| ADV51532.1 preprodamicornin \[Pocillopora damicornis\]                         | MKVLVILFGAMLVLMEFQKASAATLLEDFDDDDDLLDDGGDFDLE… |     0.237 |
| CECA2\_DROME Cecropin-A2 OS=Drosophila melanogaster OX=7227 GN=CecA2 PE=2 SV=1 | MNFYNIFVFVALILAITIGQSEAGWLKKIGKKIERVGQHTRDATI… |     0.956 |
| AURE\_AURAU Aurelin OS=Aurelia aurita OX=6145 PE=1 SV=1                        | MGCFKVLVLFAAILCMSLLVCAEDEVNLQAQIEEGPMEAIRSRRA… |     0.998 |
| DEFI\_DROME Defensin OS=Drosophila melanogaster OX=7227 GN=Def PE=3 SV=1       | MKFFVLVAIAFALLACVAQAQPVSDVDPIPEDHVLVHEDAHQEVL… |     0.979 |
| HYDMA\_HYDVU Hydramacin-1 OS=Hydra vulgaris OX=6087 PE=1 SV=1                  | MRTVVFFILVSIFLVALKPTGTQAQIVDCWETWSRCTKWSQGGTG… |     0.986 |
| UREF\_BLOPB                                                                    | MCADHGISSVLSLMQLVSSNFPVGSFAYSRGLEWAVENNWVNSVE… |     0.103 |
| RISB\_CORK4                                                                    | MSGEGSPTITIEPGSAHGLRVAIVVSEWNRDITDELASQAQQAGE… |     0.027 |
| CG121\_SCHPO                                                                   | MILPLFPETQVHVFVYENVSNCAAIHEQLISQNPIYDYAFLDAAT… |     0.003 |
| RL11\_PROVU                                                                    | MAKKVQAYIKLQVSAGMANPSPPVGPALGQQGVNIMEFCKAFNAK… |     0.002 |
| NG1\_DROME                                                                     | MKITVVLVLLATFLGCVMIHESEASTTTTSTSASATTTTSASATT… |     0.047 |

Predicted proteins with a specified predicted probability value could
then be extracted and written to a FASTA
file:

``` r
my_predicted_amps <- my_protein_df[my_prediction$prob_AMP >= 0.9,]
```

|   | seq\_name                                                                                | seq\_aa                                        |
| - | :--------------------------------------------------------------------------------------- | :--------------------------------------------- |
| 2 | sp|C0HKQ8|CECA2\_DROME Cecropin-A2 OS=Drosophila melanogaster OX=7227 GN=CecA2 PE=2 SV=1 | MNFYNIFVFVALILAITIGQSEAGWLKKIGKKIERVGQHTRDATI… |
| 3 | sp|Q0MWV8|AURE\_AURAU Aurelin OS=Aurelia aurita OX=6145 PE=1 SV=1                        | MGCFKVLVLFAAILCMSLLVCAEDEVNLQAQIEEGPMEAIRSRRA… |
| 4 | sp|P36192|DEFI\_DROME Defensin OS=Drosophila melanogaster OX=7227 GN=Def PE=3 SV=1       | MKFFVLVAIAFALLACVAQAQPVSDVDPIPEDHVLVHEDAHQEVL… |
| 5 | sp|B3RFR8|HYDMA\_HYDVU Hydramacin-1 OS=Hydra vulgaris OX=6087 PE=1 SV=1                  | MRTVVFFILVSIFLVALKPTGTQAQIVDCWETWSRCTKWSQGGTG… |

Write the `data.frame` with sequence names in the first column and
protein sequences in the second column to a FASTA formatted file with
`df_to_faa()`

``` r
df_to_faa(my_predicted_amps, "my_predicted_amps.fasta")
```
