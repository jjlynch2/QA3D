hausdorff_dist <- function (first_configuration, second_configuration, test = "Hausdorff") {
	if(test == "Hausdorff") {
		distance_results <- julia_call("Hausdorff", first_configuration, second_configuration)
	}
	return(distance_results)
}