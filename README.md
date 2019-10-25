## QA3D 0.1.0
QA3D (Quality Assurance 3D) is an R package that allows the error analysis of repeated scans from three-dimensional equipment. While not requiring the use of skeletal elements, this app was designed and intended to be used with repeated skeletal element scans. Given the rise in popularity of three-dimensional technology in forensic anthropology, there is a need for an FA specific tool to verify the quality of scanners for research and laboratory accreditation purposes.

## Installation
```javascript
install.packages("devtools")
library(devtools)
install_github("jjlynch2/QA3D", ref="v0.1.0")
library(QA3D)
QA3D()
```

## Desktop Icon
Once you run QA3D(), clicking the Desktop Shortcut button on the dashboard will allow you to run QA3D without launching R manually.

## Filetype
Currently only xyzrgb filetypes are supported

## R Dependencies
The following will be installed automatically:
* Morpho
* DT
* shiny
* htmltools
* rgl
* rmarkdown
* knitr
* Rvcg
* colourpicker

## Other Windows Dependencies
The following needs to be installed manually:
* Requires MiKTeX https://miktex.org/download or TinyTeX https://yihui.name/tinytex/
* Requires Pandoc https://pandoc.org/installing.html

## Known Issues
* Some versions of MiKTeX and/or TinyTex require rmarkdown version 1.8 for the pdf report to compile.
