local CLASS = {}

CLASS.DisplayName			= "Human"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 75
CLASS.RunSpeed				= 400
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 200
CLASS.TeammateNoCollide 	= true

function CLASS:Loadout(pl)
	--pl:Give("mt_weapon_projectile")
	--pl:Give("mt_weapon_beam")
	pl:Give("mt_weapon_projectile")
end

function CLASS:OnSpawn(pl)
	pl:SetHull(Vector(-16,-16,0),Vector(16,16,72))
	pl:SetHullDuck(Vector(-16,-16,0),Vector(16,16,36))
	pl:SetViewOffset(Vector(0,0,64))
	pl:SetViewOffsetDucked(Vector(0,0,24))
	pl:StopParticles()
end

player_class.Register( "Default", CLASS )