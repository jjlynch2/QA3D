output$about_refs <- renderUI({
	HTML("<p>
		QA3D (Quality Assurance 3D) is an R package that allows the error analysis of repeated scans from three-dimensional equipment. While not requiring the use of skeletal elements, this app was designed and intended to be used with repeated skeletal element scans. Given the rise in popularity of three-dimensional technology in forensic anthropology, there is a need for an FA specific tool to verify the quality of scanners for research and laboratory accreditation purposes.
		<br><br>
		Currently only xyz/xyzrgb files are supported.
		<br><br>
		ICP Subsample uses k-means to identify a subsample of coordinates for registration based on a percentage of the original coordinates of each scan. If using PC alignment, this uses the subsample to calculate the distance between reflections.
		<br><br>
		PC Align uses Principal Component Analysis to pre-align specimens. This requires reflection along each dimension and takes longer to run. However, it significantly increases the chance of successful registration.
		<br><br>
		Break Early specifies a break point when using PC Align where any reflection with a maximum distance less than the break point is accepted as the true distance.
		<br><br>
		Generate heatmap will produce pairwise and mean heatmaps using the first and average sized scans respectively.
		<br><br>
		The Choose procedure will compare all scans to the chosen scan.
		<br><br>
		The Intra-observer-single procedure will compare all scans to every other scan. This is intended for multiple repeated scans of a single specimen.
		<br><br>
		The Intra-observer-multiple procedure will compare scans from each import group sequentially. This is intended for repeated scans of multiple specimens.
		<br><br>
		The Custom procedure will create a surface of x, y, and z dimensions using a specified density for comparison with the imported scans.
		<br><br>
		The inter-observer-single procedure will compare all scans from one observer to every other scan from another observer. This is intended for multiple repeated scans of a single specimen.
		<br><br>
		The inter-observer-multiple procedure will compare scans from each import group sequentially. This is intended for repeated scans of multiple specimesn.
		</p>
	")
})
