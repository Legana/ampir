calculate_features <- function(seq) {
  mol_weight        <- calc_mw(seq)
  aa_count          <- calc_length(seq)
  isoelectric_point <- calc_pI(seq)
  net_charge        <- calc_net_charge(seq)
  amphiphilicity    <- calc_amphiphilicity(seq)

  cbind(mol_weight, aa_count, isoelectric_point, net_charge, amphiphilicity)
}




