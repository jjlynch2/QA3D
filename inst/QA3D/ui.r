#' Shiny ui.r file
#' 
#' This is the ui.r file for the interface that utilizes all previous functions. 
#' runApp("3DQA")

options(warn = -1)
library(shiny)
library(rgl)

shinyUI(
	navbarPage(theme = "css/flatly.min.css", windowTitle = "QA3D",
		tags$script(HTML(paste("var header = $('.navbar > .container-fluid');header.append('<div style=\"float:left\"><img src=\"fav.png\" alt=\"alt\" style=\"float:right; width:40px;padding-top:5px;padding-right:5px;\"></div><div style=\"float:right; padding-top:15px\">", 
		uiOutput("memUsage"), "</div>');console.log(header)", sep=""))),
		tabPanel("About", icon = icon("question", lib="font-awesome"),
			fluidRow(
				sidebarPanel(
					uiOutput("version_numbers")
				,width = 3),
				sidebarPanel(
					uiOutput("update_gh")
				,width = 3),
				sidebarPanel(
					uiOutput("system_info"),
					actionButton('Create_Desktop_Icon', 'Desktop shortcut', icon = icon("gears"))
				,width=3),
				sidebarPanel(
					uiOutput("URL")
				,width=3)
			),
			fluidRow(br()),
			fluidRow(
				sidebarPanel(
					uiOutput("changes")
				,width = 6),
				sidebarPanel(
					uiOutput("about_refs")
				,width = 6)
			),
			tags$style(type = "text/css", "#Create_Desktop_Icon { width:100%; font-size:85%; background-color:#126a8f }")
		),
		tabPanel("QA3D", icon = icon("cloud-download", lib="glyphicon"),
			titlePanel(""),
			sidebarLayout(
				sidebarPanel(
					uiOutput('resettableInput3D'),
					fluidRow(
						column(12,
							sliderInput(inputId = "ncorespc", label = "Parallel Cores", min=1, max=detectCores(), value=detectCores()-1, step =1),
							sliderInput(inputId = "iterations", label = "Iterations", min=1, max=1000, value=100, step =1),
							checkboxInput("subsample", "ICP Subsample", value = FALSE),
							conditionalPanel(condition = "input.subsample",
								sliderInput(inputId = "vara2", label = "% of Coordinates", min=0.01, max=1, value=0.10, step = 0.01)
							),
							checkboxInput("pcalign", "PC Align", value = TRUE),
							checkboxInput("kmeans", "K-means Simplify", value = TRUE),
							conditionalPanel(condition = "input.kmeans",
								sliderInput(inputId = "vara", label = "% of Coordinates", min=0.01, max=1, value=0.10, step = 0.01)
							),
							radioButtons("Procedure", "Procedure", choices = c("First", "All"), selected = "All"),
							uiOutput('mspec3D'),
							actionButton("Process", "process", icon = icon("cog"))
						)
					),
					fluidRow(br()),
					fluidRow(
						column(6,
							actionButton("clearFile3D", " clear   ", icon = icon("window-close"))
						),
						column(6,
							downloadButton("savedata", " save    ")
						)
					),
					width=2,
					tags$style(type = "text/css", "#clearFile3D { width:100%; font-size:85%; background-color:#126a8f }"),
					tags$style(type = "text/css", "#Process { width:100%; font-size:85%; background-color:#126a8f }"),
					tags$style(type = "text/css", "#savedata { width:100%; font-size:85%; background-color:#126a8f }")
				),
				mainPanel(
					tabsetPanel(id="tabSelected",
						tabPanel("Results",
							htmlOutput('contents')
						),
						tabPanel("Render",
							rglwidgetOutput('webgl3Dalign', width = "800px", height = "800px")
						)
					)
				)
			)
		)
	)
)
