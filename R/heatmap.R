KDtreePWmean <- function(A, B, threads = NULL) {
	yKD <- Rvcg::vcgCreateKDtree(as.matrix(A[,1:3]))
	clost <- Rvcg::vcgSearchKDtree(yKD,as.matrix(B[,1:3]),1,threads=threads)
	good <- which(clost$distance < 1e+15)
	ABm <- cbind(rowMeans(data.frame(A[clost$index[good],1], B[good,1])), rowMeans(data.frame(A[clost$index[good],2], B[good,2])), rowMeans(data.frame(A[clost$index[good],3], B[good,3])), rowMeans(data.frame(A[clost$index[good],4], B[good,4])))
	return(ABm)
}

color.gradient <- function(x, colors=c("green","springgreen","yellow","red"), colsteps=100) {
	return( colorRampPalette(colors) (colsteps) [ findInterval(x, seq(min(x),max(x), length.out=colsteps)) ] )
}

KDtree_Gmean <- function(A = NULL, threads = NULL, iterations = NULL, subsample = 0.10) {
	global_map <- as.matrix(A[[1]])
	for(x in 2:length(A)) {
		yKD <- Rvcg::vcgCreateKDtree(global_map)
		B <- as.matrix(A[[x]])
		s <- round(nrow(B) * subsample, digits = 0)
		subs <- Morpho::fastKmeans(B[,1:3],k=s,iter.max = 100,threads=threads)$selected
		xtmp <- B[subs,1:3]
		for(i in 1:iterations) {
			clost <- Rvcg::vcgSearchKDtree(yKD,xtmp,1,threads=threads)
			good <- which(clost$distance < 1e+15)
			trafo <- Morpho::computeTransform(global_map[clost$index[good],1:3],xtmp[good,1:3],type="rigid")
			xtmp <- Morpho::applyTransform(xtmp[,1:3],trafo)
		}
		fintrafo <- Morpho::computeTransform(xtmp[,1:3],B[subs,1:3],type = "rigid")
		x_result <- Morpho::applyTransform(B[,1:3],fintrafo)
		clost <- Rvcg::vcgSearchKDtree(yKD,x_result[,1:3],1,threads=threads)
		good <- which(clost$distance < 1e+15)
		global_map <- cbind(rowMeans(data.frame(global_map[clost$index[good],1], x_result[good,1])), rowMeans(data.frame(global_map[clost$index[good],2], x_result[good,2])), rowMeans(data.frame(global_map[clost$index[good],3], x_result[good,3])), rowMeans(data.frame(global_map[clost$index[good],4], B[good,4])))
	}
	return(global_map)
}
