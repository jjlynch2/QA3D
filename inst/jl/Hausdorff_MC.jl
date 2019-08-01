function Hausdorff(m1,m2)
	Res1 = MED3D(m1,m2)
	Res2 = MED3D(m2,m1)
	Sd1  = std(Res1)
	Sd2 = std(Res2)
	Sd = mean([Sd1,Sd2])
	Avg1 = mean(Res1)
	Avg2 = mean(Res2)
	Max1 = findmax(Res1)[1]
	Max2 = findmax(Res2)[1]
	Avg = mean([Avg1, Avg2])
	Max = max(Max1, Max2)
	return [Avg, Max, Sd]
end