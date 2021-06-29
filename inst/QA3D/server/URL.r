output$URL <- renderUI({	
	HTML(paste(
	"<strong>Website: </strong>",
	a("OsteoCodeR.com", href='https://OsteoCodeR.com/QA3D.html', target='_blank'),
	"<p></p>",
	"<strong>Source Code: </strong>",
	a(img(" Repository", src='github.png',width='20px'), href='https://github.com/jjlynch2/QA3D', target='_blank')
	,sep=""))
})
