AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.target = NULL

function ENT:OnTakeDamage()
end

local ang = Angle(0,0,0)

function ENT:PhysicsCollide(data,physobj)
	ParticleEffect("gtv_seeker_impact",self:GetPos(),ang,Entity(0))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetPos(data.HitPos)
	self:Fire("Kill",0,0.1)
end 

function ENT:StartTouch()
end

function ENT:EndTouch()
end

local ang = Angle(0,0,0)

function ENT:Touch(hitent)
	if (hitent:GetSolid() != SOLID_NONE) && (hitent:GetSolid() != SOLID_VPHYSICS) && (hitent != self:GetOwner()) && !self.expl then
		if hitent:IsPlayer() && (hitent != self.Owner) then
			local dmg = DamageInfo()
			dmg:SetDamage(5)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
			dmg:SetDamagePosition(self:GetPos())
			dmg:SetDamageForce(vector_origin)
			dmg:SetDamageType(DMG_ENERGYBEAM)
			hitent:TakeDamageInfo(dmg)
		end
		ParticleEffect("gtv_seeker_impact",self:GetPos(),ang,Entity(0))
		self:Remove()
	end
end

function ENT:Think()
	if self.Created+1 < CurTime() then
		self:Remove()
	end
	local shortestdist = 300
	local pl = player.GetAll()
	local pos = self:GetPos()
	for k,v in ipairs(pl) do
		local dist = v:GetPos():Distance(pos)
		if (v != self:GetOwner()) && (dist < shortestdist) then
			shortestdist = dist
			self.target = v
		end
	end
end	

function ENT:OnRemove()
end