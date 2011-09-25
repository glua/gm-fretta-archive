local CLASS = {}

CLASS.DisplayName			= "Shotgunner"
CLASS.WalkSpeed 			= 275
CLASS.CrouchedWalkSpeed 		= 0.5
CLASS.RunSpeed				= 350
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight     		= true

function CLASS:OnSpawn( ply )
	ply:Give("ins_m3")
	ply:Give("ins_glock")
	ply:Give("weapon_crowbar")
	ply:Give("weapon_frag")
	GAMEMODE:DoGod(ply,self.StartHealth)
end

player_class.Register( CLASS.DisplayName, CLASS )