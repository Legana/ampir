#include <Rcpp.h>
using namespace Rcpp;

// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

// [[Rcpp::export]]
NumericVector rcpp_paac(CharacterVector seq, NumericMatrix H, int lambda,float w) {

  int seqlen = seq.length();
  int n = H.nrow();

  // Rcout << "seqlen " << seqlen << "\n";

  CharacterVector hcols = colnames(H);

  // Rcout << "seq " << seq << "\n";
  // Rcout << "hcols " << hcols << "\n";

  IntegerVector seqi = match(seq,hcols);

  // Rcout << "seqi " << seqi << "\n";

  NumericMatrix theta(lambda,seqlen);
  NumericVector theta_rowmeans(lambda);

  theta_rowmeans.fill(0);

  for(int i=1;i<=lambda;i++){
    for(int j=0;j<(seqlen-i);j++){

      int jcol = seqi[j]-1;
      int jcol1 = seqi[j+i]-1;

      NumericVector Hj = H(_,jcol);
      NumericVector Hj1 = H(_,jcol1);
      float theta_ij = 0;
      for(int k=0;k<n;k++){
        theta_ij+=(Hj[k]-Hj1[k])*(Hj[k]-Hj1[k]);
        // if ( i == 0 ){
        //   Rcout << "tij " << theta_ij << " i " << i << " j " << j << " k " << k <<  " Hj " << Hj[k] << " Hj1 " << Hj1[k] << "\n";
        // }
      }

      theta(i-1,j)=theta_ij/(1.0*n);
      theta_rowmeans[i-1]+=theta(i-1,j);
    }
    // Rcout << "thm " << theta_rowmeans[i-1] << "\n";
    theta_rowmeans[i-1]=theta_rowmeans[i-1]/(1.0*(seqlen-i));
  }

  IntegerVector fc(hcols.length());
  fc.fill(0);

  for(int i = 0;i < seqlen; i++){
    if(fc[seqi[i]-1]<21){
      fc[seqi[i]-1]+=1;
    }
  }

  // Rcout << "theta " << theta_rowmeans << "\n";

  float wtheta = w * sum(theta_rowmeans);


  int ncols = hcols.length();

  NumericVector results(ncols+lambda);

  // # Compute first 20 features
  // These correspond to the sum of total abundance for each AA
  //
  //   fc  = summary(factor(xSplitted, levels = AADict), maxsum = 21)
  //     Xc1 = fc/(1 + (w * sum(theta)))
  //     names(Xc1) = paste('Xc1.', names(Xc1), sep = '')
  //
  for(int i=0;i<ncols;i++){
    results[i] = fc[i]/(1+wtheta);
  }

  // Rcout << "results " << results << "\n";

// # Compute last lambda features
//
// Xc2 = (w * theta)/(1 + (w * sum(theta)))
//   names(Xc2) = paste('Xc2.lambda.', 1:lambda, sep = '')
  for(int i=0;i<lambda;i++){
    results[i+ncols] = (w*theta_rowmeans[i])/(1+wtheta);
  }


  return(results);

}


// You can include R code blocks in C++ files processed with sourceCpp
// (useful for testing and development). The R code will be automatically
// run after the compilation.
//

/*** R
AAidx = ampir:::ampir_package_data[['AAidx']]
aaidx = AAidx[, -1]
row.names(aaidx) = AAidx[, 1]
props = c('Hydrophobicity', 'Hydrophilicity', 'SideChainMass')
n = length(props)

# Standardize H0 to H

H0 = as.matrix(aaidx[props, ])

H  = matrix(ncol = 20, nrow = n)
for (i in 1:n) H[i, ] =
  (H0[i, ] - mean(H0[i, ]))/(sqrt(sum((H0[i, ] - mean(H0[i, ]))^2)/20))
AADict = c(
      'A', 'R', 'N', 'D', 'C', 'E', 'Q', 'G', 'H', 'I',
      'L', 'K', 'M', 'F', 'P', 'S', 'T', 'W', 'Y', 'V')
dimnames(H) = list(props, AADict)
seq <- "MALTVRIQAACLLLLLLASLTSYSLLLSQTTQLADLQTQDTAGATAGLMPGLQRRRRRDTHFPICIFCCGCCYPSKCGICCKT"
sseq <- strsplit(seq,"")[[1]]
rcpp_paac(sseq,H,4,0.05)

ampir:::extractPAAC(seq,lambda=4)

rcpp_paac(sseq,H,4,0.05) - ampir:::extractPAAC(seq,lambda=4,w=0.05)

  */
