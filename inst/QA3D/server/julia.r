#load Julia environment
showModal(modalDialog(title = "Loading Analytical environment...", easyClose = FALSE, footer = NULL))
JV <- JuliaSetup(add_cores = detectCores()-1, libraries = TRUE, source = TRUE)
removeModal()