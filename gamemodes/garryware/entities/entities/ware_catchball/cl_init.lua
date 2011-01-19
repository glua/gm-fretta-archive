
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT
ENT.UnusableColor = Color( 231, 134, 134, 255 )
ENT.Color = Color( 255, 255, 255, 255 )

local matBall = Material( "sprites/sent_ball" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	
	self.LightColor = Vector( 0, 0, 0 )
	
end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
	
	local pos = self.Entity:GetPos()
	local vel = self.Entity:GetVelocity()
		
	render.SetMaterial( matBall )
	
	local lcolor = render.GetLightColor( self:GetPos() ) * 2
	local colorPtr = (self.Entity:IsUsable() and self.Color) or self.UnusableColor
	
	lcolor.x = colorPtr.r * mathx.Clamp( lcolor.x, 0, 1 )
	lcolor.y = colorPtr.g * mathx.Clamp( lcolor.y, 0, 1 )
	lcolor.z = colorPtr.b * mathx.Clamp( lcolor.z, 0, 1 )
		
	if ( vel:Length() > 1 ) then
	
		for i = 1, 10 do
		
			local col = Color( lcolor.x, lcolor.y, lcolor.z, 200 / i )
			render.DrawSprite( pos + vel * (i * -0.001), 2 * self.Size, 2 * self.Size, col )
			
		end
	
	end
	render.DrawSprite( pos, 2 * self.Size, 2 * self.Size, Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
	
end

