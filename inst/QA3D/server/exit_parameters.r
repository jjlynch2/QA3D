session$onSessionEnded(function() {
	JuliaSetup(remove_cores = TRUE)
	stopApp()
})