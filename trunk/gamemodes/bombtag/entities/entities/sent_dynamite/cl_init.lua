
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

function ENT:Draw()

	if ValidEntity( self.Entity:GetOwner() ) and self.Entity:GetOwner():GetPos():Distance( self.Entity:GetPos() ) < 100 and self.Entity:GetOwner() == LocalPlayer() then 
		return 
	end
	
	local pos = self.Entity:GetPos() + self.Entity:GetUp() * -5
	local ang = self.Entity:GetUp()
	
	for i=1, math.random( 1, 3 ) do
	
		local particle = self.Emitter:Add( "effects/yellowflare", pos ) 
		
 		particle:SetVelocity( ang * math.Rand( -150, -100 ) + ( VectorRand() * math.Rand( 10, 90 ) ) ) 
 		particle:SetDieTime( math.Rand( 0.5, 3.5 ) ) 
 		particle:SetStartAlpha( 255 ) 
 		particle:SetEndAlpha( 255 ) 
 		particle:SetStartSize( math.Rand( 2, 4 ) ) 
 		particle:SetEndSize( 0 ) 
 		particle:SetColor( 255, math.Rand( 150, 220 ), 0 ) 
		
		particle:SetGravity( Vector( 0, 0, -500 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.8 )
 	
 	end 

	self.Entity:DrawModel()
	
end
	