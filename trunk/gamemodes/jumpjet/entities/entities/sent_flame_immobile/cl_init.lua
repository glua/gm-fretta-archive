include('shared.lua')

function ENT:Initialize()

	self.DieTime = CurTime() + self.LifeTime
	self.TimeScale = 1
	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	self.Positions = {}
	self.ValidPositions = {}
	
	for i = -80, 80 do
	
		if i % 2 == 0 then
		
			local trace = {}
			trace.start = self.Entity:GetPos() + Vector(0,i,100)
			trace.endpos = self.Entity:GetPos() + Vector( 0, i, -200 )
			trace.mask = MASK_SOLID_BRUSHONLY
			
			local tr = util.TraceLine( trace )
			
			if tr.Hit then
			
				self.Positions[i] = tr.HitPos
				table.insert( self.ValidPositions, i )
				
			end
		
		end
	
	end
	
end

function ENT:OnRemove()
	
	if self.Emitter then
	
		self.Emitter:Finish()
	
	end

end

function ENT:Think()

	self.TimeScale = ( self.DieTime - CurTime() ) / self.LifeTime

	local vec = VectorRand()
	vec.x = math.Rand(-0.2,0.2)
	vec.z = 0
	
	local scale = 1 - ( self.Entity:GetPos() + vec * 30 ):Distance( self.Entity:GetPos() ) / 30
	local num = table.Random( self.ValidPositions )
		
	local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Positions[num] )
 		
 	particle:SetVelocity( Vector(0,0,60) )  
 	particle:SetDieTime( ( self.TimeScale * 2.5 ) + ( scale * 1.5 ) ) 
 	particle:SetStartAlpha( 255 ) 
 	particle:SetEndAlpha( 0 ) 
 	particle:SetStartSize( math.random(20,40) + ( 30 * self.TimeScale ) + ( scale * 30 ) ) 
 	particle:SetEndSize( 0 ) 
 	particle:SetColor( 0, math.random(100,150), 255 )
	particle:SetRoll( math.random( -360, 360 ) ) 
	particle:SetRollDelta( math.Rand( -1.5, 1.5 ) ) 
		
	if math.random(1,5) == 1 then
		
		local particle = self.Emitter:Add( "effects/yellowflare", self.Positions[num] )
			
		particle:SetVelocity( Vector(0,0,80) + VectorRand() * 10 )  
		particle:SetDieTime( 3.0 ) 
		particle:SetStartAlpha( 255 ) 
		particle:SetEndAlpha( 0 ) 
		particle:SetStartSize( 4 + ( 8 * self.TimeScale ) )
		particle:SetEndSize( 0 ) 
		particle:SetColor( 0, math.random(100,150), 255 )
			
 	end 
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 0
		dlight.g = 150
		dlight.b = 255
		dlight.Brightness = math.Rand( 4, 8 )
		dlight.Decay = 2048
		dlight.size = 512
		dlight.DieTime = CurTime() + 1
		
	end

end

function ENT:Draw()
	
end

