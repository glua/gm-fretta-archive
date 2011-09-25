
local CLASS = {}

CLASS.DisplayName			= "Default Class"
CLASS.WalkSpeed 			= 400
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 400
CLASS.DuckSpeed				= 0.6
CLASS.JumpPower				= 200
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

function CLASS:Loadout( pl )

	pl:Give( "weapon_physcannon" )

end

function CLASS:OnSpawn( pl )

	-- Spawn sounds
	local sound = table.Random( GAMEMODE.SpawnSounds )
	pl:EmitSound( sound, 100, math.random( 80, 120 ) )

end

function CLASS:OnDeath( pl, attacker, dmginfo )

	-- When a player dies, fvox makes a witty comment
	local sound = table.Random( GAMEMODE.DeathSounds )
	pl:EmitSound( sound, 100, math.random( 80, 120 ) )

end

player_class.Register( "Default", CLASS )
