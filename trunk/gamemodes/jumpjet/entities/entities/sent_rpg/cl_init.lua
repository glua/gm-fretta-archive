
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	self.LastPos = self.Entity:GetPos()

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
		
	end

end

function ENT:Think()

	local pos = self.Entity:GetPos()
	local dir = ( self.LastPos - pos ):Normalize()
	local len = math.Clamp( math.Round( self.LastPos:Distance( pos ) / 5 ), 2, 20 )
 	
	for i=1, len do
	
		local particle = self.Emitter:Add( "particles/smokey", pos + dir * ( i * 5 ) ) 
 		
 		particle:SetVelocity( VectorRand() * 30 ) 
 		particle:SetLifeTime( 0 ) 
 		particle:SetDieTime( math.Rand( 0.5, 1.0 ) ) 
 		particle:SetStartAlpha( math.Rand( 100, 200 ) ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random( 5, 10 ) ) 
 		particle:SetEndSize( math.random( 10, 20 ) ) 
		
		local dark = math.Rand( 10, 50 )
 		particle:SetColor( dark, dark, dark ) 
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, 100 ) )
		
		local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + dir * ( i * 5 ) )
 		
 		particle:SetVelocity( VectorRand() * 30 + Vector( 0, 0, 20 ) ) 
 		particle:SetLifeTime( 0 )  
 		particle:SetDieTime( math.Rand( 0.50, 0.75 ) ) 
 		particle:SetStartAlpha( 255 ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random( 5, 20 ) ) 
 		particle:SetEndSize( 1 ) 
 		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
		
		particle:SetAirResistance( 50 )
 	
 	end 
	
	self.LastPos = self.Entity:GetPos()

end

function ENT:Draw()

	self.Entity:DrawModel()
	
end
	