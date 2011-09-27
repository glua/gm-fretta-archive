local CLASS = {}
 
CLASS.DisplayName			= "Template class"
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.WalkSpeed 			= 400
CLASS.RunSpeed				= 400
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 200
CLASS.PlayerModel			= "models/player/breen.mdl"
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.CanUseFlashlight      = true
CLASS.RespawnTime           = 0 		-- 0 means use the default spawn time chosen by gamemode.
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= false
CLASS.AvoidPlayers			= false 	-- Automatically avoid players that we're no colliding.
CLASS.FullRotation			= false 	-- Allow the player's model to rotate upwards, etc etc.
CLASS.Selectable			= true 		-- When false, this disables all the team checking.
 
function CLASS:Loadout( pl )
	pl:Give( "weapon_physcannon" )
end
 
function CLASS:OnSpawn( pl )
end
 
function CLASS:OnDeath( pl, attacker, dmginfo )
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
 
player_class.Register( "Template", CLASS )