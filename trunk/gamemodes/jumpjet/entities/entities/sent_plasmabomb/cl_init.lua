include('shared.lua')

function ENT:Initialize()

	self.LastPos = self.Entity:GetPos()
	self.Emitter = ParticleEmitter( self.LastPos )
	
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
		
		local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + dir * ( i * 5 ) )
 		
 		particle:SetVelocity( VectorRand() * 10 + dir * 30 )  
 		particle:SetDieTime( math.Rand( 1.5, 2.0 ) ) 
 		particle:SetStartAlpha( 255 ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random(10,20) ) 
 		particle:SetEndSize( 0 ) 
 		particle:SetColor( 0, math.random(100,150), 255 )
		particle:SetRoll( math.random( -360, 360 ) ) 
		particle:SetRollDelta( math.Rand( -5.5, 5.5 ) ) 
 	
 	end 
	
	self.LastPos = self.Entity:GetPos()

end

local matSprite = Material( "sprites/light_glow02_add" )

function ENT:Draw()
	
	local size = math.random(100,150)
	
	render.SetMaterial( matSprite )
	render.DrawSprite( self.Entity:GetPos(), size, size, Color(0,math.random(100,150),255,255) ) 
	
end

