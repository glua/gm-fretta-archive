
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

ENT.BallMaterial = Material( "sprites/ball/sent_ball0" )
ENT.TransBall = false

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Color = Color( 255, 150, 0, 255 )
	
	self.LightColor = Vector( 0, 0, 0 )
	
end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
	
	if ( self.Entity.eOwner == LocalPlayer() ) then
		self.Color = Color( 255, 150, 0, 155 )
	else
		self.Color = Color( 255, 150, 0, 255 )
	end
	
	local pos = self.Entity:GetPos()
	local vel = self.Entity:GetVelocity()
		
	render.SetMaterial( self.BallMaterial )
	
	local lcolor = render.GetLightColor( self:GetPos() ) * 2
	
	lcolor.x = self.Color.r * mathx.Clamp( lcolor.x, 0, 1 )
	lcolor.y = self.Color.g * mathx.Clamp( lcolor.y, 0, 1 )
	lcolor.z = self.Color.b * mathx.Clamp( lcolor.z, 0, 1 )
	
	render.DrawSprite( pos, 32, 32, Color( lcolor.x, lcolor.y, lcolor.z, self.Color.a ) )
	
end

