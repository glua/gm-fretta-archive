local CLASS = {}

CLASS.Base 				= "SniperCommon"
CLASS.DisplayName		= "Standard Sniper"
CLASS.Description       = "Primary weapon: Sniper Rifle\nSecondary Weapon: Pistol\nUtilities: Translocator"

function CLASS:Loadout( pl )

	pl:Give( "sniper_normal" )
	pl:Give( "firearm_p228" )
	pl:Give( "weapon_translocator" )

end

player_class.Register( "NormalSniper", CLASS )

local CLASS ={}
CLASS.Base 				= "SniperCommon"
CLASS.DisplayName		= "Stealth Sniper"
CLASS.Description       = "Primary weapon: Silenced Sniper Rifle\nSecondary Weapon: Pistol\nUtilities: Camouflage"

function CLASS:Loadout( pl )

	pl:Give( "firearm_p228" )
	pl:Give( "sniper_stealth" )

end

player_class.Register( "StealthSniper", CLASS )

local CLASS ={}
CLASS.Base 				= "SniperCommon"
CLASS.DisplayName		= "Full Auto Sniper"
CLASS.Description       = "Primary weapon: Automatic Sniper Rifle\nSecondary Weapon: Pistol\nUtilities: Translocator"

function CLASS:Loadout( pl )

	pl:Give( "sniper_auto" )
	pl:Give( "firearm_p228" )
	pl:Give( "weapon_translocator" )

end

player_class.Register( "AutoSniper", CLASS )

local CLASS ={}
CLASS.Base 				= "SniperCommon"
CLASS.DisplayName		= "Laser Designator"
CLASS.Description       = "Primary weapon: Laser Designator\nSecondary Weapon: SMG\nUtilities: Translocator"

function CLASS:Loadout( pl )

	pl:Give( "weapon_laser" )
	pl:Give( "firearm_mp5" )
	pl:Give( "weapon_translocator" )

end

player_class.Register( "LaserSniper", CLASS )

local CLASS ={}
CLASS.Base 				= "SniperCommon"
CLASS.DisplayName		= "Railgunner"
CLASS.Description       = "Primary weapon: Railgun\nSecondary Weapon: Pistol\nUtilities: Translocator"

function CLASS:Loadout( pl )

	pl:Give( "sniper_railgun" )
	pl:Give( "firearm_p228" )
	pl:Give( "weapon_translocator" )

end

player_class.Register( "RailgunSniper", CLASS )