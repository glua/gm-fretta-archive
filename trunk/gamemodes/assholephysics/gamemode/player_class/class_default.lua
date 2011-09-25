
local CLASS = {}

CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 250
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100

function CLASS:Loadout( pl )

	pl:Give( "weapon_bar" )
	pl:Give( "weapon_tractorbeam" )
	
end

function CLASS:Think( pl )

	if pl.ComboTime and pl.ComboTime < CurTime() then
	
		pl.ComboTime = nil
		pl:ComboAward()
	
	end

end

function CLASS:OnDeath( pl )

	if pl:GetCombo() > 1 then
	
		for i = 1, pl:GetCombo() do
			
			pl:DropCash()
			
		end
		
	end
	
end

player_class.Register( "Player", CLASS )