local CLASS = {}
 
CLASS.DisplayName			= "Default Class"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.6
CLASS.JumpPower				= 200
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= true
CLASS.CanUseFlashlight      = false
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.RespawnTime           = 0 // 0 means use the default spawn time chosen by gamemode
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= true // Automatically avoid players that we're no colliding
CLASS.Selectable			= false // When false, this disables all the team checking

function CLASS:OnSpawn( pl )

	//pl:ConCommand("ss_thirdperson 1")

	local pl_player = pl
	//pl:SetStepSize(500)
	timer.Create("bgmusictimer", 5, 1, function() //Hacky and needs to be fixed
		bgmusic = CreateSound( pl_player, Sound("sam/music/smw_lvl2_loop1.mp3") )
		bgmusic:Play( 2, 100 )
	end )
	
end
 
function CLASS:OnDeath( pl )

	//pl:ConCommand("ss_thirdperson 0")

	//bgmusic = CreateSound( pl, Sound("sam/music/smw_lvl2.mp3") )
	bgmusic:Stop( 2, 100 )
	
end
 
player_class.Register( "Default", CLASS )