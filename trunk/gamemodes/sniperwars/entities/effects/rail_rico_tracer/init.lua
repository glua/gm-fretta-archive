
EFFECT.Flare = Material("effects/blueflare1")
EFFECT.Mat = Material("trails/physbeam")

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.StartPos 	= data:GetStart()	
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.Alpha = 255
	self.Color = Color( 0, 255, 100, self.Alpha )

end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	self.Alpha = self.Alpha - FrameTime() * 100
	self.Color = Color( 0, 255, 100, self.Alpha )
	
	if (self.Alpha < 0) then return false end
	
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )

	if ( self.Alpha < 1 ) then return end
	
	local sc = ( self.Alpha / 255 )
	
	local length = (self.StartPos - self.EndPos):Length()
	local coord = ( ( CurTime() * -0.02 ) ^ 2 ) * 0.05
	
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.StartPos, self.EndPos, sc * 2.5 + 1.0, CurTime(), CurTime(), self.Color )
	
	render.SetMaterial( self.Flare )
	render.DrawSprite( self.StartPos, sc * 15, sc * 15, Color( self.Color.r, self.Color.g, self.Color.b, self.Alpha ) )
	//render.DrawSprite( self.EndPos, sc * 15, sc * 15, Color( self.Color.r, self.Color.g, self.Color.b, self.Alpha ) )

end