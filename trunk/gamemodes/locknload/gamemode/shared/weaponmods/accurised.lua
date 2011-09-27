WMOD.Name		= "Accurised"

function WMOD.PositiveDesc (classname)
	if classname == "weapon_lnl_pistol" or classname == "weapon_lnl_smg" or classname == "weapon_lnl_shotgun" then
		return "Higher accuracy, 2 ricochets"
	elseif classname == "weapon_lnl_cannon" then
		return "Higher accuracy, no arcing"
	elseif classname == "weapon_lnl_crossbow" then
		return "Higher accuracy, +2 ricochets"
	elseif classname == "weapon_lnl_laserrifle" then
		return "Tighter firing spread"
	end
	return "Higher accuracy"
end

function WMOD.NegativeDesc (classname)
	if classname == "weapon_lnl_laserrifle" then
		return "Lower firerate, slower to charge"
	end
	return "Lower firerate"
end

WMOD.Category	= 1
