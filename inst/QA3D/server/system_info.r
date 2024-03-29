autoMem <- reactiveTimer(10000) #10 seconds
output$memUsage <- renderUI({
	autoMem()
	temp <- gc()
	HTML(paste("<strong><font color=\"#FFFFFF\">Memory Usage: ", temp[1,2] + temp[2,2], " MB</strong></font>"))
})


system_name <- Sys.info()[['sysname']]
system_mem <- NULL
if(system_name == "Linux") {
	system_name <- paste(icon = icon("linux", lib="font-awesome"), system_name, sep = " ")
	system_mem <- gsub('MemTotal:       ', '', system(paste0("cat /proc/meminfo | grep MemTotal"), intern = TRUE))
}
if(system_name == "Windows") {
	system_name <- paste(icon = icon("windows", lib="font-awesome"), system_name, sep = " ")
	tempgsub <- gsub("TotalVisibleMemorySize=", '', system('wmic OS get TotalVisibleMemorySize /Value', intern = TRUE)[3])
	tempgsub <- gsub("\r", '', tempgsub)
	system_mem <- paste(tempgsub, " kB", sep="")
}
if(system_name == "Darwin") {
	system_name <- paste(icon = icon("apple", lib="font-awesome"), system_name, sep = " ")
	system_name <- "not available"
}

output$system_info <- renderUI({
	HTML(paste( 
	"<strong>Platform:  </strong>", system_name, "<p></p>",
	"<strong>Cores: </strong>", QA3D:::detectCores(), "<p></p>",
	"<strong>Memory: </strong>", system_mem
	,sep=""))
})
