WMOD.Name		= "Rapid-reloading"
WMOD.PositiveDesc	= "Faster reloads"
WMOD.NegativeDesc	= "Lower ammo capacity"
WMOD.Category	= 2

function WMOD:IsApplicable (classname)
	return classname != "weapon_lnl_crossbow"
end