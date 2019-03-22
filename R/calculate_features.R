calculate_features <- function(seq) {
  Length            <- calc_length(seq)
  Amphiphilicity    <- calc_amphiphilicity(seq)
  Hydrophobicity    <- calc_hydrophobicity(seq)
  Isoelectric_point <- calc_pI(seq)
  Mol_weight        <- calc_mw(seq)
  Net_charge        <- calc_net_charge(seq)
  Composition       <- calc_composition(seq)
  Pseudo_composition<- calc_pseudo_comp(seq)

  cbind(Length, Amphiphilicity, Hydrophobicity, Isoelectric_point, Mol_weight, Net_charge, Composition, Pseudo_composition)
}




