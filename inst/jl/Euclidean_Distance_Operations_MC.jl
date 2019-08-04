function MED3D(m1, m2)
	n1::Int = size(m1,1)
	Dist = SharedArray{Float64}((n1,3))
	@sync @distributed for k in 1:n1
		Dist[k,:] = MD3D(m1[k,:], m2, k)
	end
	return Dist
end