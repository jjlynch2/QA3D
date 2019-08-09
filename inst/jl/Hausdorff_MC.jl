function Hausdorff(m1,m2)
	Res1 = MED3D(m1,m2)
	Res2 = MED3D(m2,m1)
	Sd1  = std(Res1[:,1])
	Sd2 = std(Res2[:,1])
	Sd = mean([Sd1,Sd2])
	Avg1 = mean(Res1[:,1])
	Avg2 = mean(Res2[:,1])
	Max1 = findmax(Res1[:,1])
	Max2 = findmax(Res2[:,1])
	Avg = max(Avg1, Avg2)
	Max = findmax([Max1[1], Max2[1]])
	if Max[2] == 1
		j = Res1[Max1[2],2]
		x = Res1[Max1[2],3]
	else
		x = Res2[Max2[2],2]
		j = Res2[Max2[2],3]
	end
	return [Avg, Max[1], Sd, j, x]
end