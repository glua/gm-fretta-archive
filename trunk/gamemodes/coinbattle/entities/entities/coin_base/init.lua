
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	
	self:SetModel("models/props_junk/PopCan01a.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:PhysicsInitBox(Vector(-16,-16,-16),Vector(16,16,16))
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetCollisionBounds(Vector(-24,-24,-24), Vector(24,24,24))
	self:SetTrigger(true)
	
	self:DrawShadow(false)
	self:SetMaterial("models/shiny")
	self:SetColor(unpack(self.Metal))
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		
		local vel = VectorRand() * 250
		vel.z = 400
		
		phys:Wake()
		phys:SetDamping(0, 100)
		phys:SetVelocity(vel)
		
	end
	
	self.PickupSound = Sound("coinbattle/smb_coin.wav")
	self.InactiveTime = CurTime() + 1
	self.RemoveTime = CurTime() + 60
	
end

function ENT:Touch( entity )
	
	if (not entity:IsPlayer() or self.InactiveTime > CurTime() or self.TakeOnce) then return end
	
	self.TakeOnce = true
	
	self:DoTake(entity)
	
end

function ENT:Think()
	
	if self.RemoveTime <= CurTime() then
		
		self:Remove()
		
	end

end

function ENT:DoTake(ply)
	
	ply:AddCoins(self.Cost)
	GAMEMODE:UpdateScores()
	
	self:EmitSound(self.PickupSound,75,98+2*(1/self.CoinScale))
	self:Remove()
	
end