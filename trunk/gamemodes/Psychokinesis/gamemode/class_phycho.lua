
local CLASS = {}

CLASS.DisplayName			= "Default Class"
CLASS.WalkSpeed 			= 600
CLASS.CrouchedWalkSpeed 	= 0.6
CLASS.RunSpeed				= 400
CLASS.DuckSpeed				= 0.1
CLASS.JumpPower				= 250
CLASS.PlayerModel			= "models/player/breen.mdl"
CLASS.DrawTeamRing			= true
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
CLASS.FullRotation			= false // Allow the player's model to rotate upwards, etc etc

function CLASS:Loadout( pl )

	pl:GiveAmmo( 1,	"Pistol", 		true )
	pl:Give( "PsychokinesisGMGun" )

end

function CLASS:OnSpawn( pl )
util.PrecacheSound("weapons/knife/knife_hit1.wav")
end

function CLASS:OnDeath( pl, attacker, dmginfo )
pl:EmitSound(Sound("weapons/knife/knife_hit1.wav"))
end

function CLASS:Think( pl )
end

function CLASS:Move( pl, mv )
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

function CLASS:ShouldDrawLocalPlayer( pl )
	return false
end

function CLASS:CalcView( ply, origin, angles, fov )
end

player_class.Register( "Default", CLASS )

local CLASS = {}
CLASS.DisplayName			= "Spectator Class"
CLASS.DrawTeamRing			= false
CLASS.PlayerModel			= "models/player.mdl"

function CLASS:Loadout( pl )

end

player_class.Register( "Spectator", CLASS )