
local CLASS = {}
 
CLASS.Base 					= "default"
CLASS.DisplayName			= "medic"

CLASS.MaxHealth				= 120
CLASS.StartHealth			= 120
CLASS.StartArmor			= 20

function CLASS:Loadout( pl )

	pl:Give( "weapon_shotgun" )
	pl:Give( "weapon_frag" )
	pl:Give( "weapon_crowbar" )
	pl:Give( "weapon_firstaid" )
	pl:GiveAmmo( 24, "Buckshot", true )
	pl:GiveAmmo( 1, "Grenade", true )

end

player_class.Register( "medic", CLASS )
