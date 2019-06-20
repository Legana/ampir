The **ampir** (short for **a**nti**m**icrobial **p**eptide prediction
**i**n **r** ) package was designed to be an open and user-friendly
method to predict AMPs (antimicrobial peptides) from any given size
protein dataset. **ampir** uses four sequential functions to create a
four step approach to predict AMPs.

Brief background
================

**ampir** uses a *supervised statistical machine learning* approach to
predict AMPs. Basically this involves making a statistical model based
on *input* data to predict *output* data [James, Witten, Hastie &
Tibshirani 2013](http://www-bcf.usc.edu/~gareth/ISL/). The input data
are also known as *features* which are used to describe the data. To
predict AMPs, physicochemical and compositional properties of protein
sequences are used as features [Osorio, Rondón-Villarreal & Torres
2015](https://journal.r-project.org/archive/2015/RJ-2015-001/RJ-2015-001.pdf).
Therefore, within this package, it is important to ***follow an order of
functions***.

Order of functions to follow
----------------------------

1.  `read_faa()` to read FASTA amino acid files.
2.  `remove_nonstandard_aa()` to remove non standard amino acid
    sequences.
3.  `calculate_features()` to calculate data descriptors used by the
    predictive model.
4.  `predict_AMP_prob()` to predict the AMP probability of a protein.

Example workflow
================

    library(ampir)

### Step 1: Read FASTA amino acid files with `read_faa()`

`read_faa()` reads FASTA amino acid files as a dataframe.

    my_protein <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))

<table>
<caption>My protein</caption>
<thead>
<tr class="header">
<th style="text-align: left;">seq.name</th>
<th style="text-align: left;">seq.aa</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">G1P6H5_MYOLU</td>
<td style="text-align: left;">MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLAD</td>
</tr>
</tbody>
</table>

### Step 2: Remove non standard amino acids with `remove_nonstandard_aa()`

`remove_nonstandard_aa()` is used to remove sequences that contain
anything other than the 20 standard amino acids. These sequences are
removed to circumvent potential complications with calculations.

<table>
<caption>Example dataframe with a nonsense protein</caption>
<thead>
<tr class="header">
<th style="text-align: left;">seq.name</th>
<th style="text-align: left;">seq.aa</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">G1P6H5_MYOLU</td>
<td style="text-align: left;">MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLAD</td>
</tr>
<tr class="even">
<td style="text-align: left;">fake_sequence</td>
<td style="text-align: left;">MKVTHEUSYR$GXMBIJIDG*M80-%</td>
</tr>
</tbody>
</table>

The table above shows a dataframe with protein sequences in it. The
second row contains a made up sequence to serve as an example. This made
up sequence will be removed with `remove_nonstandard_aa()`.

    my_clean_protein <- remove_nonstandard_aa(nonstandard_example_df)

<table>
<caption>My clean protein</caption>
<thead>
<tr class="header">
<th style="text-align: left;">seq.name</th>
<th style="text-align: left;">seq.aa</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">G1P6H5_MYOLU</td>
<td style="text-align: left;">MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLAD</td>
</tr>
</tbody>
</table>

### Step 3: Calculate features with `calculate_features()`

`calculate_features()` calculates a range of physicochemical properties
that are used by the predictive model within `predict_AMP_prob()` to
make its predictions (step 4).

    my_protein_features <- calculate_features(my_clean_protein)
    #> Proteins less than twenty amino acids long were removed and totalled at: 0

<table>
<caption>My protein features ( first six columns )</caption>
<thead>
<tr class="header">
<th style="text-align: left;">seq.name</th>
<th style="text-align: right;">Amphiphilicity</th>
<th style="text-align: right;">Hydrophobicity</th>
<th style="text-align: right;">pI</th>
<th style="text-align: right;">Mw</th>
<th style="text-align: right;">Charge</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">G1P6H5_MYOLU</td>
<td style="text-align: right;">0.415</td>
<td style="text-align: right;">0.437</td>
<td style="text-align: right;">8.501</td>
<td style="text-align: right;">9013.757</td>
<td style="text-align: right;">4.53</td>
</tr>
</tbody>
</table>

### Step 4: Predict antimicrobial peptide probability with `predict_AMP_prob()`

`predict_AMP_prob()` uses the output from `calculate_features()` to
predict the probability of a protein to be an antimicrobial peptide.

    my_prediction <- predict_AMP_prob(my_protein_features)

<table>
<caption>My prediction</caption>
<thead>
<tr class="header">
<th style="text-align: left;">seq.name</th>
<th style="text-align: right;">prob_AMP</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">G1P6H5_MYOLU</td>
<td style="text-align: right;">0.8946007</td>
</tr>
</tbody>
</table>

#### Optional steps: Extract AMP sequences and save as FASTA format file

`extract_amps()` uses the output from `read_faa()` and
`predict_AMP_prob()` as parameters to create a new dataframe which
contains the sequence name and sequence of the identified antimicrobial
peptides at a set probability threshold of &gt;=0.50. The default
threshold of &gt;=0.50 can be changed with the “prob” parameter.

    my_predicted_amps <- extract_amps(df_w_seq = my_protein, df_w_prob = my_prediction, prob = 0.55)

<table>
<caption>My predicted AMPs</caption>
<thead>
<tr class="header">
<th style="text-align: left;">seq.name</th>
<th style="text-align: left;">seq.aa</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">G1P6H5_MYOLU</td>
<td style="text-align: left;">MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLAD</td>
</tr>
</tbody>
</table>

`df_to_faa()` writes a dataframe containing the sequence and
corresponding sequence name to a FASTA file.

    df_to_faa(my_predicted_amps, "my_predicted_amps.fasta")
