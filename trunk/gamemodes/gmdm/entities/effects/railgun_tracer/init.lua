local matLaser = Material( "tripmine_laser" )

function EFFECT:Init( data )
	self.StartPos 	= data:GetStart()	
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )
	self.DieTime = CurTime( ) + math.Rand( 2, 3 )
	self.Size = 5
end

function EFFECT:Think( )
	if CurTime( ) > self.DieTime then
		return false
	end
	
	self.Size = self.Size - ( 2 * FrameTime( ) )
	return true
end

function EFFECT:Render( )
	render.SetMaterial( matLaser )
	render.DrawBeam( self.StartPos, self.EndPos, self.Size, 0, 0, Color( 59, 59, 159 ) )
end
