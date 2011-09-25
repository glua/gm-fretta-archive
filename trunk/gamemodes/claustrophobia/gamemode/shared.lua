
GM.Name 	= "Claustrophobia"
GM.Author 	= "DEADBEEF"
GM.Email 	= ""
GM.Website 	= ""

DeriveGamemode( "fretta" )

GM.Help		= "Tunnel your way towards other players and kill them."
GM.TeamBased = false
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 10
GM.RealisticFallDamage = true

GM.RoundBased = true
GM.RoundLength = 120
GM.GameLength = 20
GM.RoundEndsWhenOneTeamAlive = false

GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false
GM.NoPlayerTeamDamage = false
GM.NoPlayerPlayerDamage = false
GM.NoNonPlayerPlayerDamage = false
GM.TakeFragOnSuicide = false
GM.NoPlayerSuicide = false

GM.PlayerCanNoClip = false
GM.MaximumDeathLength = 10

GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }

local CLASS = {}

CLASS.DisplayName			= "Player"
CLASS.WalkSpeed 			= 400
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 200
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 400
CLASS.DrawTeamRing			= false
CLASS.DrawViewModel			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.RespawnTime           = 0 // 0 means use the default spawn time chosen by gamemode
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= true // Automatically avoid players that we're no colliding
CLASS.Selectable			= true // When false, this disables all the team checking

function CLASS:Loadout( pl )

	pl:GiveAmmo( 255,	"SMG1", 		true )
	pl:Give( "weapon_smg1" )
	pl:Give( "rock_breaker" )

end
player_class.Register( "Default", CLASS )
