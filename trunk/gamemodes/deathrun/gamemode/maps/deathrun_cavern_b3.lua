
GM:RemoveWeapon(Vector(208.3125, 2764.0625, 1250))
GM:RemoveWeapon(Vector(-566.2389, -3337.4548, 776.0313))
GM:RemoveWeapon(Vector(-208.0313, -1327.9688, 1373.2222))

local Pits = {
	Vector(208.3125, 2764.0625, 1250),
	Vector(233.7806, 1595.9767, 180.0313),
	Vector(-570.7527, -1849.5690, -1775.4802),
	Vector(215.6414, 1595.1970, 291.8622)
}

for k,v in pairs(Pits) do
	GM:AddTouchEvents(v, 750, function(ply)
		ply:Kill()
	end)
end
