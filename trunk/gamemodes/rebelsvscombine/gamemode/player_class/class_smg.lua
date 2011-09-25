
local CLASS = {}
 
CLASS.Base 					= "default"
CLASS.DisplayName			= "smgman"
CLASS.WalkSpeed 			= 400
CLASS.RunSpeed				= 600
CLASS.JumpPower				= 300
CLASS.MaxHealth				= 90
CLASS.StartHealth			= 90
CLASS.StartArmor			= 15

function CLASS:Loadout( pl )

	pl:Give( "weapon_smg1" )
	pl:Give( "weapon_pistol" )
	pl:Give( "weapon_crowbar" )
	pl:GiveAmmo( 90, "pistol", true )
	pl:GiveAmmo( 360, "smg1", true )
	pl:GiveAmmo( 3, "SMG1_Grenade", true )

end

player_class.Register( "smgman", CLASS )
