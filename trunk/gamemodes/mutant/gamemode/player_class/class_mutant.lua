local CLASS = {}

CLASS.DisplayName			= "Mutant"
CLASS.WalkSpeed 			= 280
CLASS.CrouchedWalkSpeed 	= 70
CLASS.RunSpeed				= 360
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 300
CLASS.StartHealth			= 300
CLASS.MaxHealth				= 300

local footThump = Sound("ambient/machines/thumper_hit.wav")

function CLASS:Loadout(pl)
	pl:Give("mt_weapon_projectile")
	--pl:Give("mt_weapon_beam")
	--pl:Give("mt_weapon_melee")
end

function CLASS:OnSpawn(pl)
	pl:SetHull(Vector(-30,-30,0),Vector(30,30,135))
	pl:SetHullDuck(Vector(-20,-20,0),Vector(20,20,67))
	pl:SetViewOffset(Vector(0,0,120))
	pl:SetViewOffsetDucked(Vector(0,0,45))
	ParticleEffectAttach("mt_mutant_flame",PATTACH_POINT_FOLLOW,pl,pl:LookupAttachment("hips"))
	ParticleEffectAttach("mt_mutant_flame",PATTACH_POINT_FOLLOW,pl,pl:LookupAttachment("chest"))
	ParticleEffectAttach("mt_mutant_flame_small",PATTACH_POINT_FOLLOW,pl,pl:LookupAttachment("lefthand"))
	ParticleEffectAttach("mt_mutant_flame_small",PATTACH_POINT_FOLLOW,pl,pl:LookupAttachment("righthand"))
	ParticleEffectAttach("mt_mutant_flame_small",PATTACH_POINT_FOLLOW,pl,pl:LookupAttachment("eyes"))
end

function CLASS:Footstep(ply, pos, foot, sound, volume, rf)
	ply:EmitSound(footThump,40,60)
	util.ScreenShake(pos,math.random(10,20),6,.2,240)
	return true
end

player_class.Register("Mutant", CLASS)
