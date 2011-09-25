
local CLASS = {}

CLASS.DisplayName			= "Gangster"
CLASS.WalkSpeed 			= 200
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 250
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = false
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.PlayerModel           = { Model( "models/player/group03/male_01.mdl" ),
Model( "models/player/group03/male_02.mdl" ),
Model( "models/player/group03/male_03.mdl" ),
Model( "models/player/group03/male_04.mdl" ),
Model( "models/player/group03/male_05.mdl" ),
Model( "models/player/group03/male_06.mdl" ),
Model( "models/player/group03/male_07.mdl" ),
Model( "models/player/group03/male_08.mdl" ),
Model( "models/player/group03/male_09.mdl" ) }

CLASS.Weapons               = { "gta_mac10", "gta_glock18", "gta_deagle", "gta_galil", "gta_ak47" }

function CLASS:Loadout( pl )

	pl:Give( ( pl:GetCarriedWeapon() or table.Random( self.Weapons ) ) )
	
end

function CLASS:OnKeyPress( pl, key )

	if key == IN_USE and SERVER then
		pl:ExitCar()
	end

end

function CLASS:OnDeath( pl, attacker, dmginfo )

	pl:SetCarriedWeapon()

end

player_class.Register( "Gangster", CLASS )