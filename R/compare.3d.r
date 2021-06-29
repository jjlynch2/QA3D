compare.3d <- function(data = NULL, data2 = NULL, custom_surface = NULL, choose = NULL, procedure = "All", pca = TRUE, iteration = 20, cores = 1, subsample = NULL, break_early = 1, verbose = TRUE) {
	print("Pairwise comparisons started")
	startt <- start_time()
	options(stringsAsFactors = FALSE)
	cnames <- c()
	adistances <- 0
	mdistances <- 0
	sddistances <- 0
	maxcoords1 <- 0
	maxcoords2 <- 0
	n <- 1
	k <- 1

	if(pca) {
		if(exists("data2")) {
			maxx <- length(data) + length(data2)
		} else {
			maxx <- length(data)
		}
		setProgress(value = 3, message = "Aligning along principal axes", detail = '')
		withProgress(message = 'Aligning along principal axes', detail = '', value = 0, min=0, max=maxx, {
			print("Aligning along principal axes")
			for(i in 1:length(data)) {
				setProgress(value = i, message = paste("Aligning ", names(data)[i]," along principal axes",sep=""), detail = '')
				data[[i]][,c(1:3)] <- QA3D::pca_align(data[[i]][,c(1:3)])
			}
			if(procedure == "Custom" && !is.null(custom_surface)) {
				custom_surface <- QA3D::pca_align(custom_surface)
			}
			if(procedure == "Inter-observer-single" || procedure == "Inter-observer-multiple" || procedure == "Intra-observer-multiple") {
				pcvalue2 <- seq(from=0.31, to=0.4, length.out = length(data))			
				for(i in 1:length(data2)) {
				setProgress(value = (length(data) + i), message = paste("Aligning ", names(data2)[i]," along principal axes",sep=""), detail = '')
					data2[[i]][,c(1:3)] <- QA3D::pca_align(data2[[i]][,c(1:3)])
				}
			}
			k <- 8
			print("Finished...")
		})
	}
	setProgress(value = 4, message = "Registration", detail = '')
	if(procedure == "Intra-observer-single") {
		withProgress(message = 'Distances: ', detail = '', value = 0, min=0, max=(length(data)*length(data)-length(data))*k, {
			for(i in 1:length(data)) {
				for(x in 1:length(data)) {
					if(i == x) {break}
					A <- data[[i]][,c(1:3)]
					B <- data[[x]][,c(1:3)]
					d1t <- reflection_icp(A, B, iterations = iteration, threads = cores, subsample = subsample, break_early = break_early, k = k)
					mx1 <- d1t[[2]][[4]]
					mx2 <- d1t[[2]][[5]]
					write.tmp.data(cbind(d1t[[1]],d1t[[2]][[6]]), cbind(B,d1t[[2]][[7]]), paste(names(data)[i], names(data)[x], sep="-"))
					adistances <- rbind(adistances, d1t[[2]][[1]])
					mdistances <- rbind(mdistances, d1t[[2]][[2]])
					sddistances <- rbind(sddistances, d1t[[2]][[3]])
					maxcoords1 <- rbind(maxcoords1, d1t[[1]][d1t[[2]][[4]],])
					maxcoords2 <- rbind(maxcoords2, B[d1t[[2]][[5]],])
					cnames <- c(cnames, paste(names(data)[i], names(data)[x], sep="-"))
					print(paste("Final Error: ", names(data)[i], names(data)[x], adistances[n+1], mdistances[n+1], sddistances[n+1], sep=" "))
					n <- n + 1
				}
			}
		})
	} else if(procedure == "Inter-observer-single") {
		withProgress(message = 'Distances: ', detail = '', value = 0, min=0, max=length(data)*length(data2)*k, {
			for(i in 1:length(data)) {
				for(x in 1:length(data2)) {
					A <- data[[i]][,c(1:3)]
					B <- data2[[x]][,c(1:3)]
					d1t <- reflection_icp(A, B, iterations = iteration, threads = cores, subsample = subsample, break_early = break_early, k = k)
					mx1 <- d1t[[2]][[4]]
					mx2 <- d1t[[2]][[5]]
					write.tmp.data(cbind(d1t[[1]],d1t[[2]][[6]]), cbind(B,d1t[[2]][[7]]), paste(names(data)[i], names(data2)[x], sep="-"))
					adistances <- rbind(adistances, d1t[[2]][[1]])
					mdistances <- rbind(mdistances, d1t[[2]][[2]])
					sddistances <- rbind(sddistances, d1t[[2]][[3]])
					maxcoords1 <- rbind(maxcoords1, d1t[[1]][d1t[[2]][[4]],])
					maxcoords2 <- rbind(maxcoords2, B[d1t[[2]][[5]],])
					cnames <- c(cnames, paste(names(data)[i], names(data2)[x], sep="-"))
					print(paste("Final Error: ", names(data)[i], names(data2)[x], adistances[n+1], mdistances[n+1], sddistances[n+1], sep=" "))
					n <- n + 1
				}
			}
		})
	} else if(procedure == "Inter-observer-multiple" || procedure == "Intra-observer-multiple") {
		withProgress(message = 'Distances: ', detail = '', value = 0, min=0, max=length(data)*k, {
			for(i in 1:length(data)) {
					A <- data[[i]][,c(1:3)]
					B <- data2[[i]][,c(1:3)]
					d1t <- reflection_icp(A, B, iterations = iteration, threads = cores, subsample = subsample, break_early = break_early, k = k)
					mx1 <- d1t[[2]][[4]]
					mx2 <- d1t[[2]][[5]]
					write.tmp.data(cbind(d1t[[1]],d1t[[2]][[6]]), cbind(B,d1t[[2]][[7]]), paste(names(data)[i], names(data2)[i], sep="-"))
					adistances <- rbind(adistances, d1t[[2]][[1]])
					mdistances <- rbind(mdistances, d1t[[2]][[2]])
					sddistances <- rbind(sddistances, d1t[[2]][[3]])
					maxcoords1 <- rbind(maxcoords1, d1t[[1]][d1t[[2]][[4]],])
					maxcoords2 <- rbind(maxcoords2, B[d1t[[2]][[5]],])
					cnames <- c(cnames, paste(names(data)[i], names(data2)[i], sep="-"))
					print(paste("Final Error: ", names(data)[i], names(data2)[i], adistances[n+1], mdistances[n+1], sddistances[n+1], sep=" "))
					n <- n + 1
			}
		})
	} else if(procedure == "Custom" && !is.null(custom_surface)) {
		withProgress(message = 'Distances: ', detail = '', value = 0, min=0, max=length(data)*k, {
			for(i in 1:length(data)) {
				A <- data[[i]][,c(1:3)]
				d1t <- reflection_icp(A, custom_surface, iterations = iteration, threads = cores, subsample = subsample, break_early = break_early, k = k)
				mx1 <- d1t[[2]][[4]]
				mx2 <- d1t[[2]][[5]]
				write.tmp.data(cbind(d1t[[1]],d1t[[2]][[6]]), cbind(custom_surface,d1t[[2]][[7]]), paste("Custom", names(data)[i], sep="-"))
				adistances <- rbind(adistances, d1t[[2]][[1]])
				mdistances <- rbind(mdistances, d1t[[2]][[2]])
				sddistances <- rbind(sddistances, d1t[[2]][[3]])
				maxcoords1 <- rbind(maxcoords1, d1t[[1]][d1t[[2]][[4]],])
				maxcoords2 <- rbind(maxcoords2, custom_surface[d1t[[2]][[5]],])
				cnames <- c(cnames, paste("Custom", names(data)[i], sep="-"))
				print(paste("Final Error: ", "Custom", names(data)[i], adistances[n+1], mdistances[n+1], sddistances[n+1], sep=" "))
				n <- n + 1
			}
		})
	} else if(procedure == "Choose") {
		B <- data[[choose]][,c(1:3)]
		data[[choose]] <- NULL
		withProgress(message = 'Distances: ', detail = '', value = 0, min=0, max=length(data)*k, {
			for(i in 1:length(data)) {
				A <- data[[i]][,c(1:3)]
				d1t <- reflection_icp(A, B, iterations = iteration, threads = cores, subsample = subsample, break_early = break_early, k = k)
				mx1 <- d1t[[2]][[4]]
				mx2 <- d1t[[2]][[5]]
				write.tmp.data(cbind(d1t[[1]],d1t[[2]][[6]]), cbind(B,d1t[[2]][[7]]), paste(choose, names(data)[i], sep="-"))
				adistances <- rbind(adistances, d1t[[2]][[1]])
				mdistances <- rbind(mdistances, d1t[[2]][[2]])
				sddistances <- rbind(sddistances, d1t[[2]][[3]])
				maxcoords1 <- rbind(maxcoords1, d1t[[1]][d1t[[2]][[4]],])
				maxcoords2 <- rbind(maxcoords2, B[d1t[[2]][[5]],])
				cnames <- c(cnames, paste(choose, names(data)[i], sep="-"))
				print(paste("Final Error: ", choose, names(data)[i], adistances[n+1], mdistances[n+1], sddistances[n+1], sep=" "))
				n <- n + 1
			}
		})
	}
	gc()
	ttime <- end_time(startt)
	print("Pairwise comparisons completed")
	options(stringsAsFactors = TRUE)
	return(list(cnames, adistances[-1], mean(adistances[-1]), mdistances[-1], mean(mdistances[-1]), tem(adistances[-1]), tem(mdistances[-1]), rmse(adistances[-1]), rmse(mdistances[-1]), mean(sddistances[-1]), sddistances[-1], maxcoords1[-1,], maxcoords2[-1,], ttime))
}
