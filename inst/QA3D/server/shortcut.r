observeEvent(input$Create_Desktop_Icon, {
	if(Sys.info()[['sysname']] == "Windows") {
		target <- paste('"', file.path(R.home("bin"), "R.exe"), '"', sep="")
		arguments <- paste('"', "-e ", "library(QA3D);QA3D()", '"', sep="")
		icon <- paste('"', system.file("vbs/QA3D.ico", package = "QA3D"), '"', sep="")
		pathname <- paste('"', paste(gsub("/Documents", "", file.path(path.expand("~"), "Desktop") ), "QA3D.lnk", sep = "/"), '"', sep="")
		vbs <- paste('"', system.file("vbs/createLink.vbs", package = "QA3D"), '"', sep="")
		system(paste("cscript", vbs, pathname, target, arguments, icon, sep=" "))
	}
	if(Sys.info()[['sysname']] == "Linux") {
		icon_name <- "QA3D.desktop"
		cat(
			paste(
				"[Desktop Entry]\nEncoding=UTF-8\nTerminal=true\nType=Application\nCategories=Application\nName=QA3D\n",
				"Version=",	packageVersion("QA3D"),"\n",
				"Icon=",		system.file("QA3D/www/QA3D.png", package = "QA3D"),"\n",
				"Exec=",		paste(file.path(R.home("bin"), "R"), "-e", "library(QA3D);QA3D()", sep=" ")
			,sep=""),#paste
			file = paste(file.path(path.expand("~"), "Desktop"), "QA3D.desktop", sep = "/")
		)#cat
		Sys.chmod(paste(file.path(path.expand("~"), "Desktop"), "QA3D.desktop", sep="/"), mode = "0777", use_umask = TRUE)
	}
	if(Sys.info()[['sysname']] != "Linux" && Sys.info()[['sysname']] != "Windows") { #.command for mac
		icon_name <- "QA3D.sh"
		cat(paste(file.path(R.home("bin"), "R"), "-e", "'library(QA3D);QA3D()'", sep=" "), file = paste(file.path(path.expand("~"), "Desktop"), "QA3D.command", sep = "/"))
		Sys.chmod(paste(file.path(path.expand("~"), "Desktop"), "QA3D.sh", sep="/"), mode = "0777", use_umask = TRUE)
	}
})