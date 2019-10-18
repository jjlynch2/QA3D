options(warn = -1)
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
					actionButton('Create_Desktop_Icon', 'Desktop Shortcut', icon = icon("gears"))
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
			tags$style(type = "text/css", "#Create_Desktop_Icon { width:100%; font-size:85%; background-color:#126a8f }"),
			tags$style(".well {border-width:1px; border-color:#126a8f;}")
		),
		tabPanel("QA3D", icon = icon("cloud-download", lib="glyphicon"),
			titlePanel(""),
			sidebarLayout(
				sidebarPanel(
					uiOutput('resettableInput3D'),
					conditionalPanel(condition = "input.Procedure == 'Inter-observer-multiple' || input.Procedure == 'Inter-observer-single' || input.Procedure == 'Intra-observer-multiple'",
						uiOutput('resettableInput3D_inter')
					),
					fluidRow(
						column(12,
							sliderInput(inputId = "ncorespc", label = "Parallel Cores", min=1, max=detectCores(), value=detectCores()-1, step =1),
							sliderInput(inputId = "iterations", label = "Iterations", min=1, max=1000, value=250, step =1),
							checkboxInput("subsample", "ICP Subsample", value = TRUE),
							conditionalPanel(condition = "input.subsample",
								sliderInput(inputId = "vara2", label = "% of Coordinates", min=0.01, max=1, value=0.01, step = 0.01)
							),
							checkboxInput("pcalign", "PC Align", value = TRUE),
							conditionalPanel(condition = "input.pcalign", 
								checkboxInput("breake", "Break Early", value = TRUE),
								conditionalPanel(condition = "input.breake", 
									sliderInput(inputId = "breakearly", label = "Break Point", min=0.01, max=20, value=1, step =0.01)
								)
							),
							checkboxInput("kmeans", "K-means Simplify", value = FALSE),
							conditionalPanel(condition = "input.kmeans",
								sliderInput(inputId = "vara", label = "% of Coordinates", min=0.01, max=1, value=0.10, step = 0.01)
							),
							checkboxInput("heatmap", "Generate Heatmaps", value = FALSE),
							radioButtons("Procedure", "Procedure", choices = c("Choose", "Custom", "Intra-observer-single", "Intra-observer-multiple", "Inter-observer-single", "Inter-observer-multiple"), selected = "Intra-observer-single"),
							conditionalPanel(condition = "input.Procedure == 'Custom'",
								numericInput(inputId = "x", label = "X", value = "10", min=0,max=999,step=0.01),
								numericInput(inputId = "y", label = "Y", value = "10", min=0,max=999,step=0.01),
								numericInput(inputId = "z", label = "Z", value = "10", min=0,max=999,step=0.01),
								numericInput(inputId = "d", label = "Density", value = "0.1", min=0,max=999,step=0.01)
							),
							conditionalPanel(condition = "input.Procedure == 'Choose'",
								uiOutput('Choose')
							),
							textInput(inputId = 'attributes', label = 'Attributes', value = ''),
							textInput(inputId = 'scannerid', label = 'Scanner ID', value = ''),
							textInput(inputId = 'analyst', label = 'Analyst', value = ''),
							uiOutput('mspec3D'),
							actionButton("Process", "Process", icon = icon("cog"))
						)
					),
					fluidRow(br()),
					fluidRow(
						column(6,
							actionButton("clearFile3D", " Clear   ", icon = icon("window-close"))
						),
						column(6,
							downloadButton("savedata", " Report    ")
						)
					),
					width=3,
					tags$style(type = "text/css", "#clearFile3D { width:100%; font-size:85%; background-color:#126a8f }"),
					tags$style(type = "text/css", "#Process { width:100%; font-size:85%; background-color:#126a8f }"),
					tags$style(type = "text/css", "#savedata { width:100%; font-size:85%; background-color:#126a8f }")
				),
				mainPanel(
					tabsetPanel(id="tabSelected",
						tabPanel("Results",
							uiOutput('contents1'),
							DT::dataTableOutput('table2'),
							uiOutput('contents2'),
							DT::dataTableOutput('table1')
						),
						tabPanel("Pairwise Overlap",
 							 plotlyOutput("plot3")
						),
						tabPanel("Pairwise Heatmap",
 							 plotlyOutput("plot")
						),
						tabPanel("Mean Heatmap",
 							 plotlyOutput("plot2")
						)
					)
				)
			)
		),
		tabPanel(
			tags$button(type = "button", id = "exitqa3d", class = "increment btn btn-default", onclick = "window.close();", HTML("<i class ='fa fa-window-close'></i>"), "Exit", style = "background-color: #2c3e50 ; border: none ;padding: 0px 0px; margin-top: -2px")
		)
	)
)
