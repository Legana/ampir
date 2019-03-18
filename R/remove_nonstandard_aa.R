#remove non standard amino acids

remove_nonstandard_aa <- function(df, seq) {

  #grab sequence indices that only contain the 20 standard aa
 # logical_vector_for_aa <-seq[grepl('^[ARNDCEQGHILKMFPSTWYV]+$', seq)]
  logical_vector_for_aa <-grepl('^[ARNDCEQGHILKMFPSTWYV]+$', seq)

  df[logical_vector_for_aa,]

}

