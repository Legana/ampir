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

