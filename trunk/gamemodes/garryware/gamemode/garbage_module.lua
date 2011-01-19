////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Garbage Module                             //
////////////////////////////////////////////////

////////////////////////////////
//////// Copy
////////

function GC_ColorCopy(colorDest, colorSource)
	colorDest.r = colorSource.r
	colorDest.g = colorSource.g
	colorDest.b = colorSource.b
	colorDest.a = colorSource.a
end

function GC_VectorCopy(vectorDest, vectorSource)
	vectorDest.x = vectorSource.x
	vectorDest.y = vectorSource.y
	vectorDest.z = vectorSource.z
end

function GC_AngleCopy(angleDest, angleSource)
	angleDest.p = angleSource.p
	angleDest.y = angleSource.y
	angleDest.r = angleSource.r
end

////////////////////////////////
//////// Replacement
////////

function GC_ColorReplace(colorDest, colorR, colorG, colorB, colorA)
	colorDest.r = colorR
	colorDest.g = colorG
	colorDest.b = colorB
	colorDest.a = colorA
end

////////////////////////////////
//////// Blending
////////

function GC_ColorRatio(colorMod, ratioR, ratioG, ratioB, ratioA)
	colorMod.r = colorMod.r * ratioR
	colorMod.g = colorMod.g * ratioG
	colorMod.b = colorMod.b * ratioB
	colorMod.a = colorMod.a * ratioA
end

function GC_ColorBlend(colorMod, colorA, colorB, ratioTrendB)
	ratioTrendB = math.Clamp(ratioTrendB, 0.0, 1.0)
	local ratioTrendA = 1.0 - ratioTrendB
	
	colorMod.r = colorA.r * ratioTrendA + colorB.r * ratioTrendB
	colorMod.g = colorA.g * ratioTrendA + colorB.g * ratioTrendB
	colorMod.b = colorA.b * ratioTrendA + colorB.b * ratioTrendB
	colorMod.a = colorA.a * ratioTrendA + colorB.a * ratioTrendB
end
