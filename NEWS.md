# ampir 1.0.1

- fixed an example in the README which resulted in NAs output (@Ebedthan, #20)


# ampir 1.0.0 (11/05/2020)

## This is new release which contain new features and bug fixes. In this version, we have:

- added the `remove_non_standardaa.R` function 
- exported `calculate_features.R` 
- tidied up code to improve running speed of `calculate_features.R`
- changed the default min_len parameter in `calculate_features` from 20 to 10
- included the option to parallelise `predict_amps.R` 
- inluded the option to add self-trained models to `predict_amps.R`
- added another vignette (`train_model.Rmd`) detailing how to train models for `predict_amps.R`
- updated the default prediction model used in `predict_amps.R` and optimised it for precursor proteins
- added a secondary prediction model for use in `predict_amps.R`, optimised for mature proteins
- updated introduction to ampir vignette (`ampir.Rmd`) and `README.Rmd`

# ampir 0.1.0 (20/11/2019)

## Initial release to GitHub 

* Prior to this, it was a private package 

## Initial submission

* **CRAN** Initial submission
