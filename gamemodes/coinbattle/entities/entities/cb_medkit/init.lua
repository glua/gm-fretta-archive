
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	
	self.dt.HScale = math.Rand(1,3)
	
	local model
	if self.dt.HScale == 1 then
		model = "models/healthvial.mdl"
	else
		model = "models/Items/HealthKit.mdl"
	end
	
	self:SetModel(model)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:PhysicsInitBox(Vector(-16,-16,-16),Vector(16,16,16))
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetCollisionBounds(Vector(-24,-24,-24), Vector(24,24,24))
	self:SetTrigger(true)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Sleep()
	end
	
	self.RespawnOnRemove = true
	
	self.PickupSound = Sound("items/medshot4.wav")
	self:EmitSound("items/spawn_item.wav",75,100)
	
end

function ENT:Use( entity, caller )
	
	if (not entity:IsPlayer()) or (self.TakeOnce) or (entity:Health() >= entity:GetMaxHealth()) or (entity:GetCoins() < self.dt.HScale) then return end
	
	self.TakeOnce = true
	
	self:DoTake(entity)
	
end

function ENT:DoTake(ply)
	
	ply:SetHealth(math.Clamp(ply:Health()+(21*self.dt.HScale), 0, ply:GetMaxHealth()))
	ply:AddCoins(-self.dt.HScale)
	
	GAMEMODE:UpdateScores()
	
	self:EmitSound(self.PickupSound,75,100)
	self:Remove()
	
end

function ENT:CompleteRemove()
	
	self.RespawnOnRemove = false
	self:Remove()
	
end

function ENT:OnRemove()
	
	if self.RespawnOnRemove then
		timer.Simple(10,function(pos)
			local ent = ents.Create("cb_medkit")
			ent:SetPos(pos)
			ent:Spawn()
		end,self:GetPos())
	end
	
end