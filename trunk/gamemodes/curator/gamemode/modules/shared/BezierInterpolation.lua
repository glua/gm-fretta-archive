
Bezier = {}

function Bezier.PointOn3DCurve(dis,pt1,pt2,pt3)
	local out1 = ((1-dis)^2)*pt1.x+2*(1-dis)*dis*pt2.x+(dis^2)*pt3.x
	local out2 = ((1-dis)^2)*pt1.y+2*(1-dis)*dis*pt2.y+(dis^2)*pt3.y
	local out3 = ((1-dis)^2)*pt1.z+2*(1-dis)*dis*pt2.z+(dis^2)*pt3.z
	return Vector(out1,out2,out3)
end 

function Bezier.PointOn2DCurve(dis,pt1,pt2,pt3)
	local out1 = ((1-dis)^2)*pt1.x+2*(1-dis)*dis*pt2.x+(dis^2)*pt3.x
	local out2 = ((1-dis)^2)*pt1.y+2*(1-dis)*dis*pt2.y+(dis^2)*pt3.y
	return out1,out2
end 

function Bezier.CubicInterpolation(dis,pt1,pt2,pt3,pt4)
	return ((1-dis)^3)*pt1+3*((1-dis)^2)*dis*pt2+3*((1-dis)^2)*dis*pt3+(dis^3)*pt4
end

function Bezier.QudraticInterpolation(dis,pt1,pt2,pt3)
	return ((1-dis)^2)*pt1+2*(1-dis)*dis*pt2+(dis^2)*pt3
end

function Bezier.Point(xval,yval)
	return {x=xval,y=yval}
end 

local DoneFactorials = {}

function Bezier.Factorial(n)
	if DoneFactorials[n] then return DoneFactorials[n] end
	if n == 0 then
		return 1
	else
		DoneFactorials[n] = n * Bezier.Factorial(n - 1)
		return DoneFactorials[n]
	end
end 

local DoneCombinations = {}

function Bezier.Combinations(n,k)
	if DoneCombinations[n] and DoneCombinations[n][k] then return DoneCombinations[n][k] end
	if not DoneCombinations[n] then DoneCombinations[n] = {} end
	DoneCombinations[n][k] = Bezier.Factorial(n)/(Bezier.Factorial(k)*Bezier.Factorial(n-k))
	return DoneCombinations[n][k]
end

function Bezier.Generalization(dis,...)
	local pts = {...}
	local n = #pts
	local ret = 0
	for i=1,n do
		ret = ret+(Bezier.Combinations(n,i)*((1-dis)^(n-i))*(dis^i)*pos[i])
	end
	return ret
end 


function Bezier.TableOfPointsOnQuadraticCurve(col,w,h,itier,dist,pt1,pt2,pt3) --Color, width, height, iterations(smoothness), distance(is a part of iterations), start point, control point, end point
	local outtable = {}
	local start = 1/itier
	dist = math.Clamp(dist,1,itier)
	for i=1,dist do
		local x,y = Bezier.PointOn2DCurve(start,pt1,pt2,pt3)
		local tbl = {}
		tbl["x"] = x
		tbl["y"] = y
		tbl["w"] = w
		tbl["h"] = h
		tbl["color"] = col
		tbl["texture"] = draw.NoTexture()
		table.insert(outtable,tbl)
		start = start + 1/itier
	end
	return outtable
end 

function Bezier.TableOfPointsOnNthDegreeCurve(col,w,h,itier,dist,...) --Color, width, height, iterations(smoothness), distance(is a part of iterations), start point, control point, end point
	local outtable = {}
	local start = 1/itier
	dist = math.Clamp(dist,1,itier)
	for i=1,dist do
		local x,y = Bezier.Generalization(start,unpack({...}))
		local tbl = {}
		tbl["x"] = x
		tbl["y"] = y
		tbl["w"] = w
		tbl["h"] = h
		tbl["color"] = col
		tbl["texture"] = draw.NoTexture()
		table.insert(outtable,tbl)
		start = start + 1/itier
	end
	return outtable
end 

