////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Default      Class                         //
////////////////////////////////////////////////

local CLASS = {}

CLASS.DisplayName			= "Default"
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.DuckSpeed				= 0.2
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true

function CLASS:Loadout( pl )
end

player_class.Register( "Default", CLASS )