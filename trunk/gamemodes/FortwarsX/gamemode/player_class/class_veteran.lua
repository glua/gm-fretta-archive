
local CLASS = {}

CLASS.Base 					= "FWBase"
CLASS.DisplayName			= "Veteran"
CLASS.Description       	= "Use this class for killing enemies and defending"
CLASS.WalkSpeed 			= 280
CLASS.RunSpeed				= 370
CLASS.JumpPower				= 200
CLASS.MaxHealth				= 150
CLASS.StartHealth			= 150

CLASS.PlayerModel	= "models/player/odessa.mdl"

function CLASS:Loadout( pl )

	pl:Give( "weapon_fw_m4" )
	pl:Give( "weapon_fw_glock" )
	
	pl:GiveAmmo( 175, "SMG1" )
	pl:GiveAmmo( 315, "Pistol" )
	
end

player_class.Register( CLASS.DisplayName, CLASS )