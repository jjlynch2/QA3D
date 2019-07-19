compare.3d <- function(data = NULL, custom_surface = NULL, sessiontempdir = NULL, procedure = "All", pca = TRUE, iteration = 20, cores = 1, subsample = NULL, break_early = 1, verbose = TRUE) {
	print("Pairwise comparisons started")
	options(stringsAsFactors = FALSE)
	data1 <- list()
	data2 <- list()
	cnames <- c()
	adistances <- 0
	mdistances <- 0
	n <- 1
	if(procedure == "Custom" && !is.null(custom_surface)) {
		B <- custom_surface
		if(pca) {
			B <- QA3D::pca_align(B)
		}
		for(i in 1:length(data)) {
			k = 1
			A <- data[[i]][,c(1:3)]
			if(pca) {
				A <- QA3D::pca_align(A)
				k = 8
			}
			d1 = 999999
			ad = 0
			md = 0
			for(j in 1:k) {
				if (j == 1) {lt1 <- cbind( A[,1], A[,2],A[,3])}
				else if(j == 2) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3])}
				else if (j == 3) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3])}
				else if (j == 4) {lt1 <- cbind( A[,1], A[,2],A[,3]*-1)}
				else if (j == 5) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3])}
				else if (j == 6) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3]*-1)}
				else if (j == 7) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3]*-1)}
				else if (j == 8) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3]*-1)}
				if(!is.null(subsample)) {
					nr1 <- nrow(B)
					nr1 <- nr1 * subsample
					nr2 <- nrow(lt1)
					nr2 <- nr2 * subsample
					subs <- round(mean(nr1, nr2), digits = 0)
				} else {
					subs = NULL
				}
				lt <- icpmat(lt1, B, iterations = iteration, type = "rigid", threads = cores, subsample = subs)
				d1t <- hausdorff_dist(lt, B, test = "Hausdorff")
				avg <- d1t[1]
				max <- d1t[2]
				if(verbose) {
					print(paste(avg, max, sep = " "))
				}
				if (avg < d1) {
					d1 <- avg
					data1[[n]] <- lt
					data2[[n]] <- B
					ad <- avg
					md <- max
					if(!is.null(break_early)) {
						if(max < break_early) {
							break
						}
					}
				}
			}
			adistances <- rbind(adistances, ad)
			mdistances <- rbind(mdistances, md)
			cnames <- c(cnames, paste("Custom", names(data)[i], sep="-"))
			print(paste("Custom", names(data)[i], adistances[n+1], mdistances[n+1], sep=" "))
			n <- n + 1
		}
	} else if(procedure == "All") {
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
				ad = 0
				md = 0
				for(j in 1:k) {
					if (j == 1) {lt1 <- cbind( A[,1], A[,2],A[,3])}
					else if(j == 2) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3])}
					else if (j == 3) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3])}
					else if (j == 4) {lt1 <- cbind( A[,1], A[,2],A[,3]*-1)}
					else if (j == 5) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3])}
					else if (j == 6) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3]*-1)}
					else if (j == 7) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3]*-1)}
					else if (j == 8) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3]*-1)}
					if(!is.null(subsample)) {
						nr1 <- nrow(B)
						nr1 <- nr1 * subsample
						nr2 <- nrow(lt1)
						nr2 <- nr2 * subsample
						subs <- round(mean(nr1, nr2), digits = 0)
					} else {
						subs = NULL
					}
					lt <- icpmat(lt1, B, iterations = iteration, type = "rigid", threads = cores, subsample = subs)
					d1t <- hausdorff_dist(lt, B, test = "Hausdorff")
					avg <- d1t[1]
					max <- d1t[2]
					if(verbose) {
						print(paste(avg, max, sep = " "))
					}
					if (avg < d1) {
						d1 <- avg
						ad <- avg
						md <- max
						data1[[n]] <- lt
						data2[[n]] <- B
						if(!is.null(break_early)) {
							if(max < break_early) {
								break
							}
						}
					}
				}
				adistances <- rbind(adistances, ad)
				mdistances <- rbind(mdistances, md)
				cnames <- c(cnames, paste(names(data)[i], names(data)[x], sep="-"))
				print(paste(names(data)[i], names(data)[x], adistances[n+1], mdistances[n+1], sep=" "))
				n <- n + 1
			}
		}
	} else if(procedure == "First") {
		B <- data[[1]][,c(1:3)]
		if(pca) {
			B <- QA3D::pca_align(B)
		}
		for(i in 2:length(data)) {
			k = 1
			A <- data[[i]][,c(1:3)]
			if(pca) {
				A <- QA3D::pca_align(A)
				k = 8
			}
			d1 = 999999
			ad = 0
			md = 0
			for(j in 1:k) {
				if (j == 1) {lt1 <- cbind( A[,1], A[,2],A[,3])}
				else if(j == 2) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3])}
				else if (j == 3) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3])}
				else if (j == 4) {lt1 <- cbind( A[,1], A[,2],A[,3]*-1)}
				else if (j == 5) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3])}
				else if (j == 6) {lt1 <- cbind( A[,1]*-1, A[,2],A[,3]*-1)}
				else if (j == 7) {lt1 <- cbind( A[,1], A[,2]*-1,A[,3]*-1)}
				else if (j == 8) {lt1 <- cbind( A[,1]*-1, A[,2]*-1,A[,3]*-1)}
				if(!is.null(subsample)) {
					nr1 <- nrow(B)
					nr1 <- nr1 * subsample
					nr2 <- nrow(lt1)
					nr2 <- nr2 * subsample
					subs <- round(mean(nr1, nr2), digits = 0)
				} else {
					subs = NULL
				}
				lt <- icpmat(lt1, B, iterations = iteration, type = "rigid", threads = cores, subsample = subs)
				d1t <- hausdorff_dist(lt, B, test = "Hausdorff")
				avg <- d1t[1]
				max <- d1t[2]
				if(verbose) {
					print(paste(avg, max, sep = " "))
				}
				if (avg < d1) {
					d1 <- avg
					data1[[n]] <- lt
					data2[[n]] <- B
					ad <- avg
					md <- max
					if(!is.null(break_early)) {
						if(max < break_early) {
							break
						}
					}
				}
			}
			adistances <- rbind(adistances, ad)
			mdistances <- rbind(mdistances, md)
			cnames <- c(cnames, paste(names(data)[1], names(data)[i], sep="-"))
			print(paste(names(data)[1], names(data)[i], adistances[n+1], mdistances[n+1], sep=" "))
			n <- n + 1
		}
	}
	gc()
	print("Pairwise comparisons completed")	
	options(stringsAsFactors = TRUE)
	return(list(cnames, data1, data2, adistances[-1], mean(adistances[-1]), mdistances[-1], mean(mdistances[-1]), tem(adistances[-1]), tem(mdistances[-1]), rmse(adistances[-1]), rmse(mdistances[-1])))
}