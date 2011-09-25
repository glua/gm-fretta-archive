include('shared.lua')

function ENT:Initialize()

	self.DripTime = 0

end

function ENT:Think()

	local dist = LocalPlayer():GetPos():Distance(self:GetPos())

	if dist < self:GetNWInt("Radius",100) then
	
		local scale = math.Clamp(  1 - ( dist / self:GetNWInt("Radius",100) ), 0, 1 )
		
		if MotionBlur < scale * 1.0 then
		
			ViewWobble = scale * 0.5
			MotionBlur = scale * 0.9
			Sharpen = scale * 7.5
			ColorModify[ "$pp_colour_mulg" ] = scale * 3.0
			
		end
	
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 100
		dlight.g = 255
		dlight.b = 100
		dlight.Brightness = 3
		dlight.Decay = 4096
		dlight.size = self:GetNWInt("Radius",100) * 2
		dlight.DieTime = CurTime() + 0.2
	end
	
	local ent = self:GetNWEntity("Target",nil)
	
	if ent and ent:IsValid() and self.DripTime < CurTime() then
	
		if ent:IsPlayer() and not ent:Alive() then
			return
		end
	
		self.DripTime = CurTime() + .2
	
		local offset = ent:GetPos()
		local low, high = ent:WorldSpaceAABB()

		local num = ent:BoundingRadius()
		num = math.Clamp( num / 10, 1, 50 )
		
		local emitter = ParticleEmitter( offset )
		
		for i=1, num do
		
			local pos = Vector( math.Rand(low.x,high.x), math.Rand(low.y,high.y), math.Rand(low.z,high.z) )
			
			local particle = emitter:Add( "effects/yellowflare", pos )
			particle:SetVelocity( Vector(0,0,0) )
			particle:SetColor( 50, 255, 50 )
			particle:SetDieTime( math.Rand( 1.0, 2.0 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(2,4) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(0,360) )
			particle:SetRollDelta( math.Rand(-1,1) )
			
			particle:SetAirResistance( 150 )
			particle:SetGravity( Vector( 0, 0, math.random(-300,-50) ) )
			particle:SetCollide( true )
			
		end
		
		emitter:Finish()
	
	end
end

function ENT:Draw()
	
end

