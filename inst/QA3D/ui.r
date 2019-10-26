source(system.file("QA3D/ui", 'exit.r', package = "QA3D"), local=TRUE) ###imports exit button code
source(system.file("QA3D/ui", 'QA3D.r', package = "QA3D"), local=TRUE) ###imports QA3D code
source(system.file("QA3D/ui", 'about.r', package = "QA3D"), local=TRUE) ###imports About code
shinyUI(
	navbarPage(theme = "css/flatly.min.css", windowTitle = "QA3D",
		tags$script(HTML(paste("var header = $('.navbar > .container-fluid');header.append('<div style=\"float:left\"><img src=\"fav.png\" alt=\"alt\" style=\"float:right; width:40px;padding-top:5px;padding-right:5px;\"></div><div style=\"float:right; padding-top:15px\">", 
		uiOutput("memUsage"), "</div>');console.log(header)", sep=""))),
		about,
		QA3D,
		exitb
	)
)
