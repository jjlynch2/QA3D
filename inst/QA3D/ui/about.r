about <- tabPanel("About", icon = icon("question", lib="font-awesome"),
	tags$style(HTML("
		.box.box-solid.box-primary>.box-header {
			  color:#ffffff;
			  background:#2c3e50
		}

		.box.box-solid.box-primary{
			border-bottom-color:#2c3e50;
			border-left-color:#2c3e50;
			border-right-color:#2c3e50;
			border-top-color:#2c3e50;
			background:#f5f5f5;
		}

		.box.box-primary>.box-header {
			color:#000000;
			background:#f5f5f5
		}

		.box.box-primary{
			border-bottom-color:#2c3e50;
			border-left-color:#2c3e50;
			border-right-color:#2c3e50;
			border-top-color:#2c3e50;
			background:#f5f5f5;
		}
	")),
	fluidRow(
		column(3,
			box(
				title = "Version Details",
				solidHeader=TRUE,
				uiOutput("version_numbers"),
				width=12,
				height="200",
				status="primary"
			)
		),
		column(3,
			box(
				title = "Updates",
				solidHeader=TRUE,
				uiOutput("update_gh"),
				width=12,
				height="200",
				status="primary"
			)
		),
		column(3,
			box(
				title = "System Details",
				solidHeader=TRUE,
				uiOutput("system_info"),
				actionButton('Create_Desktop_Icon', 'Desktop Shortcut', icon = icon("gears")),
				width=12,
				height="200",
				status="primary"
			)
		),
		column(3,
			box(
				title = "URLs",
				solidHeader=TRUE,
				uiOutput("URL"),
				width=12,
				height="200",
				status="primary"
			)
		)
	),
	fluidRow(br()),
	fluidRow(
		column(6,
			box(
				title = "Version Changes",
				solidHeader=TRUE,
				uiOutput("changes"),
				width=12,
				#height="365",
				status="primary"
			)
		),
		column(6,
			box(
				title = "About",
				solidHeader=TRUE,
				uiOutput("about_refs"),
				width=12,
				#height="300",
				status="primary"
			)
		)
	),
	tags$style(type = "text/css", "#Create_Desktop_Icon { width:100%; font-size:85%; background-color:#126a8f }"),
	tags$style(".well {border-width:1px; border-color:#126a8f;}")
)
