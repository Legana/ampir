calc_net_charge <- function(seq) {
  net_charge <- charge(seq)

  as.data.frame(net_charge)
}
