observeEvent(input$clearFile3Da, {
	fileInput('aligndata', 'Upload data set', accept=c("xyz"), multiple = TRUE)
})

output$contents <- renderUI({
	HTML(paste(""))
})
