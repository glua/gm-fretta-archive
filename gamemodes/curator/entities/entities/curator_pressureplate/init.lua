
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
	end
	self.Num = 10
	
	self:TemporarilyDisable()
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON) -- to replace ShouldCollide
end

function ENT:Think()
	
end

function ENT:OnRemove()
	if self.Item and self.Item.OnRemove then self.Item:OnRemove() end
end
 
function ENT:Touch(ent)
	if (self.Active and ent:IsValid() and ent:IsPlayer() and ent ~= GAMEMODE.Curator) then
		self.Num = self.Num + 1
		if self.Num >= 10 then
			ent:SetNWInt("Detection",math.Clamp(ent:GetNWInt("Detection")+100,0,1000))
			self.Num = 0
		end
	end
end 

function ENT:ReActivate()
	self.Active = true
	self:EmitSound("HL1/fvox/activated.wav",SNDLVL_VOICE,100)
end

function ENT:DeActivate()
	self.Active = false
end 

function ENT:TemporarilyDisable(num)
	self:DeActivate()
	self.timer = timer.Create(self:EntIndex().."Reenable",num or 5,1,function() self:ReActivate() end)
end 