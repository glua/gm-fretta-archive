
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    
	self.Entity:SetModel( "models/weapons/w_models/w_stickybomb.mdl" )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.InactiveTime = CurTime()+1

	local skin = 0
	if self:Team() == TEAM_CYAN then
		skin = 1
	end
	self:SetSkin(skin)
    
end

function ENT:SetTeam(int)
	self.dt.CurTeam = int
end

function ENT:DoExplode(delay)
	
	delay = delay or 0
	
	self:EmitSound("npc/roller/mine/combine_mine_deactivate1.wav")
	
	timer.Simple(delay,
		function(self)
			if self:IsValid() and self:GetOwner():IsValid() then
				
				util.BlastDamage(self, self:GetOwner(), self:GetPos(), 160, 50)
				local ED = EffectData()
				ED:SetOrigin(self:GetPos())
				util.Effect("explosion",ED)
				
			end
			self:Remove()
		end,
		self
	)
	
end

function ENT:PhysicsCollide( data, physobj )
	
	if self.HitOnce then return end
	
	local trace = {}
	trace.start = self:GetPos()
	trace.endpos = data.HitPos + (data.HitPos-self:GetPos())*4
	trace.filter = {self}
	trace.mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceHull(trace)
	
	if data.HitEntity:IsWorld() and !tr.HitSky then
		physobj:EnableMotion(false)
	end
	
end

function ENT:Think()
		
	if CurTime() >= self.InactiveTime then
		for _,ply in pairs(ents.FindInSphere(self:GetPos(),80)) do
			if (ply:IsPlayer()) and not self.HitOnce and not(self:Team() == ply:Team()) then
				self.HitOnce = true
				self:DoExplode(0.4)
			end
		end
	end
	
	self:NextThink(CurTime()+0.1)
	return true
	
end