
local CLASS = {}
 
CLASS.Base 					= "default"
CLASS.DisplayName			= "rifleman"
CLASS.WalkSpeed 			= 300
CLASS.RunSpeed				= 500
CLASS.JumpPower				= 200
CLASS.MaxHealth				= 125
CLASS.StartHealth			= 125
CLASS.StartArmor			= 25

function CLASS:Loadout( pl )
 
	pl:Give( "weapon_ar2" )
	pl:Give( "weapon_crowbar" )
	pl:GiveAmmo( 120, "AR2", true )
	pl:GiveAmmo( 3, "AR2AltFire", true )
 
end

player_class.Register( "rifleman", CLASS )
