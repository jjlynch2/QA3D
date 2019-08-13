session$onSessionEnded(function() {
	unlink(tempdir(), recursive = TRUE)
	JuliaSetup(remove_cores = TRUE)
	stopApp()
})