KDtreePWmean <- function(A, B, threads = NULL) {
	if(nrow(A) < nrow(B)) {
		bt <- A
		A <- B
		B <- bt
	}
	yKD <- Rvcg::vcgCreateKDtree(as.matrix(A[,1:3]))
	clost <- Rvcg::vcgSearchKDtree(yKD,as.matrix(B[,1:3]),1,threads=threads)
	good <- which(clost$distance < 1e+15)
	A[clost$index[good],1] <- rowMeans(cbind(A[clost$index[good],1], B[good,1]))
	A[clost$index[good],2] <- rowMeans(cbind(A[clost$index[good],2], B[good,2]))
	A[clost$index[good],3] <- rowMeans(cbind(A[clost$index[good],3], B[good,3]))
	A[clost$index[good],4] <- rowMeans(cbind(A[clost$index[good],4], B[good,4]))
	return(A)
}

color.gradient <- function(x, colors=c("blue","green","yellow","orange","red"), colsteps=50) {
	return( colorRampPalette(colors) (colsteps) [ findInterval(x, seq(min(x),max(x), length.out=colsteps)) ] )
}

KDtree_Gmean <- function(A = NULL, threads = NULL, iterations = NULL, subsample = 0.01, break_early = 1) {
	ptn <- 0
	iz <- NULL
	for(z in 1:length(A)) {
		tn <- nrow(A[[z]])
		if(tn > ptn) {
			ptn <- tn
			iz <- z
		}
	}
	global_map_R <- as.matrix(A[[iz]][,1:4])
	A[[iz]] <- NULL
	global_map <- cbind(global_map_R,1)
	yKD <- Rvcg::vcgCreateKDtree(global_map_R[,1:3])
	for(z in 1:length(A)) {
		d11 <- 999999
		B <- as.matrix(A[[z]])
		Gclost <- NULL
		Gx_result <- NULL
		Ggood <- NULL
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
				trafo <- Morpho::computeTransform(global_map_R[clost$index[good],1:3],xtmp[good,],type="rigid")
				xtmp <- Morpho::applyTransform(xtmp[,],trafo)
			}
			d1t <- hausdorff_dist(xtmp, global_map_R[clost$index[good],1:3])
			print(paste("Heatmap Registration: ", d1t[1], d1t[2], d1t[3], sep = " "))
			if(d1t[[1]] < d11) {
				d11 <- d1t[[1]]
				fintrafo <- Morpho::computeTransform(xtmp[,],x[subs,],type = "rigid")
				Gx_result <- Morpho::applyTransform(x,fintrafo)
				Gclost <- Rvcg::vcgSearchKDtree(yKD,Gx_result,1,threads=threads)
				Ggood <- which(Gclost$distance < 1e+15)
				if(!is.null(break_early)) {
					if(d1t[[2]] < break_early) {
						break
					}
				}
			}
		}
		global_map[Gclost$index[Ggood],1] <- rowSums(cbind(global_map[Gclost$index[Ggood],1], Gx_result[Ggood,1]))
		global_map[Gclost$index[Ggood],2] <- rowSums(cbind(global_map[Gclost$index[Ggood],2], Gx_result[Ggood,2]))
		global_map[Gclost$index[Ggood],3] <- rowSums(cbind(global_map[Gclost$index[Ggood],3], Gx_result[Ggood,3]))
		global_map[Gclost$index[Ggood],4] <- rowSums(cbind(global_map[Gclost$index[Ggood],4], B[Ggood,4]))
		global_map[Gclost$index[Ggood],5] <- global_map[Gclost$index[Ggood],5] + 1
	}
	global_map[,1] <- global_map[,1] / global_map[,5]
	global_map[,2] <- global_map[,2] / global_map[,5]
	global_map[,3] <- global_map[,3] / global_map[,5]
	global_map[,4] <- global_map[,4] / global_map[,5]
	return(global_map)
}
