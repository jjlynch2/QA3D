tem <- function(M) {
	sqrt(sum(M^2) / (2*length(M)))
}

rmse <- function(M) {
	sqrt(sum(M^2) / (length(M)))
}
