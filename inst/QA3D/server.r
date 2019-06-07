#' Shiny server.r file
#' 
#' This is the server.r file for the interface that utilizes all previous functions. 
#' runApp("QA3D")
#' shinyServer()

library(shiny)
options(rgl.useNULL=TRUE) #required to avoid rgl device opening 
library(rgl)
options(shiny.maxRequestSize=200*1024^2) #30MB file size limit
options(warn = -1) #disables warnings

shinyServer(function(input, output, session) {
	#defines which modules to include
	source(system.file("QA3D/server", 'temp_dir.r', package = "QA3D"), local=TRUE) ###imports temporary directory code
	source(system.file("QA3D/server", 'QA3D.r', package = "QA3D"), local=TRUE) ###imports main QA  code
	source(system.file("QA3D/server", 'system_info.r', package = "QA3D"), local=TRUE) ###imports code to display system information
	source(system.file("QA3D/server", 'URL.r', package = "QA3D"), local=TRUE) ###imports code to display URLs
	#source(system.file("QA3D/server", 'update_gh.r', package = "QA3D"), local=TRUE) ###imports code to check for updates
	source(system.file("QA3D/server", 'about_refs.r', package = "QA3D"), local=TRUE) ###imports code to display references
	source(system.file("QA3D/server", 'changes.r', package = "QA3D"), local=TRUE) ###imports code to display version changes
	source(system.file("QA3D/server", 'exit_parameters.r', package = "QA3D"), local=TRUE) ###imports code to execute when app closes
	source(system.file("QA3D/server", 'shortcut.r', package = "QA3D"), local=TRUE) ###imports code to create shortcut from help menu
	source(system.file("QA3D/server", 'julia.r', package = "QA3D"), local=TRUE) ###imports julia environment
	source(system.file("QA3D/server", 'versions.r', package = "QA3D"), local=TRUE) ###imports versioning code
})