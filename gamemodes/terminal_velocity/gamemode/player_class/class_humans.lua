
local CLASS = {}

CLASS.DisplayName			= "Base Human Class"
CLASS.DrawTeamRing			= true
CLASS.Human                 = true

function CLASS:Loadout( pl )

	pl:Give( "weapon_heatseeker" )
	pl:Give( "weapon_dropbomb" )
	pl:Give( "weapon_flak" )
	pl:Give( "weapon_twinmachinegun" )
	
end

player_class.Register( "Base Human", CLASS )

local CLASS = {}

CLASS.DisplayName			= "Flak Trooper"
CLASS.StartHealth           = 200
CLASS.MaxHealth             = 200
CLASS.PlayerModel			= "models/player/police.mdl"

function CLASS:Loadout( pl )

	pl:Give( "weapon_flak" )
	
end

player_class.Register( "Flak Trooper", CLASS )