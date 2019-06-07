#generates temporary directories
workingdd <- getwd()
sessiontempd <- QA3D:::randomstring(n = 1, length = 12)
dir.create('tmp')
setwd('tmp')
dir.create(sessiontempd)
setwd(sessiontempd)
sessiontemp <- getwd()