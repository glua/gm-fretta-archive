
local CLASS = {}

CLASS.DisplayName			= "Seeker"
CLASS.WalkSpeed 			= 400
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 600
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 200
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

function CLASS:Loadout( pl )

	pl:Give( "has_seekgun" )

end

function CLASS:OnSpawn( pl )

	// Woo materials
	pl:SetColor( 255, 255, 255, 255 )
	pl:SetMaterial( "" )
	pl:UnBlind()

end

player_class.Register( "Seeker", CLASS )
