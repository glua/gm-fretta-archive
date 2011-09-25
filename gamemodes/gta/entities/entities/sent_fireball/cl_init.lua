
include('shared.lua')

local matGlow = Material( "particle/fire" )

function ENT:Initialize()

	self.Size = self.Entity:BoundingRadius()
	self.Velocity = Vector(0,0,1)
	self.SmokeTime = 0
	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	
end

function ENT:OnRemove()

	if not self.Emitter then return end

	self.Emitter:Finish()

end

function ENT:Think()

	local low, high = self.Entity:WorldSpaceAABB()
	local pos = Vector( math.Rand( low.x, high.x ), math.Rand( low.y, high.y ), math.Rand( low.z, high.z ) )
	
	local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + VectorRand() * ( self.Size / math.Rand(1.5,2.5) ) )
	
	particle:SetVelocity( ( self.Velocity * math.Rand( 20, 40 ) ) + WindVector + VectorRand() * 10 )
	particle:SetDieTime( math.Rand( 1.0, 2.5 ) )
	particle:SetStartAlpha( 250 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.Rand( 20, 40 ) ) 
	particle:SetEndSize( 0 )     
	particle:SetRoll( math.Rand( 0, 360 ) )
	particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
	particle:SetColor( math.Rand( 150, 250 ), math.Rand( 100, 150 ), 100 )
		
	particle:VelocityDecay( false )
	
	if self.SmokeTime < CurTime() then
	
		self.SmokeTime = CurTime() + 0.25
	
		local col = math.random(50,100)
		local particle = self.Emitter:Add( "particles/smokey", self.Entity:LocalToWorld( self.Entity:OBBCenter() ) + VectorRand() * 10 )

		particle:SetVelocity( ( self.Velocity * math.Rand( 20, 40 ) ) + WindVector )
		particle:SetDieTime( math.Rand( 10, 15 ) )
		particle:SetStartAlpha( math.Rand( 20, 40 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 50 ) )
		particle:SetEndSize( math.Rand( 50, 150 ) )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		particle:SetColor( col, col, col )
		
	end
	
end

function ENT:Draw()

	self.Entity:DrawModel()
	
	local center = self.Entity:LocalToWorld( self.Entity:OBBCenter() )
	
	local trace = {}
	trace.start 	= center 
	trace.endpos 	= trace.start + Vector(0,0,-50)
	trace.filter 	= self.Entity
	local tr = util.TraceLine( trace )
	
	if not tr.Hit then return end
	
	local size = 200 + math.Rand( 0, 50 )
	
	render.SetMaterial( matGlow )
	render.DrawQuadEasy( tr.HitPos,
					 Vector(0,0,1),
					 size, size,
					 Color( 200, 150, 100, math.Rand(50,200) ) )
	
end

