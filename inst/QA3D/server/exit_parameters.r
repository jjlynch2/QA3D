session$onSessionEnded(function() { 
	JuliaSetup(remove_cores = TRUE)
	stopApp()
})

session$onSessionEnded(function() {
	unlink(sessiontemp, recursive = TRUE)    
})