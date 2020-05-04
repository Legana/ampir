#' Determine row breakpoints for dividing a dataset into chunks for parallel processing
#'
#' @param nrows The number of rows in the dataset to be chunked
#' @param n_cores The number of cores that will be used for parallel processing
#'
#' @return A list of integer vectors consisting of the rows in each chunk
#'

chunk_rows <- function(nrows,n_cores){
  n_chunks <- n_cores
  if ( n_cores>1 && nrows>=n_chunks ){
    chunk_size <- as.integer(floor(nrows/n_chunks)) # This is rounded down to ensure last chunk is always finite in size
    starts <- seq(1,nrows,by=chunk_size)[1:n_chunks]
    ends <- c(seq(1,nrows,by=chunk_size)[2:n_chunks]-1,nrows)
    chunks <- lapply(1:n_chunks,function(i){seq(starts[i],ends[i],by=1)})
  } else {
    n_chunks <- 1
    chunks <- list(seq(1,nrows,by=1))
  }
  chunks
}
