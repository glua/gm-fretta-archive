
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
		
	end

end

function ENT:Think()

	local offset = self.Entity:GetPos() + self.Entity:GetForward() * -15
 	
	for i=1, math.random(2,4) do
	
		local particle = self.Emitter:Add( "particles/smokey", offset ) 
 		
 		particle:SetVelocity( VectorRand() * 30 ) 
 		particle:SetLifeTime( 0 ) 
 		particle:SetDieTime( math.Rand( 0.5, 1.0 ) ) 
 		particle:SetStartAlpha( math.Rand( 100, 200 ) ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random( 5, 10 ) ) 
 		particle:SetEndSize( math.random( 15, 30 ) ) 
		
		local dark = math.Rand( 50, 150 )
 		particle:SetColor( dark, dark, dark ) 
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, 100 ) )
		
		local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), offset )
 		
 		particle:SetVelocity( VectorRand() * 30 + Vector( 0, 0, 20 ) ) 
 		particle:SetLifeTime( 0 )  
 		particle:SetDieTime( math.Rand( 0.50, 0.75 ) ) 
 		particle:SetStartAlpha( 255 ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random( 10, 20 ) ) 
 		particle:SetEndSize( 1 ) 
 		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
		
		particle:SetAirResistance( 50 )
 	
 	end 

end

function ENT:Draw()

	self.Entity:SetModelScale( Vector( 1.5, 1.5, 1.5 ) )
	self.Entity:DrawModel()
	
end
	