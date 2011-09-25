include('shared.lua')

function ENT:Initialize()

	self.FreezeTime = nil
	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	
end

function ENT:OnRemove()

	if self.Emitter then
		self.Emitter:Finish()
	end

end

function ENT:Think()
	
	if not self.Entity:GetNWBool( "Frozen", false ) and self.Entity:GetVelocity():Length() > 1 then
	
		for i=1, 10 do
			
			local pos = self.Entity:GetVelocity() * ( i * -0.005 )
			
			local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Entity:GetPos() + pos )
			particle:SetVelocity( VectorRand() * 10 )
			particle:SetColor( 50, 150, 255 )
			particle:SetDieTime( math.Rand( 2.5, 5.0 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(10,20) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(-180,180) )
			particle:SetRollDelta( math.Rand(-2,2) )
			
			particle:SetAirResistance( 150 )
			particle:SetGravity( Vector(0,0,0) )
			
		end
	end

	if self.Entity:GetNWBool( "Frozen", false ) and not self.FreezeTime then
	
		self.FreezeTime = CurTime() + 5
		
	elseif self.FreezeTime then
	
		self.TimeScale = CurTime() / self.FreezeTime
		
		local particle = self.Emitter:Add( "effects/yellowflare", self.Entity:GetPos() + VectorRand() * 250 )
		particle:SetVelocity( Vector(0,0,0) )
		particle:SetColor( 150, 200, 255 )
		particle:SetDieTime( math.Rand(1.0,2.0) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(1,5) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand(-180,180) )
		particle:SetRollDelta( math.Rand(-2,2) )
			
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector(0,0,math.random(50,100)) )

	end

	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 200
		dlight.g = 200
		dlight.b = 255
		dlight.Brightness = 3
		dlight.Decay = 512
		dlight.size = 512 * math.Rand( 0.5, 1.0 )
		dlight.DieTime = CurTime() + 0.2
		
	end
	
end

local matFlare = Material( "effects/blueflare1" )

function ENT:Draw()

	render.SetMaterial( matFlare )
	
	local size = math.random( 30, 60 )
	
	if self.TimeScale then
		size = size + 50 * self.TimeScale
	end
	
	render.DrawSprite( self.Entity:GetPos(), size, size, Color( 150, 200, 255, 255 ) ) 
	
end

