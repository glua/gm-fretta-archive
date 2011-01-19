
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

local matBall = Material( "ware/nonc/ware_bullseye" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Color = Color( 255, 255, 255, 255 )
	
	self.LightColor = Vector( 0, 0, 0 )
	
end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
	if self:GetDTBool(1) == true then return end
	
	local pos = self.Entity:GetPos()
	local vel = self.Entity:GetVelocity()
		
	render.SetMaterial( matBall )
	
	local lcolor = render.GetLightColor( self:GetPos() ) * 2
	
	lcolor.x = self.Color.r * mathx.Clamp( lcolor.x, 0, 1 )
	lcolor.y = self.Color.g * mathx.Clamp( lcolor.y, 0, 1 )
	lcolor.z = self.Color.b * mathx.Clamp( lcolor.z, 0, 1 )
		
	if ( vel:Length() > 1 ) then
	
		for i = 1, 10 do
		
			local col = Color( lcolor.x, lcolor.y, lcolor.z, 200 / i )
			render.DrawSprite( pos + vel*(i*-0.001), 2*self.Size, 2*self.Size, col )
			
		end
	
	end
	
	render.DrawSprite( pos, 2*self.Size, 2*self.Size, Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
	
end

