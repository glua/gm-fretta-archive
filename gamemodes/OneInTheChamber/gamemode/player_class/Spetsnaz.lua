local CLASS = {}
 
CLASS.DisplayName			= "Spetsnaz"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 250
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 200
CLASS.PlayerModel			= "models/player/arctic.mdl"
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.RespawnTime           = 0 // 0 means use the default spawn time chosen by gamemode
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= false
CLASS.AvoidPlayers			= false // Automatically avoid players that we're no colliding
CLASS.Selectable			= true // When false, this disables all the team checking
CLASS.FullRotation			= false // Allow the player's model to rotate upwards, etc etc
 
function CLASS:Loadout( pl )
end
 
function CLASS:OnSpawn( pl )
	pl:Give("weapon_oic_pistol_v2")
	pl:Give("weapon_oic_knife")
		pl:ConCommand("play OIC/RoundStart/Spetsnaz_v2.mp3")
end
 
function CLASS:OnDeath( pl, attacker, dmginfo )
	attacker:GiveAmmo( 1,	"Pistol", 		true )
	attacker:EmitSound("OIC/Generic/Rangers/TangoDown.mp3",100 ,100)
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
 
player_class.Register( "Spetsnaz", CLASS )
 