filelist3 <- reactiveValues(list=list())

observeEvent(input$clearFile3D, {
	fileInput('aligndata', 'Upload data set', accept=c("xyz"), multiple = TRUE)
})

output$resettableInput3D <- renderUI({
	input$clearFile3D
	input$uploadFormat
	fileInput('aligndata', 'Upload data set', accept=c("xyz"), multiple = TRUE)
})

output$contents <- renderUI({
	HTML(paste("<br>"))
})

observeEvent(input$aligndata$datapath, {
	showModal(modalDialog(title = "Import has started...Window will update when finished.", easyClose = FALSE, footer = NULL))
	file.copy(input$aligndata$datapath, input$aligndata$name)
	filelist3$list <- input.3d(input$aligndata$name) #imports 3D xyzrbg data
	removeModal()
})

observeEvent(input$mspec3D, {
		tt1 <- d1[[2]][which(d1[[1]] == input$mspec3D)][[1]]
		tt2 <- d1[[3]][which(d1[[1]] == input$mspec3D)][[1]]
		output$webgl3Dalign <- renderRglwidget ({
			try(rgl.close())
			points3d(tt1, size=3, col="dimgray", box=FALSE)
			points3d(tt2, size=3, col="dodgerblue", box=FALSE)
			axes3d(c('x++', 'y++', 'z++'))
			rglwidget()
		})
})


observeEvent(input$Process, {
	showModal(modalDialog(title = "Calculation has started...Window will update when finished.", easyClose = FALSE, footer = NULL))
	withProgress(message = 'Calculation has started', detail = '', value = 0, {       
		for (i in 1:10) {
			incProgress(1/10)
			Sys.sleep(0.05)
		}
	})

	if(input$ncorespc != julia_call("nprocs")) {
		print("Setting up Julia workers...")
		JuliaSetup(add_cores = input$ncorespc, source = TRUE, recall_libraries = TRUE)
		print("Finished.")
	}
	data <- filelist3$list
	if(input$kmeans) {
		ll <- length(filelist3$list)
		for (i in 1:ll) {
			data[[i]] <- kmeans.3d(filelist3$list[[i]], cluster = input$vara)
		}
	}
	if(input$subsample) {
		subsample <- input$vara2
	} else {
		subsample <- NULL
	}
	d1 <<- compare.3d(data = data, sessiontempdir = sessiontemp, procedure = input$Procedure, iteration = input$iterations, cores = input$ncorespc, subsample = subsample, pca = input$pcalign)

	output$mspec3D <- renderUI({
		selectInput(inputId = "mspec3D", label = "Choose comparison", choices = c(d1[[1]]))
	})

	report_pw <- data.frame(Comparison = d1[[1]], Average_Hausdorff = d1[[4]], Maximum_Hausdorff = d1[[6]])
	report_gr <- data.frame(Average_Hausdorff = d1[[5]], Maximum_Hausdorff = d1[[7]], TEMah = d1[[8]], TEMmh = d1[[9]], RMSEah = d1[[10]], RMSEmh = d1[[11]])
	if(is.null(subsample)){subsample <- FALSE}
	params_list <- list(date = Sys.time(), iterations = input$iterations, subsample = subsample, pcalign = input$pcalign, kmeans = input$kmeans, procedure = input$Procedure, vara = input$vara, vara2 = input$vara2, report_pw = report_pw, report_gr = report_gr)

	output$savedata <- downloadHandler(
		filename = "report.pdf",
		content = function(file) {
			pdf_report <- system.file("extdata", "report_pdf.Rmd", package = "QA3D")
			file.copy(pdf_report, "report.Rmd", overwrite = TRUE)
			rmarkdown::render("report.Rmd", output_file = file, params = params_list)
		}
	)

	output$table1 <- DT::renderDataTable({
		DT::datatable(report_pw, options = list(dom = 't'), rownames = FALSE)
	})
	output$table2 <- DT::renderDataTable({
		DT::datatable(report_gr, options = list(dom = 't'), rownames = FALSE)
	})

	removeModal()
	setwd(sessiontemp)
	gc() #clean up 
})