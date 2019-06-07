#' hausdorff distance function
#' 
#' @param first_configuration The first two-dimensional configuration
#' @param second_configuration The second two-dimensional configuration
#' @param test Specifies the distance calculation ("Segmented-Hausdorff", "Hausdorff", "Uni-Hausdorff")
#' @param dist Specifies distance type either maximum, average, or dilated
#'
#'
#' @keywords hausdorff_dist
#' @export
#' @examples
#' hausdorff_dist()

hausdorff_dist <- function (first_configuration, second_configuration, test = "Hausdorff", dist = "average") {
	if(test == "Hausdorff") {
		if(dist == "average"){
			distance_results <- julia_call("Average_Hausdorff", first_configuration, second_configuration)
		}
		if(dist == "maximum"){
			distance_results <- julia_call("Max_Hausdorff", first_configuration, second_configuration)
		}
	}
	return(distance_results)
}