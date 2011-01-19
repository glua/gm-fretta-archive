
local CLASS = {}

CLASS.DisplayName			= "Survivor"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100

function CLASS:Loadout( pl )

	pl:SetCarrier( false )
	pl:Give( "weapon_manspuncher" )
	
end

function CLASS:OnDeath( pl )

	pl:SetTeam( TEAM_DEAD )

end

player_class.Register( "Survivor", CLASS )