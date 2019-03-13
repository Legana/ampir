calculate_features <- function(seq) {
  aa_count          <- calc_length(seq)
  amphiphilicity    <- calc_amphiphilicity(seq)
  hydrophobicity    <- calc_hydrophobicity(seq)
  isoelectric_point <- calc_pI(seq)
  mol_weight        <- calc_mw(seq)
  net_charge        <- calc_net_charge(seq)

  composition       <- calc_composition(seq)

  cbind(aa_count, amphiphilicity, hydrophobicity, isoelectric_point, mol_weight, net_charge, composition)
}




