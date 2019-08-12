filelist3 <- reactiveValues(list=list())

observeEvent(input$clearFile3D, {
	fileInput('aligndata', 'Import Scans', accept=c("xyz"), multiple = TRUE)
	delete.tmp.data()
	output$mspec3D <- renderUI({
		selectInput(inputId = "mspec3D", label = "Choose comparison", choices = "")
	})
})

output$resettableInput3D <- renderUI({
	input$clearFile3D
	input$uploadFormat
	fileInput('aligndata', 'Import Scans', accept=c("xyz"), multiple = TRUE)
})

output$contents1 <- renderUI({
	HTML(paste("<br>"))
})
output$contents2 <- renderUI({
	HTML(paste("<br>"))
})

observeEvent(input$aligndata$datapath, {
	showModal(modalDialog(title = "Import has started...Window will update when finished.", easyClose = FALSE, footer = NULL))
	file.copy(input$aligndata$datapath, input$aligndata$name)
	filelist3$list <- input.3d(input$aligndata$name)
	output$Choose <- renderUI({
		selectInput(inputId = "Choose", label = "Choose Target", choices = names(filelist3$list))
	})
	removeModal()
})

observeEvent(input$mspec3D, {
print(input$mspec3D)
	if(input$mspec3D != "") {
		tt <- import.tmp.data(input$mspec3D)
		tt1 <- tt[[1]]
		tt2 <- tt[[2]]

		if(is.null(nrow(d1[[12]]))){
			tt1p <- d1[[12]]
			tt2p <- d1[[13]]
		} else {
			tt1p <- d1[[12]][which(d1[[1]] == input$mspec3D),]
			tt2p <- d1[[13]][which(d1[[1]] == input$mspec3D),]
		}
		ttp <- rbind(tt1p, tt2p)

		output$webgl3Dalign <- renderRglwidget ({
			try(rgl.close())
			points3d(tt1, size=3, col="dimgray", box=FALSE)
			points3d(tt2, size=3, col="dodgerblue", box=FALSE)
			points3d(ttp, size=10, col="red", box=FALSE)
			lines3d(ttp, col=2, lwd=5)
			axes3d(c('x++', 'y++', 'z++'))
			rglwidget()
		})
	}
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

	if(input$breake) {
		breakk <- input$breakearly
	} else {
		breakk <- NULL
	}

	if(input$Procedure == "Custom") {
		surface <- nsurface(input$x, input$y, input$z, input$d)
	} else {
		custom_surface = NULL
	}

	d1 <<- compare.3d(choose = input$Choose, data = data, custom_surface = surface, procedure = input$Procedure, iteration = input$iterations, cores = input$ncorespc, subsample = subsample, pca = input$pcalign, break_early = breakk)

	output$mspec3D <- renderUI({
		selectInput(inputId = "mspec3D", label = "Choose comparison", choices = c(d1[[1]]))
	})

	report_pw <- data.frame(Comparison = d1[[1]], Average_Hausdorff = d1[[2]], Maximum_Hausdorff = d1[[4]], Standard_Deviation = d1[[11]])
	report_gr <- data.frame(Average_Hausdorff = d1[[3]], Maximum_Hausdorff = d1[[5]], Standard_Deviation = d1[[10]], TEMah = d1[[6]], TEMmh = d1[[7]], RMSEah = d1[[8]], RMSEmh = d1[[9]])
	if(is.null(subsample)){
		subsample <- FALSE
	} else if(!is.null(subsample)) {
		subsample <- TRUE
	}
	params_list <- list(choose = input$Choose, attributes = input$attributes, x = input$x, y = input$y, z = input$z, d = input$d, breake = input$breake, breakk = breakk, scannerid = input$scannerid, analyst = input$analyst, date = Sys.time(), iterations = input$iterations, subsample = subsample, pcalign = input$pcalign, kmeans = input$kmeans, procedure = input$Procedure, vara = input$vara, vara2 = input$vara2, report_pw = report_pw, report_gr = report_gr)

	output$savedata <- downloadHandler(
		filename = "report.pdf",
		content = function(file) {
			pdf_report <- system.file("extdata", "report_pdf.Rmd", package = "QA3D")
			file.copy(pdf_report, "report.Rmd", overwrite = TRUE)
			rmarkdown::render("report.Rmd", output_file = file, params = params_list)
		}
	)

	output$table1 <- DT::renderDataTable({
		DT::datatable(report_pw, options = list(pageLength = 50, dom = 't'), rownames = FALSE)
	})
	output$table2 <- DT::renderDataTable({
		DT::datatable(report_gr, options = list(dom = 't'), rownames = FALSE)
	})
	output$contents1 <- renderUI({
		HTML("<h3>Grand Results</h1>")
	})
	output$contents2 <- renderUI({
		HTML("<h3>Pairwise Results</h1>")
	})
	removeModal()
	gc()
})