JV <- NULL
output$version_numbers <- renderUI({
	HTML(
		paste(
			"<p><h3>Version Details</h3></p>",
			"<strong>QA3D:  </strong>", gsub("'", "" , packageVersion("QA3D")),"<p></p>",
			"<strong>R: </strong>", gsub('R version', '', gsub('version.string R ', '', version['version.string'])),"<p></p>",
			"<strong>Julia: </strong>", JV, "<p></p>","<br><br><br>",
		sep = "")
	)
})