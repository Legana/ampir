#' Calculate a set of numerical features from protein sequences
#'
#' This function calculates set physicochemical and compositional features from protein sequences
#'
#' @export calculate_features
#'
#' @note This function depends on the Peptides package
#' @references Osorio, D., Rondon-Villarreal, P. & Torres, R. Peptides: A package for data mining of antimicrobial peptides. The R Journal. 7(1), 4–14 (2015).
#'
#' @param df A dataframe which contains protein sequence names as the first column and amino acid sequence as the second column
#'
#' @return A dataframe containing numerical values related to the protein features of each given protein
#'
#' @examples
#'
#' my_protein <- readRDS(system.file("extdata/my_protein_df.rds", package = "ampir"))
#'
#' # Calculate features from Hepcidin AMP from \emph{Myotis lucifugus} (UniProt ID G1P6H5)
#'
#' calculate_features(my_protein)
#'
#' ## Output (showing the first six output columns)
#' #      seq.name     Amphiphilicity  Hydrophobicity     pI          Mw       Charge    ....
#' # [1] G1P6H5_MYOLU	   0.4145847       0.4373494     8.501312     9013.757   4.53015   ....

calculate_features <- function(df) {

  seq <- df[,2]
  seq.name <- df[,1]

  Amphiphilicity    <- calc_amphiphilicity(seq)
  Hydrophobicity    <- calc_hydrophobicity(seq)
  Isoelectric_point <- calc_pI(seq)
  Mol_weight        <- calc_mw(seq)
  Net_charge        <- calc_net_charge(seq)
  Pseudo_composition<- calc_pseudo_comp(seq)

  cbind(seq.name, Amphiphilicity, Hydrophobicity, Isoelectric_point, Mol_weight, Net_charge, Pseudo_composition)
}




