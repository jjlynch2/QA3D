#' This function starts the QA3D app with shiny
#' 
#' @keywords QA3D
#' @export
#' @examples
#' OsteoSort()



QA3D <- function()
{
	library(shiny)
	runApp(system.file("QA3D", package = "QA3D"), launch.browser = TRUE)
}