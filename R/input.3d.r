input.3d <- function(list1 = NULL, filenames = NULL) {
	print("Importing 3D data")
	Rlist <- list()
	for(i in 1:length(list1)) {
		Rtemp <- read.table(list1[i], quote="\"", comment.char="", stringsAsFactors=FALSE, header = FALSE)
		if(is.character(Rtemp[1,1])) {
			Rlist[[i]] <- read.table(list1[i], quote="\"", comment.char="", stringsAsFactors=FALSE, header = TRUE)
		}
		if(!is.character(Rtemp[1,1])) {
			Rlist[[i]] <- read.table(list1[i], quote="\"", comment.char="", stringsAsFactors=FALSE, header = FALSE)
		}
	}
	names(Rlist) <- gsub(".*/\\s*", "", filenames)
	print("3D data imported")
	return(Rlist)
}