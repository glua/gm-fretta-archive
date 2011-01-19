
local CLASS = {}

CLASS.Base 					= "FWBase"
CLASS.DisplayName			= "Demolition Guy"
CLASS.Description       	= "Use this class for destroying props and defusing bombs"
CLASS.WalkSpeed 			= 230
CLASS.RunSpeed				= 310
CLASS.JumpPower				= 170
CLASS.MaxHealth				= 120
CLASS.StartHealth			= 120

CLASS.PlayerModel	= "models/player/guerilla.mdl"

function CLASS:Loadout( pl )
	
	pl:Give( "weapon_fw_deagle" )
	pl:Give( "weapon_fw_c4" )
	pl:Give( "weapon_crowbar" )
	
	pl:GiveAmmo( 80, "pistol" )
	pl:GiveAmmo( 7, "Grenade" )
	
end

player_class.Register( CLASS.DisplayName, CLASS )