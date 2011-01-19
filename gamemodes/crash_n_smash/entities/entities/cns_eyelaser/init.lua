
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

ENT.Player = nil

function ENT:Initialize()

	self:SetHitPos( self.Entity:GetPos() )
	self.Entity:DrawShadow( false )
	
end

function ENT:Think()


	if not ValidEntity(self:GetOwner()) then
		self:Remove()
		return
	end

	local owner = self:GetOwner()
	local trace = owner:GetEyeTraceNoCursor( )

	self:SetHitPos( trace.HitPos )
	
	if ValidEntity(trace.Entity) then
		
		if trace.Entity:IsPlayer() and trace.Entity:Team() != self:GetOwner():Team() then
			trace.Entity:SetVelocity( owner:GetAimVector() * 800 )
		elseif table.HasValue(propClasses, trace.Entity:GetClass()) and trace.Entity:TeamSide() != self:GetOwner():Team() then
			local phys = trace.Entity:GetPhysicsObject()
			if ValidEntity(phys) then
				phys:ApplyForceOffset( owner:GetAimVector() * 3000, self:GetHitPos() )
			end
		end
		
	end
	
end
