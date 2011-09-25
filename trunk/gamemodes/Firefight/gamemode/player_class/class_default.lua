local CLASS = {}

CLASS.DisplayName			= "Assault"
CLASS.Description       = "Primary weapon: SMG\nSecondary Weapon: Pistol\nUtilities: Frag Grenades"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 210
CLASS.StartHealth			= 100
CLASS.StartArmor			= 100
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = true

function CLASS:OnSpawn( ply )
end

function CLASS:Loadout( ply )

		--ply:Give("weapon_CrushGun") not included cos its kinda crap
		ply:Give("weapon_smg")
		ply:GiveAmmo(128,"SMG1")
		ply:Give("weapon_pistol")
		ply:GiveAmmo(64, "Pistol")
		ply:Give("weapon_frag")
		ply:GiveAmmo( 4, "Grenade")
end
player_class.Register( "Default", CLASS )
