output$about_refs <- renderUI({
	HTML("<p><h3>About</h3>
		QA3D (Quality Assurance 3D) is an R package that allows the error analysis of repeated scans from three-dimensional equipment. While not requiring the use of skeletal elements, this app was designed and intended to be used with repeated skeletal element scans. Given the rise in popularity of three-dimensional technology in forensic anthropology, there is a need for an FA specific tool to verify the quality of scanners for research and laboratory accreditation purposes.
		<br><br>
		Currently only xyz/xyzrgb files are supported.
		<br><br>
		ICP Subsample uses k-means to identify a subsample of coordinates for registration based on a percentage of the original coordinates of each scan. If using PC alignment, this uses the subsample to calculate the distance between reflections.
		<br><br>
		PC Align uses Principal Component Analysis to pre-align specimens. This requires reflection along each dimension and takes longer to run. However, it significantly increases the change of successful registration.
		<br><br>
		Break Early specifies a break point when using PC Align where any reflection with a maximum distance less than the break point is accepted as the true distance.
		<br><br>
		K-means Simplify reduces the point cloud size based on a percentage of the original coordinates of each scan.
		<br><br>
		The Choose procedure will compare all scans to the chosen scan.
		<br><br>
		The All procedure will compare all scans to every other scan.
		<br><br>
		The Custom procedure will create a surface of x, y, and z dimensions using a specified density for comparison with the imported scans.
		</p>
	")
})