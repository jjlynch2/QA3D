hausdorff_dist <- function (f2, f1, threads) {
	f1t <- Rvcg::vcgCreateKDtree(f1)
	f2t <- Rvcg::vcgCreateKDtree(f2)
	clost1 <- Rvcg::vcgSearchKDtree(f1t,f2,1,threads=threads)
	clost2 <- Rvcg::vcgSearchKDtree(f2t,f1,1,threads=threads)
	Sd1 <- sd(clost1$distance)
	Sd2 <- sd(clost2$distance)
	Sd <- mean(Sd1,Sd2)
	Avg1 <- mean(clost1$distance)
	Avg2 <- mean(clost2$distance)
	Avg <- mean(Avg1,Avg2)
	Max1 <- clost1$distance[which.max(clost1$distance)]
	Max2 <- clost2$distance[which.max(clost2$distance)]
	Max <- max(Max1, Max2)
	if(Max == Max1) {
		j = clost2$index[which.max(clost2$distance)]
		x = which.max(clost2$distance)
	} else {
		j = clost1$index[which.max(clost1$distance)]
		x = which.max(clost1$distance)
	}
	return(list(Avg, Max, Sd, j, x, clost1$distance, clost2$distance))
}
