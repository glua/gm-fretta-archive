// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Utility functions.

function AddColor(col1,col2,val) // Much like 'additive' where the color rgb is added.
	val = val or 1
	
	col1.r = math.Clamp(col1.r + (col2.r*val),0,255)
	col1.g = math.Clamp(col1.g + (col2.g*val),0,255)
	col1.b = math.Clamp(col1.b + (col2.b*val),0,255)
end

function LerpColor(val,col1,col2) // Tween between colors to a certain % (in decimal form. E.G. LerpColor(0.5,color_white,color_black) would result in a gray (halfway between)
	val = val or 1
	
	col = Color(
		Lerp(val,col1.r,col2.r),
		Lerp(val,col1.g,col2.g),
		Lerp(val,col1.b,col2.b),
		Lerp(val,col1.a,col2.a)
	)
	
	return col
end

// Explode color structs for dumb functions like Particle:SetColor that don't play nice with color structs.
function ExpColor(c)
	return c.r,c.g,c.b,c.a
end

