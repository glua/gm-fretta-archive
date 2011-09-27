AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

--ENT.DieTime = 0
ENT.Exploded = false
ENT.Owner = nil

ENT.Damage = 20

local splashSounds = {{Sound("npc/antlion_grub/squashed.wav"),.7},{Sound("player/footsteps/mud1.wav"),1},{Sound("player/footsteps/mud2.wav"),1}}

PrecacheParticleSystem("mt_projectile_trail_h")
PrecacheParticleSystem("mt_projectile_trail_m")
PrecacheParticleSystem("mt_projectile_splarkles_h")
PrecacheParticleSystem("mt_projectile_splarkles_m")
resource.AddFile("materials/sprites/mt-proj-glow.vmt")
resource.AddFile("materials/sprites/mt-proj-splash.vmt")
--resource.AddFile("materials/sprites/mt-proj-splash-warp.vmt")

function ENT:Initialize()
	self.Entity:SetModel("models/items/combine_rifle_ammo01.mdl")
	self.Entity:PhysicsInitSphere(4,"default_silent")
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	local phy = self.Entity:GetPhysicsObject()
	if phy:IsValid() then
		phy:EnableGravity(false)
		phy:EnableDrag(false)
	end
	self.Entity:DrawShadow(false)
end

function ENT:Think()
	local phy = self.Entity:GetPhysicsObject()
	if phy:IsValid() then phy:ApplyForceCenter(self.Entity:GetAngles():Up() * (50 - self.Damage)) end
	
	self.Entity:NextThink(CurTime() + 0.08)
	return true
end

function ENT:PhysicsCollide(data,phys)
	local hAng = data.HitNormal:Angle()
	hAng:RotateAroundAxis(hAng:Right(),90)

	self:Explode(data.HitPos - data.HitNormal,hAng)
end

function ENT:Explode(pos,ang)
	if self.Exploded then return end
	
	for _, pl in pairs(player.GetAll()) do
		local trd = {}
		trd.start = pos
		trd.endpos = pos + (pl:LocalToWorld(pl:OBBCenter()) - pos):GetNormal()*(60 + self.Damage)
		trd.filter = {self}
		local tr = util.TraceLine(trd)
		if tr.Hit and tr.Entity == pl then
			pl:TakeDamage(self.Damage,self:GetOwner(),self)
		end
		--self:GetOwner():TraceHullAttack(pos, (pl:LocalToWorld(pl:OBBCenter()) - pos):GetNormal()*(30 + self.Damage),Vector()*-10,Vector()*10,self.Damage/4,DMG_PLASMA,100,true)
	end

	local ed = EffectData()
	ed:SetOrigin(pos)
	ed:SetNormal(ang:Up())
	ed:SetAngle(ang)
	ed:SetAttachment(self.ParticleSuffix == "h" and 0 or 1)
	ed:SetMagnitude((self.Damage - 20) / 10)
	util.Effect("mutant_impact",ed)
	
	self.Exploded = true
	local s = splashSounds[math.random(1,#splashSounds)]
	self.Entity:EmitSound(s[1],100*s[2],70)

	self:Fire("kill",0,0)
end
