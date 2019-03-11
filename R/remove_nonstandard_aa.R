remove_nonstandard_aa <- function(df, seq) {
  df %>% filter(grepl('^[ARNDCEQGHILKMFPSTWYV]+$', seq))

  df
}

