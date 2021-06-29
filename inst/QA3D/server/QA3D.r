filelist3 <- reactiveValues(list=list())
filelist4 <- reactiveValues(list=list())
ABm <<- NULL
observeEvent(input$clearFile3D, {
	fileInput('aligndata', 'Import Scans', accept=c("xyz"), multiple = TRUE)
	delete.tmp.data()
	unlink(input$aligndata$datapath)
	output$mspec3D <- renderUI({
		selectInput(inputId = "mspec3D", label = "Choose comparison", choices = "")
	})
})

output$resettableInput3D <- renderUI({
	input$clearFile3D
	input$uploadFormat
	fileInput('aligndata', 'Import Scans', accept=c("xyz"), multiple = TRUE)
})

output$resettableInput3D_inter <- renderUI({
	input$clearFile3D
	input$uploadFormat
	fileInput('aligndatainter', 'Import Scans', accept=c("xyz"), multiple = TRUE)
})


output$contents1 <- renderUI({
	HTML(paste("<br>"))
})
output$contents2 <- renderUI({
	HTML(paste("<br>"))
})

observeEvent(input$aligndata$datapath, {
	showModal(modalDialog(title = "Import has started...Window will update when finished.", easyClose = FALSE, footer = NULL))
	withProgress(message = 'Importing first data set', detail = '', value = 0, min=0, max=length(input$aligndata$datapath), {
		filelist3$list <- input.3d(input$aligndata$datapath, input$aligndata$name)
	})
	output$Choose <- renderUI({
		selectInput(inputId = "Choose", label = "Choose Target", choices = names(filelist3$list))
	})
	removeModal()
})

observeEvent(input$aligndatainter$datapath, {
	showModal(modalDialog(title = "Import has started...Window will update when finished.", easyClose = FALSE, footer = NULL))
	withProgress(message = 'Importing second data set', detail = '', value = 0, min=0, max=length(input$aligndatainter$datapath), {
		filelist4$list <- input.3d(input$aligndatainter$datapath, input$aligndatainter$name)
		removeModal()
	})
})


observeEvent(input$mspec3D, {
	if(input$mspec3D != "") {
		tt <- import.tmp.data(input$mspec3D)
		tt1 <- tt[[1]][c(1:3)]
		tt2 <- tt[[2]][c(1:3)]

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
			points3d(tt1, size=3, col=input$colo1, box=FALSE)
			points3d(tt2, size=3, col=input$colo2, box=FALSE)
			points3d(ttp, size=10, col="red", box=FALSE)
			lines3d(ttp, col=2, lwd=5)
			rglwidget()
		})
		observeEvent(input$PCMP, {
			if(input$heatmap) {
				output$webgl3Dalign_pwm <- renderRglwidget ({
					try(rgl.close())
					names(ABm) <- d1[[1]]					
					if(input$PCMP == "Mesh") {
						d <- as.matrix(ABm[[input$mspec3D]][,1:3])
						if(input$mspec3D != "") {
							showModal(modalDialog(title = "Reconstructing Surface...", easyClose = FALSE, footer = NULL))
							ABm_p <<- Rvcg::vcgBallPivoting(d)
							removeModal()
						}
						plot3d(ABm_p, col=color.gradient(ABm[[input$mspec3D]][,4], colors=c(input$col1, input$col2), mini = input$mini, maxi = input$maxi, steps = input$steps), axes=FALSE, xlab="", ylab="", zlab="", aspect = "iso")
					}
					if(input$PCMP == "Point Cloud") {
						points3d(ABm[[input$mspec3D]][,1:3], size=3, col=color.gradient(ABm[[input$mspec3D]][,4], colors=c(input$col1, input$col2), mini = input$mini, maxi = input$maxi, steps = input$steps), box=FALSE)
					}
					rglwidget()
				})
				output$testplot2 <- renderPlot({
					names(ABm) <- d1[[1]]
					plot(x = rep(1, input$steps), y = seq(1, input$steps, length.out=input$steps), pch = 15, cex = 15, col = color.gradient(seq(input$mini, input$maxi, length.out=input$steps), colors=c(input$col1, input$col2), mini = input$mini, maxi = input$maxi, steps = input$steps), ann = F, axes = F, xlim = c(1,2))
					axis(side = 2, at = seq(1, input$steps, length.out=input$bsteps), labels = round(seq(from = input$mini, to = input$maxi, length.out=input$bsteps), digits = 2), line = 0.15)
				})
				output$pwdown <- downloadHandler (
					filename = function(){input$mspec3D},
					content = function(fname) {
						names(ABm) <- d1[[1]]
						tempg <- ABm[[input$mspec3D]][,1:4]
						colnames(tempg) <- c("x","y","z","error")
						write.csv(tempg, fname, row.names=FALSE, col.names=TRUE)
					}

				)
			}
		})
	}
})

observeEvent(input$PCMG, {
	if(length(ABm) > 1) {
		output$webgl3Dalign_m <- renderRglwidget ({
			try(rgl.close())
			if(input$PCMG == "Mesh") {
				plot3d(ABgm_p, col=color.gradient(ABgm[,4], colors=c(input$colm1, input$colm2), mini = input$gmini, maxi = input$gmaxi, steps = input$gsteps), axes=FALSE, xlab="", ylab="", zlab="", aspect = "iso")
			}
			if(input$PCMG == "Point Cloud") {
				points3d(ABgm[,1:3], size=3, col=color.gradient(ABgm[,4], colors=c(input$colm1, input$colm2), mini = input$gmini, maxi = input$gmaxi, steps = input$gsteps), box=FALSE)
			}
			rglwidget()
		})
		output$testplot <- renderPlot({
			plot(x = rep(1, input$gsteps), y = seq(1, input$gsteps, length.out=input$gsteps), pch = 15, cex = 15, col = color.gradient(seq(input$gmini, input$gmaxi, length.out=input$gsteps), colors=c(input$colm1, input$colm2), mini = input$gmini, maxi = input$gmaxi, steps = input$gsteps), ann = F, axes = F, xlim = c(1,2))
			axis(side = 2, at = seq(1, input$gsteps, length.out=input$gbsteps), labels = round(seq(from = input$gmini, to = input$gmaxi, length.out=input$gbsteps), digits = 2), line = 0.15)
		})
	}
})

observeEvent(input$Process, {
	showModal(modalDialog(title = "Calculation has started...Window will update when finished.", easyClose = FALSE, footer = NULL))
	withProgress(message = 'Calculation has started', detail = '', value = 1, min=0, max=9, {
		data <- filelist3$list
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
			setProgress(value = 2, message = "Generating custom surface", detail = '')
			surface <- nsurface(input$x, input$y, input$z, input$d)
		} else {
			custom_surface = NULL
		}
		data2 <- NULL
		if(input$Procedure == "Inter-observer-single" || input$Procedure == "Inter-observer-multiple" || input$Procedure == "Intra-observer-multiple") {
			data2 <- filelist4$list
			if(length(filelist4$list) != length(filelist3$list)) {
				return(NULL)
			}
		}
		d1 <<- compare.3d(choose = input$Choose, data = data, data2 = data2, custom_surface = surface, procedure = input$Procedure, iteration = input$iterations, cores = input$ncorespc, subsample = subsample, pca = input$pcalign, break_early = breakk)

		output$mspec3D <- renderUI({
			selectInput(inputId = "mspec3D", label = "Choose comparison", choices = c(d1[[1]]))
		})

		report_pw <- data.frame(Comparison = d1[[1]], Average = d1[[2]], Maximum = d1[[4]], Standard_Deviation = d1[[11]])
		report_gr <- data.frame(Average = d1[[3]], Maximum = d1[[5]], Standard_Deviation = d1[[10]], TEMah = d1[[6]], TEMmh = d1[[7]], RMSEah = d1[[8]], RMSEmh = d1[[9]])
		if(is.null(subsample)){
			subsample <- FALSE
		} else if(!is.null(subsample)) {
			subsample <- TRUE
		}
		ttime <- d1[[14]]
		params_list <- list(choose = input$Choose, attributes = input$attributes, x = input$x, y = input$y, z = input$z, d = input$d, breake = input$breake, breakk = breakk, scannerid = input$scannerid, analyst = input$analyst, date = Sys.time(), iterations = input$iterations, subsample = subsample, pcalign = input$pcalign, procedure = input$Procedure, vara = input$vara, vara2 = input$vara2, report_pw = report_pw, report_gr = report_gr, time = ttime, comparisons = nrow(report_pw))

		output$savedata <- downloadHandler(
			filename = "report.pdf",
			content = function(file) {
				pdf_report <- system.file("extdata", "report_pdf.Rmd", package = "QA3D")
				file.copy(pdf_report, "report.Rmd", overwrite = TRUE)
				rmarkdown::render("report.Rmd", output_file = file, params = params_list)
			}
		)

		if(input$heatmap) {
			setProgress(value = 6, message = "Calculating pairwise heatmaps", detail = '')
			ABm <<- list()
			withProgress(message = '', detail = '', value = 1, min=0, max=length(d1[[1]]), {
				for(x in 1:length(d1[[1]])) {
					setProgress(value = x, message = d1[[1]][x], detail = '')
					tt <- import.tmp.data(d1[[1]][x])
					tt1 <- tt[[1]][c(1:4)]
					tt2 <- tt[[2]][c(1:4)]
					ABm[[x]] <<- KDtreePWmean(tt[[1]], tt[[2]], threads = input$ncorespc)
				}
			})
			if(length(ABm) > 1) {
				if(input$Procedure == "Custom") {
					surface <- nsurface(input$x, input$y, input$z, input$d)
				} else {
					surface <- NULL
				}
				setProgress(value = 7, message = "Calculating mean heatmap", detail = '')
				if(subsample) {subsample = input$vara2} else {subsample = 0.01}
				ABgm <<- KDtree_Gmean(ABm, iterations = input$iterations, threads = input$ncorespc, subsample = subsample, procedure = surface)
				ABgm_p <<- Rvcg::vcgBallPivoting(as.matrix(ABgm[,1:3]))
				output$meandown <- downloadHandler (
					filename = function(){"mean.csv"},
					content = function(fname) {
						tempg <- ABgm[,c(1:4)]
						colnames(tempg) <- c("x","y","z","error")
						write.csv(tempg, fname, row.names=FALSE, col.names=TRUE)
					}

				)
			}
		}

		output$table1 <- DT::renderDataTable({
			DT::datatable(report_pw, options = list(lengthMenu = c(5,10,15,20,25,30), pageLength = 10), rownames = FALSE)
		})
		output$table2 <- DT::renderDataTable({
			DT::datatable(report_gr, options = list(dom = 't'), rownames = FALSE)
		})
		output$contents1 <- renderUI({
		HTML(paste("<strong>Comparisons: ","<font color=\"#00688B\">", nrow(report_pw),"</font>","<br>Completed in: ", "<font color=\"#00688B\">", ttime, " minutes</font></strong><br><br>","<h3>Grand Results</h1>", sep=""))
		})
		output$contents2 <- renderUI({
			HTML("<h3>Pairwise Results</h1>")
		})
		setProgress(value = 8, message = "Running garbage collection", detail = '')
		gc()
		setProgress(value = 9, message = "Analysis completed", detail = '')
		removeModal()
	})
})
