
local CLASS = {}

CLASS.DisplayName			= "Human"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 200
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100

function CLASS:Loadout( pl )

	pl:Give( "weapon_propkilla" )
	
end

function CLASS:OnDeath( pl )

end

player_class.Register( "Human", CLASS )