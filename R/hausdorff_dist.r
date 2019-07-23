hausdorff_dist <- function (first_configuration, second_configuration) {
	distance_results <- julia_call("Hausdorff", first_configuration, second_configuration)
	return(distance_results)
}