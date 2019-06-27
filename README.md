## QA3D 0.0.1
QA3D (Quality Assurance 3D) is an R package that allows the error analysis of repeated scans from three-dimensional equipment. While not requiring the use of skeletal elements, this app was designed and intended to be used with repeated skeletal element scans. Given the rise in popularity of three-dimensional technology in forensic anthropology, there is a need for an FA specific tool to verify the quality of scanners for research and laboratory accreditation purposes.

## Installation
```R
install.packages("devtools")
library(devtools)
install_github("jjlynch2/QA3D", ref="v0.0.1")
library(QA3D)
QA3D()
```

## Desktop Icon
Once you run QA3D(), clicking the Desktop Shortcut button on the dashboard will allow you to run QA3D without launching R manually.

## R Dependencies
The following will be installed automatically:
* Morpho
* DT
* shiny
* htmltools
* rgl
* ClusterR
* JuliaCall
* rmarkdown
* knitr

## Julia Dependencies
The following will be installed automatically:
* Distributed
* SharedArrays

## Other Windows Dependencies
The following needs to be installed manually:
* Requires MiKTeX https://miktex.org/download
* Requires Pandoc https://pandoc.org/installing.html
* Julia must be in your PATH to run.

## Known Bugs
A bug exists in the StatsModels package version 0.6.0 in Julia, which prevents RCall from precompiling. This bug breaks JuliaCall in R. Downgrading the package to version 0.5.0 will allow QA3D to run properly.