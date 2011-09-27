local CLASS = {}

CLASS.WalkSpeed 			= 200
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 200
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 120
CLASS.StartHealth			= 120
CLASS.StartArmor			= 0
CLASS.RespawnTime           = 0 // 0 means use the default spawn time chosen by gamemode
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= true // Automatically avoid players that we're no colliding
CLASS.Selectable			= true // When false, this disables all the team checking
CLASS.FullRotation			= false // Allow the player's model to rotate upwards, etc etc

function CLASS:Loadout (pl)
	
end

function CLASS:OnSpawn (pl)
	pl.LoadedOut = false
	if pl:SteamID() != "BOT" then
		umsg.Start ("lnl_lo_menu", pl)
		umsg.End()
		--the rest is handled in server/player_respawn
	else
		GAMEMODE:LoadoutPlayerFromMenu (pl)
	end
	pl:Freeze()
end

function CLASS:OnDeath (pl, attacker, dmginfo)
end

function CLASS:Think (pl)
end

function CLASS:Move (pl, mv)
end

function CLASS:OnKeyPress (pl, key)
end

function CLASS:OnKeyRelease (pl, key)
end

function CLASS:ShouldDrawLocalPlayer (pl)
	return false
end

function CLASS:CalcView (ply, origin, angles, fov)
end

player_class.Register ("Default", CLASS)