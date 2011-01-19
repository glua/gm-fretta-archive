
local CLASS = {}

CLASS.Base 					= "FWBase"
CLASS.DisplayName			= "Scout"
CLASS.Description       	= "Use this class for grabbing the flag"
CLASS.WalkSpeed 			= 380
CLASS.RunSpeed				= 520
CLASS.JumpPower				= 250
CLASS.MaxHealth				= 60
CLASS.StartHealth			= 60

CLASS.PlayerModel	= "models/player/group03/male_07.mdl"

function CLASS:Loadout( pl )
	
	pl:Give( "weapon_fw_mac10" )
	pl:Give( "weapon_fw_fiveseven" )
	pl:Give( "weapon_physcannon" )
	
	pl:GiveAmmo( 125, "SMG1" )
	pl:GiveAmmo( 250, "Pistol" )
	
end

player_class.Register( CLASS.DisplayName, CLASS )