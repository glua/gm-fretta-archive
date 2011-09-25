
local CLASS = {}

CLASS.DisplayName			= "Default Class"
CLASS.WalkSpeed 			= 235
CLASS.CrouchedWalkSpeed 	= 0.65
CLASS.RunSpeed				= 480
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 250
CLASS.DrawTeamRing			= true
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.Description			= "";
CLASS.Selectable			= false

function CLASS:Loadout( pl )

	pl:Give( "weapon_real_cs_knife" )
	
end

function CLASS:OnSpawn( pl )
	for k,v in pairs( Levels ) do
		if k == pl:Frags() then
			local gun = v
			pl:Give( gun )
			pl:SelectWeapon( gun )
		end
	end
end

player_class.Register( "Default", CLASS )