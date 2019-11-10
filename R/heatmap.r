KDtreePWmean <- function(A, B, threads = NULL) {
	if(nrow(A) < nrow(B)) {
		bt <- A
		A <- B
		B <- bt
	}
	yKD <- Rvcg::vcgCreateKDtree(as.matrix(B[,1:3]))
	clost <- Rvcg::vcgSearchKDtree(yKD,as.matrix(A[,1:3]),1,threads=threads)
	ind <- any(!rbind(!duplicated(B[clost$index,1]), !duplicated(B[clost$index,2]), !duplicated(B[clost$index,3])))
	A[ind,1] <- rowMeans(cbind(B[clost$index,1], A[ind,1]))
	A[ind,2] <- rowMeans(cbind(B[clost$index,2], A[ind,2]))
	A[ind,3] <- rowMeans(cbind(B[clost$index,3], A[ind,3]))
	A[ind,4] <- rowMeans(cbind(B[clost$index,4], A[ind,4]))
	return(A)
}

color.gradient <- function(x, colors=c("blue","green","orange","red"), colsteps=50) {
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
	global_map_R <- as.matrix(A[[iz]][,1:3])
	A[[iz]] <- NULL
	global_mapx <- as.matrix(A[[iz]][,1])
	global_mapy <- as.matrix(A[[iz]][,2])
	global_mapz <- as.matrix(A[[iz]][,3])
	global_mape <- as.matrix(A[[iz]][,4])
	yKD <- Rvcg::vcgCreateKDtree(global_map_R)
	withProgress(message = 'Distances: ', detail = '', value = 0, min=0, max=length(A), {
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
					if(!is.null(break_early)) {
						if(d1t[[2]] < break_early) {
							break
						}
					}
				}
			}
			global_mapx <- cbind(global_mapx, Gx_result[Gclost$index,1])
			global_mapy <- cbind(global_mapy, Gx_result[Gclost$index,2])
			global_mapz <- cbind(global_mapz, Gx_result[Gclost$index,3])
			global_mape <- cbind(global_mape, B[Gclost$index,4])

		}
		global_map <- global_map_R
		global_map[] <- 0
		global_map <- cbind(global_map,0,1)
		for(i in 1:ncol(global_mapx)) {
			ind <- any(!rbind(!duplicated(global_mapx[,i]), !duplicated(global_mapy[,i]), !duplicated(global_mapz[,i])))
			global_map[ind,1] <- global_mapx[ind,i] + global_map[ind,1]
			global_map[ind,2] <- global_mapy[ind,i] + global_map[ind,2]
			global_map[ind,3] <- global_mapz[ind,i] + global_map[ind,3]
			global_map[ind,4] <- global_mape[ind,i] + global_map[ind,4]
			global_map[ind,5] <- global_map[!duplicated(global_mapx),5] + 1
		}

		global_map[,1] <- global_map[,1] / global_map[,5]
		global_map[,2] <- global_map[,2] / global_map[,5]
		global_map[,3] <- global_map[,3] / global_map[,5]
		global_map[,4] <- global_map[,4] / global_map[,5]
		print("Heatmap generation completed")
	})
	return(global_map)
}
