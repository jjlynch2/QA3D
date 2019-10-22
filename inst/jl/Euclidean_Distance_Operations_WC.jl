@everywhere function MD3D(v1, m2, k)
	dsum::Float64 = Inf
	dtemp::Float64 = Inf
	i = 0
	for j in 1:size(m2,1)
		@inbounds dtemp = sqrt((v1[1] - m2[j,1]) * (v1[1] - m2[j,1]) + (v1[2] - m2[j,2]) * (v1[2] - m2[j,2]) + (v1[3] - m2[j,3]) * (v1[3] - m2[j,3]))
		if dtemp < dsum
			dsum = dtemp
			i = j
		end
	end
	return [dsum, k, i]
end
