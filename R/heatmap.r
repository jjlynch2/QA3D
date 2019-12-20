KDtreePWmean <- function(A, B, threads = NULL) {
	if(nrow(A) < nrow(B)) {
		bt <- A
		A <- B
		B <- bt
	}
	yKD <- Rvcg::vcgCreateKDtree(as.matrix(B[,1:3]))
	clost <- Rvcg::vcgSearchKDtree(yKD,as.matrix(A[,1:3]),1,threads=threads)
	A[,4] <- rowMeans(cbind(B[clost$index,4], A[,4]))
	return(A)
}

color.gradient <- function(x, colors=c("green","red"), mini = 0.01, maxi = 1, steps=10) {
	return( colorRampPalette(colors) (steps) [ findInterval(x, seq(mini,maxi, length.out=steps)) ] )
}

KDtree_Gmean <- function(A = NULL, threads = NULL, iterations = NULL, subsample = 0.01) {
	tn <- 0
	for(z in 1:length(A)) {
		centroid <- apply(A[[z]][,1:3],2,mean)
		centroidsize <- sqrt(sum((t(t(A[[z]][,1:3])-centroid))^2))
		A[[z]][,1:3] <- A[[z]][,1:3] / centroidsize
		tn <- c(tn, nrow(A[[z]]))
	}

	tn <- tn[-1]
	low_i = 1
	for(z in 1:length(tn)) {
		low = 99999999999
		lowt = abs(tn[z] - mean(tn))
		if(lowt < low) {
			low = lowt
			low_i = z
		}
	}

	global_map_R <- as.matrix(A[[low_i]][,1:3])
	global_mape <- as.matrix(A[[low_i]][,4])
	A[[low_i]] <- NULL
	yKD <- Rvcg::vcgCreateKDtree(global_map_R)
	withProgress(message = 'Distances: ', detail = '', value = 0, min=0, max=length(A), {
		for(z in 1:length(A)) {
			d11 <- 999999
			B <- as.matrix(A[[z]])
			Gclost <- NULL
			for(j in 1:8) {
				if (j == 1) {x <- cbind( B[,1], B[,2],B[,3])}
				else if (j == 2) {x <- cbind( B[,1]*-1, B[,2]*-1,B[,3]*-1)}
				else if (j == 3) {x <- cbind( B[,1], B[,2]*-1,B[,3]*-1)}
				else if (j == 4) {x <- cbind( B[,1]*-1, B[,2],B[,3]*-1)}
				else if (j == 5) {x <- cbind( B[,1]*-1, B[,2]*-1,B[,3])}
				else if (j == 6) {x <- cbind( B[,1], B[,2],B[,3]*-1)}
				else if (j == 7) {x <- cbind( B[,1], B[,2]*-1,B[,3])}
				else if (j == 8) {x <- cbind( B[,1]*-1, B[,2],B[,3])}
				s <- round(nrow(x) * subsample, digits = 0)
				subs <- Morpho::fastKmeans(x,k=s,iter.max = 100,threads=threads)$selected
				xtmp <- x[subs,]
				for(i in 1:iterations) {
					clost <- Rvcg::vcgSearchKDtree(yKD,xtmp,1,threads=threads)
					good <- which(clost$distance < 1e+15)
					trafo <- Morpho::computeTransform(global_map_R[clost$index[good],],xtmp[good,],type="rigid")
					xtmp <- Morpho::applyTransform(xtmp[,],trafo)
				}
				d1t <- hausdorff_dist(xtmp, global_map_R[clost$index[good],], threads)
				setProgress(value = z, message = paste("Distances: ", d1t[1], d1t[2], d1t[3], sep = " "), detail = '')
				if(d1t[[1]] < d11) {
					d11 <- d1t[[1]]
					fintrafo <- Morpho::computeTransform(xtmp[,],x[subs,],type = "rigid")
					Gx_result <- Morpho::applyTransform(x,fintrafo)

					GyKD <- Rvcg::vcgCreateKDtree(Gx_result)
					Gclost <- Rvcg::vcgSearchKDtree(GyKD,global_map_R,1,threads=threads)
				}
			}
			global_mape <- cbind(global_mape, B[Gclost$index,4])
		}
		global_mape <- rowMeans(global_mape)
		global_map <- cbind(global_map_R, global_mape)
		print("Heatmap generation completed")
	})
	return(global_map)
}
