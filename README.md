# Introduction to ampir
Predicting AMPs in R

The **ampir** (short for **a**nti**m**icrobial **p**eptide prediction **i**n **r** ) package was designed to be an open and user-friendly method to predict AMPs (antimicrobial peptides) from any given size protein dataset. **ampir** uses four sequential functions to create a four step approach to predict AMPs.

# Brief background

**ampir** uses a *supervised statistical machine learning* approach to predict AMPs. Basically this involves making a statistical model based on *input* data to predict *output* data [James, Witten, Hastie & Tibshirani 2013](http://www-bcf.usc.edu/~gareth/ISL/). The input data are also known as *features* which are used to describe the data. To predict AMPs, physicochemical and compositional properties of protein sequences are used as features [Osorio, Rondón-Villarreal & Torres 2015](https://journal.r-project.org/archive/2015/RJ-2015-001/RJ-2015-001.pdf). Therefore, within this package, it is important to ***follow an order of functions***.

## Order of functions to follow

1. `read_faa()` to read FASTA amino acid files.
2. `remove_nonstandard_aa()` to remove non standard amino acid sequences.
3. `calculate_features()` to calculate data descriptors used by the predictive model.
4. `predict_AMP_prob()` to predict the AMP probability of a protein.

# Example workflow

```{r setup, warning=FALSE, message=FALSE}
library(ampir)
```

### Step 1: Read FASTA amino acid files with `read_faa()` 

`read_faa()` reads FASTA amino acid files as a dataframe.

```{r}
my_protein <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))
```
| seq.name        | seq.aa           | 
| ------------- |:-------------:| 
| G1P6H5_MYOLU     | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT | 

<!-- blabla-->

<!-- This is commented out. 
```{r, echo=FALSE}
#sapply to shorten words in df and use data.frame(as.list) to tidy up kable output
knitr::kable(as.data.frame(as.list(sapply(my_protein, strtrim, 35))), caption = "My protein")
```
-->

### Step 2: Remove non standard amino acids with `remove_nonstandard_aa()`

`remove_nonstandard_aa()` is used to remove sequences that contain anything other than the 20 standard amino acids. These sequences are removed to circumvent potential complications with calculations.

<!-- 
```{r, echo=FALSE}
nonstandard_example_df <- readRDS(system.file("extdata/non_standard_df.rds", package = "ampir"))

knitr::kable(sapply(nonstandard_example_df, strtrim, 35), caption = "Example dataframe with a nonsense protein")
```
-->

| seq.name        | seq.aa           | 
|:-------------: |:-------------:| 
| G1P6H5_MYOLU    | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT | 
| fake_sequence   | MKVTHEUSYR$GXMBIJIDG*M80-%  |   
  

The table above shows a dataframe with protein sequences in it. The second row contains a made up sequence to serve as an example. This made up sequence will be removed with `remove_nonstandard_aa()`.

```{r}
my_clean_protein <- remove_nonstandard_aa(nonstandard_example_df, nonstandard_example_df$seq.aa)
```
<!-- 
```{r, echo=FALSE}
knitr::kable(as.data.frame(as.list(sapply(my_clean_protein, strtrim, 35))), caption = "My clean protein")
```
-->

| seq.name        | seq.aa           | 
| :-------------: |:-------------:| 
| G1P6H5_MYOLU     | MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT | 

### Step 3: Calculate features with `calculate_features()`

`calculate_features()` calculates a range of physicochemical properties that are used by the predictive model within `predict_AMP_prob()` to make its predictions (step 4).

```{r}
prot_features <- calculate_features(my_clean_protein$seq.aa)
```
<!-- 
```{r, echo=FALSE}
knitr::kable(prot_features[1:6], digits = 3, caption = "My protein features ( first six columns )")
```
-->

First three columns

| Amphiphilicity | Hydrophobicity | pI  |
| :-------------:|:-------------:| :-----:|
| 0.4145847      | 0.4373494     | 8.501312 |

### Step 4: Predict antimicrobial peptide probability with `predict_AMP_prob()` 

`predict_AMP_prob()` uses the output from `calculate_features()` to predict the probability of a protein to be an antimicrobial peptide.

```{r}
my_prediction <- predict_AMP_prob(prot_features)
```
<!-- 
```{r, echo=FALSE}
knitr::kable(my_prediction)
```
-->

| prob_AMP | 
| :-------------:|
| 0.999992     | 
