reflection_icp <- function(x,y,iterations,subsample=NULL,threads=1, break_early = NULL, k = 1) {
	y <- as.matrix(y)
	x <- as.matrix(x)
	d12 <- 999999
	d1r <- NULL
	A <- x
	for(j in 1:k) {
		if (j == 1) {x <- cbind( A[,1], A[,2],A[,3])}
		else if (j == 2) {x <- cbind( A[,1]*-1, A[,2]*-1,A[,3]*-1)}
		else if (j == 3) {x <- cbind( A[,1], A[,2]*-1,A[,3]*-1)}
		else if (j == 4) {x <- cbind( A[,1]*-1, A[,2],A[,3]*-1)}
		else if (j == 5) {x <- cbind( A[,1]*-1, A[,2]*-1,A[,3])}
		else if (j == 6) {x <- cbind( A[,1], A[,2],A[,3]*-1)}
		else if (j == 7) {x <- cbind( A[,1], A[,2]*-1,A[,3])}
		else if(j == 8) {x <- cbind( A[,1]*-1, A[,2],A[,3])}
		if(!is.null(subsample)) {
			s <- round(nrow(x) * subsample, digits = 0)
			subs <- Morpho::fastKmeans(x,k=s,iter.max = 100,threads=threads)$selected
			xtmp <- x[subs,]
		} else {
			xtmp <- x
		}
		yKD <- Rvcg::vcgCreateKDtree(y)
		for(i in 1:iterations) {
			clost <- Rvcg::vcgSearchKDtree(yKD,xtmp,1,threads=threads)
			good <- which(clost$distance < 1e+15)
			trafo <- Morpho::computeTransform(y[clost$index[good],],xtmp[good,],type="rigid")
			xtmp <- Morpho::applyTransform(xtmp[,],trafo)
		}
		if(!is.null(subsample)) {
			d1t <- hausdorff_dist(xtmp, y[clost$index[good],], threads)
		} else {
			d1t <- hausdorff_dist(xtmp, y, threads)
		}
		print(paste("Distances: ", d1t[1], d1t[2], d1t[3], sep = " "))
		incProgress(amount = 1, message = paste("Distances: ", d1t[1], d1t[2], d1t[3], sep = " "), detail = '')
		if(d1t[[1]] < d12) {
			d12 <- d1t[[1]]
			d1r <- d1t
			if (!is.null(subsample)) {
				fintrafo <- Morpho::computeTransform(xtmp[,],x[subs,],type = "rigid")
				x_result <- Morpho::applyTransform(x,fintrafo)
			} else {
				x_result <- xtmp
			}
			if(!is.null(break_early)) {
				if(d1t[[2]] < break_early) {
					break
				}
			}
		}
	}
	if(!is.null(subsample)) {
		d1r <- hausdorff_dist(x_result, y, threads)
	}
	return(list(x_result, d1r))
}
