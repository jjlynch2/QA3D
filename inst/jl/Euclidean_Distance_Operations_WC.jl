@everywhere function MD3D(v1, m2)
	dsum::Float64 = Inf
	for j in 1:size(m2,1)
		dtemp::Float64 = sqrt((v1[1] - m2[j,1]) * (v1[1] - m2[j,1]) + (v1[2] - m2[j,2]) * (v1[2] - m2[j,2]) + (v1[3] - m2[j,3]) * (v1[3] - m2[j,3]))
		if dtemp < dsum
			dsum = dtemp
		end
	end
	return dsum
end