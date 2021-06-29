session$onSessionEnded(function() {
	unlink(tempdir(), recursive = TRUE)
	stopApp()
})
