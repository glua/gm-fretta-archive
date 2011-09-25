
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	self.Duration = math.Rand( 2, 6 )
	self.FireTime = CurTime() + self.Duration
	self.SmokeTime = 0
	self.SmokeFreq = 0.1

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
		
	end

end

function ENT:Think()

	local low, high = self.Entity:WorldSpaceAABB()
	local pos = Vector( math.Rand(low.x,high.x), math.Rand(low.y,high.y), math.Rand(low.z,high.z) )
	
	if self.SmokeTime < CurTime() and self.FireTime < CurTime() and self.SmokeFreq < 0.35 then
	
		self.SmokeFreq = self.SmokeFreq + 0.002
		self.SmokeTime = CurTime() + self.SmokeFreq
 	
		local particle = self.Emitter:Add( "particles/smokey", pos ) 
		
		particle:SetVelocity( VectorRand() * 25 + WindVector ) 
		particle:SetLifeTime( 0 ) 
		particle:SetDieTime( math.Rand( 4.0, 8.0 ) ) 
		particle:SetStartAlpha( math.Rand( 50, 150 ) ) 
		particle:SetEndAlpha( 0 ) 
		particle:SetStartSize( math.random( 5, 25 ) ) 
		particle:SetEndSize( math.random( 30, 60 ) ) 
		
		local dark = math.Rand( 50, 100 )
		particle:SetColor( dark, dark, dark ) 
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, 25 ) )
		
	end
	
	if self.FireTime > CurTime() then
	
		local scale = ( self.FireTime - CurTime() ) / self.Duration
	
		local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), pos )
		
		particle:SetVelocity( VectorRand() * 10 + WindVector ) 
		particle:SetLifeTime( 0 )  
		particle:SetDieTime( math.Rand( 1.5, 3.0 ) + scale * 0.5 ) 
		particle:SetStartAlpha( 255 ) 
		particle:SetEndAlpha( 0 ) 
		particle:SetStartSize( math.random( 15, 30 ) + scale * 10 ) 
		particle:SetEndSize( 0 ) 
		particle:SetColor( 255, 150, 100 )

		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, 50 ) )
	
	end
 	
end

function ENT:Draw()

	self.Entity:DrawModel()
	
end