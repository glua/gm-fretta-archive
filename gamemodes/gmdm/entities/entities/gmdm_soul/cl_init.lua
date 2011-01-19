
include('shared.lua')

local matLight 		= Material( "sprites/light_ignorez" )
local matRefraction	= Material( "sprites/gmdm_pickups/base_r" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()	

	self.Entity:SetCollisionBounds( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	self.Entity:SetSolid( SOLID_NONE )
	self.PixelVisHandle = util.GetPixelVisibleHandle()
	
	self.Distance = 0
	self.Visibile = 0
	self.ParticleSpawnTime = CurTime() + math.Rand( 0, 2 )
	
end

function ENT:Think()

	local Pos 			= self.Entity:GetPos()
	self.RealDistance  	= EyePos():Distance( Pos )
	self.Distance  		= 1.0 - self.RealDistance / 2048 
	self.EyeNormal 		= EyePos() - Pos
	self.EyeNormal:Normalize()
	self.Visibile	= util.PixelVisible( Pos + self.EyeNormal * 32, 8, self.PixelVisHandle )
	
	
	if ( self.ParticleSpawnTime > CurTime() ) then return end
	self.ParticleSpawnTime = CurTime() + 1.5
	
	if ( self.Visibile <= 0 ) then return end
	
	local emitter = ParticleEmitter( Pos )
		
		local particle = emitter:Add( "sprites/magic", Pos + VectorRand() * 16 )
			particle:SetVelocity( Vector(0,0,32) )
			particle:SetDieTime( math.Rand( 0.1, 1.0 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 0 )
			particle:SetEndSize( 4 )
				
	emitter:Finish()

end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()

	if (self.Distance > 0 && self.Visibile > 0) then
	
		local Pos 		= self.Entity:GetPos()

		render.SetMaterial( matLight )
		
		local Pos 		= self.Entity:GetPos()
		local Size 		= 64 + math.sin( CurTime() * 10) * 8
		render.DrawSprite( Pos, Size, Size, Color( 100, 200, 255, 255*self.Visibile ) )
		render.DrawSprite( Pos, Size, Size, Color( 255, 255, 255, 255*self.Visibile ) )

	end
	
	self.Entity:DrawModel()
		 
end

