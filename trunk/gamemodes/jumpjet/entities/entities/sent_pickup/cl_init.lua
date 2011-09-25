
include('shared.lua')

function ENT:Initialize()
	
	self.Entity:SetCollisionBounds( Vector( -30, -30, -30 ), Vector( 30, 30, 0 ) )
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,-500)
	trace.filter = self.Entity
	local tr = util.TraceLine( trace )
	
	self.GroundPos = tr.HitPos
	self.Size = 1
	self.Material = nil
	
end

function ENT:Think()

	if self.Entity:GetActiveTime() <= CurTime() and not self.Material then 

		local power = powerup.GetByID( self.Entity:GetNWInt( "PickupType", 1 ) )
		self.Material = power.Material
	
	elseif self.Entity:GetActiveTime() > CurTime() then
	
		self.Material = nil
	
	end

end

function ENT:OnRemove()

end

function ENT:Draw()

	if self.Entity:GetActiveTime() > CurTime() or not self.Material then return end
	
	self.Entity:SetModelScale( Vector( 1.0, 1.0, 1.35 ) )
	self.Entity:DrawModel()
	
	render.SetMaterial( Material( self.Material ) )
	render.DrawQuadEasy( self.GroundPos + Vector(25,0,30), Vector(1,0,0), 45, 45, Color( 255, 255, 255, 125 + math.sin( CurTime() * 3 ) * 125 ) )
	
end
