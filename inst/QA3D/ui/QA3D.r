QA3D <- tabPanel("QA3D", icon = icon("cloud-download", lib="glyphicon"),
	titlePanel(""),
	sidebarLayout(
		sidebarPanel(
			uiOutput('resettableInput3D'),
			conditionalPanel(condition = "input.Procedure == 'Inter-observer-multiple' || input.Procedure == 'Inter-observer-single' || input.Procedure == 'Intra-observer-multiple'",
				uiOutput('resettableInput3D_inter')
			),
			fluidRow(
				column(12,
					sliderInput(inputId = "ncorespc", label = "Parallel Threads", min=1, max=detectCores(), value=detectCores()-1, step =1),
					numericInput(inputId = "iterations", label = "Iterations", min=1, max=10000, value=20, step =1),
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
					uiOutput('mspec3D')
				)
			),
			fluidRow(
				column(12,
					actionButton("Process", "Process", icon = icon("cog"))
				)
			),
			fluidRow(br()),
			fluidRow(
				column(6,
							downloadButton("pwdown", " Pairwise Heatmap Error  ")
				),
				column(6,
							downloadButton("meandown", " Mean Heatmap Error  ")
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
			tags$style(type = "text/css", "#savedata { width:100%; font-size:85%; background-color:#126a8f }"),
			tags$style(type = "text/css", "#meandown { width:100%; font-size:85%; background-color:#126a8f }"),
			tags$style(type = "text/css", "#pwdown { width:100%; font-size:85%; background-color:#126a8f }")
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
					fluidRow(
						column(2,
							colourInput("colo1", "Color 1", "dimgray")
						),
						column(2,
							colourInput("colo2", "Color 2", "dodgerblue")
						)
					),
					fluidRow(
						column(12,
							rglwidgetOutput('webgl3Dalign', width = "1000px", height = "1000px")
						)
					)
				),
				tabPanel("Pairwise Heatmap",
					fluidRow(
						column(2,
							numericInput("mini", label = "Minimum", value = 0)
						),
						column(2,
							numericInput("maxi", label = "Maximum", value = 1)
						),
						column(2,
							numericInput("steps", label = "Error Steps", value = 100)
						),
						column(2,
							numericInput("bsteps", label = "Legend Labels", value = 5)
						)
					),
					fluidRow(
						column(2,
							colourInput("col1", "Color 1", "green")
						),
						column(2,
							colourInput("col2", "Color 2", "red")
						),
						column(2,
							radioButtons("PCMP", "", choices=c("Point Cloud", "Mesh")),
						)
					),
					fluidRow(
						column(2,
							plotOutput('testplot2')
						),
						column(10,
							rglwidgetOutput('webgl3Dalign_pwm', width = "1000px", height = "1000px")
						)
					)
				),
				tabPanel("Mean Heatmap",
					fluidRow(
						column(2,
							numericInput("gmini", label = "Minimum", value = 0)
						),
						column(2,
							numericInput("gmaxi", label = "Maximum", value = 1)
						),
						column(2,
							numericInput("gsteps", label = "Error Steps", value = 100)
						),
						column(2,
							numericInput("gbsteps", label = "Legend Labels", value = 5)
						)
					),
					fluidRow(
						column(2,
							colourInput("colm1", "Color 1", "green")
						),
						column(2,
							colourInput("colm2", "Color 2", "red")
						),
						column(2,
							radioButtons("PCMG", "", choices=c("Point Cloud", "Mesh")),
						)
					),
					fluidRow(
						column(2,
							plotOutput('testplot')
						),
						column(10,
							rglwidgetOutput('webgl3Dalign_m', width = "1000px", height = "1000px")
						)
					)
				)
			)
		)
	)
)
