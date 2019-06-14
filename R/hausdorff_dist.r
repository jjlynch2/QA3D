#' hausdorff distance function
#' 
#' @param first_configuration The first two-dimensional configuration
#' @param second_configuration The second two-dimensional configuration
#' @param test Specifies the distance calculation ("Segmented-Hausdorff", "Hausdorff", "Uni-Hausdorff")
#'
#'
#' @keywords hausdorff_dist
#' @export
#' @examples
#' hausdorff_dist()

hausdorff_dist <- function (first_configuration, second_configuration, test = "Hausdorff") {
	if(test == "Hausdorff") {
		distance_results <- julia_call("Hausdorff", first_configuration, second_configuration)
	}
	return(distance_results)
}