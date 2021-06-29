output$version_numbers <- renderUI({
	HTML(
		paste(
			"<strong>QA3D:  </strong>", gsub("'", "" , packageVersion("QA3D")),"<p></p>",
			"<strong>R: </strong>", gsub('R version', '', gsub('version.string R ', '', version['version.string'])),"<p></p><br><br><br>",
		sep = "")
	)
})
