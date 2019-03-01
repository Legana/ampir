# function to read fasta AA file as a dataframe

read.faa <- function (file = NULL) {
  faa.lines <- readLines(file)

  ### get sequence names
  seq.name.index <- grep(">", faa.lines)
  seq.name <- gsub(">", "", faa.lines[seq.name.index])

  ### get sequence
  seq.aa.start.index <- seq.name.index + 1
  seq.aa.end.index <- c(seq.name.index, length(faa.lines)+1)[-1]-1

  seq.aa <- rep(NA, length(seq.name.index))

  ### replace NA content with actual sequence content, and concatenate the lines
  for(i in 1:length(seq.name.index)){
    seq.aa.start <- seq.aa.start.index[i]
    seq.aa.end   <- seq.aa.end.index[i]
    seq.aa[i] <- gsub("[[:space:]]", "",
                      paste(faa.lines[seq.aa.start:seq.aa.end],
                            collapse = ""))
  }

  res <- data.frame(seq.name, seq.aa)
  return(res)
}
