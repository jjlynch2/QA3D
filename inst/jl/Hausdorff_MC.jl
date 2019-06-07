#Maximum Hausdorff
function Max_Hausdorff(m1,m2)
	Res1 = MED3D(m1,m2)
	Res1 = findmax(Res1)[1]
	Res2 = MED3D(m2,m1)
	Res2 = findmax(Res2)[1]
	Res = max(Res1,Res2)
	return Res
end

#Average Hausdorff
function Average_Hausdorff(m1,m2)
	Res1 = MED3D(m1,m2)
	Res1 = mean(Res1)
	Res2 = MED3D(m2,m1)
	Res2 = mean(Res2)
	Res = mean(Res1 + Res2)
	return Res
end