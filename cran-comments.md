# Initial **CRAN** submission for ampir 0.1.0

## Test environments

* local OS X install, R 3.6.1
* ubuntu 16.04.6 (on travis-ci), R 3.6.1 
* win-builder x86_64-w64-mingw32 (64-bit), R 3.6.1


## R CMD check results
* 0 errors | 0 warnings*

There was 1 NOTE in win-builder:

* checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Legana Fingerhut <legana.fingerhut@my.jcu.edu.au>'


## Build Checks

**devtools::check_rhub()**
- Passes all checks on Debian Linux
- Currently failing on Fedora Linux.  The failure is due to a dependency on the `ModelMetrics` which fails to build on this platform.  Unfortunately this is an essential dependency.  Once the `ModelMetrics` package is updated `ampir` should also build on that platform

**devtools::check_win()**
- Package builds fine but gives 1 NOTE

* checking for non-standard things in the check directory ... NOTE
Found the following files/directories:
  'examples_x64' 'tests_i386' 'tests_x64'
  'ampir-Ex_i386.Rout' 'ampir-Ex_x64.Rout' 'examples_i386'



New submission

