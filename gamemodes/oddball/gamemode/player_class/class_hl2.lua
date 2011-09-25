local CLASS = {}

CLASS.DisplayName			= "HL2"
CLASS.WalkSpeed 			= 265
CLASS.CrouchedWalkSpeed 		= 0.5
CLASS.RunSpeed				= 325
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 200
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight     		= true

function CLASS:OnSpawn( ply )
	ply:Give("ins_smg1")
	ply:Give("ins_pistol")
	ply:Give("weapon_crowbar")
	GAMEMODE:DoGod(ply,self.StartHealth)
end

player_class.Register( CLASS.DisplayName, CLASS )