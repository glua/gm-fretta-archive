
local CLASS = {}

CLASS.DisplayName			= "Combine"
CLASS.PlayerModel			= Model( "models/Player/combine_soldier.mdl " )
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

	pl:Give( "weapon_stunstick" )
	pl:GiveAmmo(100, "pistol")
	pl:GiveAmmo(100, "SMG1")
	pl:GiveAmmo(100, "ar2")
	pl:GiveAmmo(100, "357")
	pl:GiveAmmo(50, "Buckshot")
	pl:GiveAmmo(2, "grenade")
	
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

player_class.Register( "Combine", CLASS )