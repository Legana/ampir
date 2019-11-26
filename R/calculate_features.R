#' Calculate a set of numerical features from protein sequences
#'
#' This function calculates set physicochemical and compositional features from protein sequences
#'
#' @note This function depends on the Peptides package
#' @references Osorio, D., Rondon-Villarreal, P. & Torres, R. Peptides: A package for data mining of antimicrobial peptides. The R Journal. 7(1), 4–14 (2015).
#'
#' @param df A dataframe which contains protein sequence names as the first column and amino acid sequence as the second column
#' @param min_len Minimum length sequence for which features can be calculated. It is an error to provide sequences with length shorter than this
#'
#' @return A dataframe containing numerical values related to the protein features of each given protein

calculate_features <- function(df, min_len = 20) {

  short_proteins_index <- nchar(df[,2]) < min_len
  df_cut <- df[!short_proteins_index,]
  if ( sum(short_proteins_index) > 0){
    stop("calculate_features was called on one or more sequences shorter than the specified min_len ")
  }

  seq <- df_cut[,2]
  seq_name <- df_cut[,1]

  Amphiphilicity    <- calc_amphiphilicity(seq)
  Hydrophobicity    <- calc_hydrophobicity(seq)
  Isoelectric_point <- calc_pI(seq)
  Mol_weight        <- calc_mw(seq)
  Net_charge        <- calc_net_charge(seq)
  Pseudo_composition<- calc_pseudo_comp(seq, lambda_min = (min_len-1))

  cbind(seq_name, Amphiphilicity, Hydrophobicity, Isoelectric_point, Mol_weight, Net_charge, Pseudo_composition)
}




