#remove non standard amino acids

remove_nonstandard_aa <- function(df) {
  ## DO: make the seq.aa a generic column
  seq <- df$seq.aa
  df %>% filter(grepl('^[ARNDCEQGHILKMFPSTWYV]+$', seq))
}

#df %>% rename(colname, seqaa)


#if column name is not seq.aa I get the following error:
#Error in filter_impl(.data, quo) : Result must have length 10, not 0
