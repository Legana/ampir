#' Calculate a set of numerical features from protein sequences
#'
#' This function calculates set physicochemical and compositional features from protein sequences
#'
#' @export calculate_features
#'
#' @note This function depends on the Peptides package
#' @references Osorio, D., Rondon-Villarreal, P. & Torres, R. Peptides: A package for data mining of antimicrobial peptides. The R Journal. 7(1), 4–14 (2015).
#'
#' @param seq A single protein sequence or dataframe column containing multiple protein sequences
#'
#' @return A dataframe containing numerical values related to the protein features
#'
#' @examples
#' # Calculate features from Hepcidin AMP from \emph{Myotis lucifugus} (UniProt ID G1P6H5)
#' calculate_features(seq =
#'    "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT")
#'
#' ## Output (showing the first five output columns)
#' #  Amphiphilicity  Hydrophobicity     pI          Mw         Charge    ....
#' # [1]  0.4145847       0.4373494     8.501312     9013.757   4.53015   ....

calculate_features <- function(seq) {
  Amphiphilicity    <- calc_amphiphilicity(seq)
  Hydrophobicity    <- calc_hydrophobicity(seq)
  Isoelectric_point <- calc_pI(seq)
  Mol_weight        <- calc_mw(seq)
  Net_charge        <- calc_net_charge(seq)
  Pseudo_composition<- calc_pseudo_comp(seq)

  cbind(Amphiphilicity, Hydrophobicity, Isoelectric_point, Mol_weight, Net_charge, Pseudo_composition)
}




