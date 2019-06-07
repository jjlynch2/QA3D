compare.3d <- function(data = NULL, sessiontempdir = NULL, procedure = "All", pca = TRUE, iteration = 20, cores = 1) {
	print("Pairwise comparisons started")
	options(stringsAsFactors = FALSE)
	data1 <- list()
	data2 <- list()
	cnames1 <- c()
	cnames2 <- c()
	adistances <- 0
	mdistances <- 0
	n = 0
	if(procedure == "ALL") {
		for(i in 1:length(data)) {
			for(x in 1:length(data)) {
				if(i == x) {break}
				k = 1
				A <- data[[i]][,c(1:3)]
				B <- data[[x]][,c(1:3)]
				if(pca) {
					A <- QA3D::pca_align(A)
					B <- QA3D::pca_align(B)
					k = 8
				}
				d1 = 999999
				for(j in 1:k) {
					if (j == 1) {lt1 <- cbind( A[,1], A[,2],A[,3])}
					else if(j == 2) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3])}
					else if (j == 3) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3])}
					else if (j == 4) {lt1 <- cbind( A[,1], A[,2],A[,3]*-1)}
					else if (j == 5) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3])}
					else if (j == 6) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3]*-1)}
					else if (j == 7) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3]*-1)}
					else if (j == 8) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3]*-1)}
					lt <- icpmat(lt1, B, iterations = iteration, type = "rigid", threads = cores)
					d1t <- hausdorff_dist(lt, B, test = "Hausdorff", dist = "average")
					if (d1 < d1t) {
						d1 <- d1t
						data1[[n]] <- lt1
						data2[[n]] <- B
						adistances <- rbind(adistances, d1t)
					}
				}
				cnames1 <- c(names(data)[i])
				cnames2 <- c(names(data)[x])
				mdistances <- rbind(mdistances, hausdorff_dist(data1[[n]], data2[[n]], test = "Hausdorff", dist="maximum"))
				n <- n + 1
			}
		}
	}
	if(procedure == "1st") {
		for(i in 1:length(data)) {
			k = 1
			B <- data[[1]][,c(1:3)]
			A <- data[[i]][,c(1:3)]
			if(pca) {
				A <- QA3D::pca_align(A)
				B <- QA3D::pca_align(B)
				k = 8
			}
			d1 = 999999
			for(j in 1:k) {
				if (j == 1) {lt1 <- cbind( A[,1], A[,2],A[,3])}
				else if(j == 2) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3])}
				else if (j == 3) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3])}
				else if (j == 4) {lt1 <- cbind( A[,1], A[,2],A[,3]*-1)}
				else if (j == 5) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3])}
				else if (j == 6) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3]*-1)}
				else if (j == 7) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3]*-1)}
				else if (j == 8) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3]*-1)}
				lt <- icpmat(lt1, B, iterations = iteration, type = "rigid", threads = cores)
				d1t <- hausdorff_dist(lt, B, test = "Hausdorff", dist = "average")
				if (d1 < d1t) {
					d1 <- d1t
					data1[[n]] <- lt1
					data2[[n]] <- B
					adistances <- rbind(adistances, d1t)
				}
			}
			cnames1 <- c(cnames1, names(data)[1])
			cnames2 <- c(cnames2, names(data)[i])
			mdistances <- rbind(mdistances, hausdorff_dist(data1[[n]], data2[[n]], test = "Hausdorff", dist="maximum"))
			n <- n + 1
		}
	}
	gc()
	print("Pairwise comparisons completed")	
	options(stringsAsFactors = TRUE) #restore default R  
	return(list(cnames1, cnames2, data1, data2, adistances, mdistance))
}