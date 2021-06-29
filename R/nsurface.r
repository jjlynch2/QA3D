nsurface <- function(a, b, c, d) {
	a <- seq(from = 0, to = a, by = d)
	b <- seq(from = 0, to = b, by = d)
	c <- seq(from = 0, to = c, by = d)
	faces_xy <- expand.grid(x = a, y = b, z = c(min(c), max(c)))
	faces_xz <- expand.grid(x = a, y = c(min(b), max(b)), z = c)
	faces_yz <- expand.grid(x = c(min(a), max(a)), y = b, z = c)
	surface <- unique(rbind(faces_xy, faces_xz, faces_yz))
	return(surface)
}
