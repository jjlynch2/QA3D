#' three-dimensional pair-match function
#' 
#'
#' @keywords input.3d
#' @export
#' @examples
#' input.3d()

input.3d <- function(list1 = NULL) {
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
	names(Rlist) <- gsub(".*/\\s*", "", list1)
	print("3D data imported")
	return(Rlist)
}