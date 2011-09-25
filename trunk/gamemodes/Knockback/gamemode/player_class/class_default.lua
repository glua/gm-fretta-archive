
local CLASS = {}

CLASS.DisplayName			= "Default"
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.DuckSpeed				= 0.2
CLASS.StartHealth			= 1 //Smash bros-style knockback meter!
CLASS.MaxHealth				= 999 //With our damage system this doesn't really do anything
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true

function CLASS:Loadout( pl )
	pl:Give("weapon_knockback");
	pl:Give("weapon_crowbar");
end

player_class.Register( "Default", CLASS )