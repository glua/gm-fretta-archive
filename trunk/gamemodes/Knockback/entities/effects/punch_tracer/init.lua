//This thing is COMPLETELY written by Rambo_6 - I just changed the colour of it.

EFFECT.Mat = Material( "sprites/bluelaser1" )
local matLight 	= Material( "effects/yellowflare" )

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	// Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	
	self.Color = Color(255,0,0)
	self.Alpha = 255

end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 200
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	if (self.Alpha < 0) then return false end
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )

	if ( self.Alpha < 1 ) then return end
	
	self.Length = (self.StartPos - self.EndPos):Length()
		
	local texcoord = CurTime() * -0.2
	
	for i = 1, 5 do
	
		render.SetMaterial( self.Mat )
		
		texcoord = texcoord + i * 0.05 * texcoord
	
		render.DrawBeam( self.StartPos, 										// Start
						self.EndPos,											// End
						i * self.Alpha * 0.015,													// Width
						texcoord,														// Start tex coord
						texcoord + (self.Length / (128 + self.Alpha)),									// End tex coord
						self.Color )
						
		render.SetMaterial( matLight )

		render.DrawSprite( self.StartPos, i * 10, i * 10, Color( self.Color.r, self.Color.g, self.Color.b, self.Alpha ) )
		render.DrawSprite( self.EndPos, i * 15, i * 15, Color( self.Color.r, self.Color.g, self.Color.b, self.Alpha ) )
	
	end
	


end
