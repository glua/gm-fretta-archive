WMOD.Name		= "High-capacity"
WMOD.PositiveDesc	= "Higher ammo capacity"
WMOD.NegativeDesc	= "Slower reloads"
WMOD.Category	= 2

function WMOD:IsApplicable (classname)
	return classname != "weapon_lnl_crossbow"
end