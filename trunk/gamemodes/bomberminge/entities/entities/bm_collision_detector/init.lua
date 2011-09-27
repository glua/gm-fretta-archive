
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	if not ValidEntity(self:GetParent()) then
		self:Remove()
		return
	end
	
	self:SetModel(self:GetParent():GetModel())
	
	local min, max = Vector(-22, -22, -22), Vector(22, 22, 22)
	
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self:SetTrigger(true)
	
	self:SetOwner(self:GetParent())
	
	self.NextLockCollisions = CurTime() + 0.1
end

function ENT:Think()
	if self.NextLockCollisions and CurTime()>self.NextLockCollisions then
		self.NextLockCollisions = nil
		self:LockCollisions()
	end
end

function ENT:LockCollisions()
	self.StartTouch = nil
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		--print("StartTouch", ent)
		if not self.CollidingPlayers then self.CollidingPlayers = {} end
		self.CollidingPlayers[ent] = true
		self:GetOwner():AddCollisionRule(ent, false)
	end
end

function ENT:EndTouch(ent)
	if self.CollidingPlayers and self.CollidingPlayers[ent] then
		--print("EndTouch", ent)
		self.CollidingPlayers[ent] = nil
		self:GetOwner():AddCollisionRule(ent, true)
	end
end
