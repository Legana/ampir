#this function calls the predict() function from caret package which is a wrapper for the e1071 package.
#Should I rewrite the code to use the e1071 package instead to build the model?

predict_AMPs <- function(df) {
  #load model
  load("svmRadialwithprobamph.Rdata")

  p_AMP <- predict(svmRadialwithprob_amph, df, type = "prob")


}
