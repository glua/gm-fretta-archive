
local CLASS = {}

CLASS.DisplayName			= "Human"
CLASS.WalkSpeed 			= 170
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 250
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0

function CLASS:Loadout( pl )

	pl:GiveAmmo( 1800, "pistol", true )
	pl:Give( "weapon_barrel_killa" )
	pl:SetViewOffset( Vector( 0, 0, 64 ) )
	
end

function CLASS:OnDeath( pl )

	pl:SetTeam( TEAM_BARREL )
	
end

player_class.Register( "Human", CLASS )