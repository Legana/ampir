pkgname <- "ampir"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
base::assign(".ExTimings", "ampir-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('ampir')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("df_to_faa")
### * df_to_faa

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: df_to_faa
### Title: Save a dataframe in FASTA format
### Aliases: df_to_faa

### ** Examples


# Use \code{read_faa} to read a FASTA file as a dataframe
my_protein <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))

# Use \code{df_to_faa} to write a dataframe into FASTA file format
df_to_faa(my_protein,(system.file("extdata/my_protein.fasta", package = "ampir")))


## Output written in "my_protein.fasta"
#[1] >G1P6H5_MYOLU
#[2] MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("df_to_faa", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("extract_amps")
### * extract_amps

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: extract_amps
### Title: Extract predicted antimicrobial peptides (AMPs)
### Aliases: extract_amps

### ** Examples


my_protein <- readRDS(system.file("extdata/my_protein_df.rds", package = "ampir"))
my_prediction <- readRDS(system.file("extdata/my_protein_pred.rds", package = "ampir"))

extract_amps(my_protein, my_prediction, prob = 0.55)

#' ## Output
#         seq_name              seq_aa
# [1] G1P6H5_MYOLU  MALTVRIQAACLLLLLLASLTSYSL....



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("extract_amps", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("predict_amps")
### * predict_amps

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: predict_amps
### Title: Predict the antimicrobial peptide probability of a protein
### Aliases: predict_amps

### ** Examples


my_bat_faa_df <- read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))

predict_amps(my_bat_faa_df)
#       seq_name    prob_AMP
# [1] G1P6H5_MYOLU  0.9723796



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("predict_amps", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("read_faa")
### * read_faa

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: read_faa
### Title: Read FASTA amino acid file into a dataframe
### Aliases: read_faa

### ** Examples


read_faa(system.file("extdata/bat_protein.fasta", package = "ampir"))

## Output
#         seq_name              seq_aa
# [1] G1P6H5_MYOLU  MALTVRIQAACLLLLLLASLTSYSL....



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("read_faa", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("remove_nonstandard_aa")
### * remove_nonstandard_aa

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: remove_nonstandard_aa
### Title: Remove non standard amino acids from protein sequences
### Aliases: remove_nonstandard_aa

### ** Examples


# non_standard_df <- readRDS(system.file("extdata/non_standard_df.rds", package = "ampir"))

## Example dataframe (non_standard_df)
# non_standard_df
#       seq_name            seq_aa
# [1] G1P6H5_MYOLU    MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQ....
# [2] fake_sequence   MKVTHEUSYR$GXMBIJIDG*M80-%

# remove_nonstandard_aa(non_standard_df)

## Output
#       seq_name        seq_aa
# [1] G1P6H5_MYOLU    MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQ....



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("remove_nonstandard_aa", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
