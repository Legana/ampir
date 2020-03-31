# Minor release to **CRAN** for ampir 0.2.0
## This is new release which contain new features and bug fixes. In this version, we have:

- changed the default minimum length from 20 to 5 in `calculate_features.R` 


# Resubmission to **CRAN** for ampir 0.1.0

- Fixed note that specified the author field differed from the derived Authors@R

- All words within the DESCRIPTION are spelled correctly

  
CRAN reported the following after initial submission:

*Please always add all authors and copyright holders in the Authors@R field with the appropriate roles.
From CRAN policies you agreed to:
"The ownership of copyright and intellectual property rights of all components of the package must be clear and unambiguous (including from the authors specification in the DESCRIPTION file). Where code is copied (or derived) from the work of others (including from R itself), care must be taken that any copyright/license statements are preserved and authorship is not misrepresented.
Preferably, an ‘Authors@R’ would be used with ‘ctb’ roles for the authors of such code. Alternatively, the ‘Author’ field should list these authors as contributors.
Where copyrights are held by an entity other than the package authors, this should preferably be indicated via ‘cph’ roles in the ‘Authors@R’ field, or using a ‘Copyright’ field (if necessary referring to an inst/COPYRIGHTS file)."
e.g.: written by Jinlong Zhang
Please explain in the submission comments what you did about this issue.*

- code for `read_faa.R` and `calc_pseudo_comp.R` were derived from code written by Jinlong Zhang and Nan Xiao, respectively. Both Jinlong Zhang and Nan Xiao have been added to the ‘Authors@R’ section in the DESCRIPTION file and assigned "ctb" roles with a comment to indicate which specific file that person contributed to. An additional person (Ira Cooke) was added as an author as he made significant contributions to the ampir package. 

*The Description field is intended to be a (one paragraph) description
of what the package does and why it may be useful.
Please elaborate.*

*Please add references describing the methods in your package to the description field of your DESCRIPTION file in the form
authors (year) <doi:...>
authors (year) <arXiv:...>
authors (year, ISBN:...)
or only if none those are available:  <https:...>
with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for auto-linking.*

- The Description field was expanded upon and includes methods used supported by the literature.

*You have examples for unexported functions which cannot run in this way.
Please either add ampir::: to the function calls in the examples, omit these examples or export these functions.
e.g. aaseq_is_valid.Rd*

*Some code lines in examples are commented out.
Please never do that. Ideally find toy examples that can be regularly executed and checked. Lengthy examples (> 5 sec), can be wrapped in `\donttest{}`.*

- Removed examples and commented out code lines from unexported functions `aaseq_is_valid()` and `calculate_features()` and updated their documentation. Also removed commented code in test files.

*`\dontrun{}` should be only used if the example really cannot be executed (e.g. because of missing additional software, missing API keys, ...) by the user. That's why wrapping examples in `\dontrun{}` adds the comment ("# Not run:") as a warning for the user.
Does not seem necessary.
Please unwrap the examples if they are executable in < 5 sec, or create additionally small toy examples to allow automatic testing.*

*Please ensure that your functions do not write by default or in your examples/vignettes/tests in the user's home filespace (including the package directory and getwd()). That is not allowed by CRAN policies. Please only write/save files if the user has specified a directory in the function themselves. Therefore please omit any default path = getwd() in writing functions.
In your examples/vignettes/tests you can write to tempdir().
e.g. df_to_faa()*

- Removed `\dontrun{}` from the example in `df_to_faa()` and wrote to `tempdir()` in the examples/vignettes for this function. No other functions within ampir write to files, and no files are written within the tests.

*Please fix and resubmit, and document what was changed in the submission comments.*

# Initial **CRAN** submission for ampir 0.1.0

## Test environments

* local OS X version 10.15.1 install, R 3.6.1
* ubuntu 16.04.6 (on travis-ci), R 3.6.1 
* win-builder x86_64-w64-mingw32 (64-bit), R 3.6.1, R 3.5.3, R Under development (unstable)
* Debian Linux, R-devel, GCC ASAN/UBSAN (R-hub builder)
* Ubuntu Linux 16.04 LTS, R-release, GCC (R-hub builder)
* Fedora Linux, R-devel, clang, gfortran (R-hub builder)
* Windows Server 2008 R2 SP1, R-devel, 32/64 bit (R-hub builder)



## Build Checks

**local OS X version 10.15.1 install**

- Passes all checks (0 errors | 0 warnings | 0 notes)

**ubuntu 16.04.6 (on travis-ci)**

- Passes all checks (0 errors | 0 warnings | 0 notes)

**devtools::check_win()** 

- Package builds fine on R 3.6.1, R 3.5.3 and R Under development (0 errors, 0 warnings) but gives 1 NOTE:

checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Legana Fingerhut <legana.fingerhut@my.jcu.edu.au>'

Possibly mis-spelled words in DESCRIPTION:
  Peptides (3:30)
  peptides (7:49)

- The spelling of these words in the DESCRIPTION are correct

**devtools::check_rhub()**

- Passes all checks on ***Debian Linux***

- Builds fine on ***Ubuntu*** but gives 1 NOTE in regards to possible mis-spelled words, same as mentioned above.

- Currently failing on ***Fedora Linux***. The failure is due to a dependency on the `ModelMetrics` which fails to build on this platform. Unfortunately this is an essential dependency. Once the `ModelMetrics` package is updated `ampir` should also build on that platform

- Currently failing on ***Windows Server 2008***:

#> Warning message: package 'BiocManager' is not available (for R version 3.6.1) 
#> Error in loadNamespace(name) : there is no package called 'BiocManager'

- This failure is due to the missing `BiocManager` package which could be an R-hub issue for the Windows OS. Once `BiocManager` is available for that platform, `ampir` is expected to build successfully.

