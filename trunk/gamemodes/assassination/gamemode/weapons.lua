GM.Categories = {
	
	shotgun = { printname = "Shotguns", icon = "weapon_as_spas12", icontype = "killicon" },
	smg = { printname = "Sub-machine Guns", icon = "weapon_as_mp7", icontype = "killicon" },
	assault = { printname = "Assault Rifles", icon = "weapon_as_ak47", icontype = "killicon" },
	
};

GM.PrimaryWeapons = {

		weapon_as_spas12 =
		{
			class = "SPAS-12",
			gtype = "shotgun",
			model = "models/weapons/w_shotgun.mdl",
			description = "A shotgun."
		},
	
		weapon_as_xm1014 =
		{
			class = "M4 Super 90",
			gtype = "shotgun",
			model = "models/weapons/w_shot_xm1014.mdl",
			description = "An automatic shotgun",
		},
		
		weapon_as_mp7 =
		{
			class = "MP7",
			gtype = "smg",
			model = "models/weapons/w_smg1.mdl",
			description = "An SMG",
		},
		
		weapon_as_ak47 =
		{
			class = "AK-47",
			gtype = "assault",
			model = "models/weapons/w_rif_ak47.mdl",
			description = "Automatic assault rifle"
		},
		
		weapon_as_m4carbine =
		{
			class = "M4A1 Carbine",
			gtype = "assault",
			model = "models/weapons/w_rif_m4a1.mdl",
			description = "Automatic assault rifle with attachable silencer"
		}
		
	};
	
if( CLIENT ) then
	as_cl_primaryweapon = CreateClientConVar( "as_cl_primaryweapon", "random", true, true );
end
