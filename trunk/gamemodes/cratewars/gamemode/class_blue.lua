local CLASS = {}

CLASS.DisplayName			= "Blue"
CLASS.WalkSpeed 			= 350
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 350
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100

function CLASS:Loadout( pl )
	
end

function CLASS:OnDeath( pl, dmginfo )

end
CLASS.PlayerModel = "models/player/barney.mdl"
player_class.Register( "blue", CLASS )