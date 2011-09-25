
EFFECT.Mat = Material( "effects/spark" )

function EFFECT:Init( data )

	self.StartPos 	= data:GetStart()	
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	self.Normal     = ( self.EndPos - self.StartPos ):Normalize()
	self.Length     = math.Rand( 0.15, 0.25 )
	
	local dist = self.StartPos:Distance( self.EndPos )
	
	self.TracerTime = 0.2 * math.Clamp( dist / 3000, 0.1, 1.0 )
	self.DieTime = CurTime() + self.TracerTime
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.StartPos + self.Normal * 10
		dlight.r = 250
		dlight.g = 200
		dlight.b = 150
		dlight.Brightness = math.Rand( 4, 8 )
		dlight.Decay = 8192
		dlight.size = 256 * math.Rand( 0.5, 1.5 )
		dlight.DieTime = CurTime() + 0.2
	
	end
	
end

function EFFECT:Think()
	
	return CurTime() < self.DieTime

end

function EFFECT:Render()

	local fDelta = ( self.DieTime - CurTime() ) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 ) ^ 0.5
	
	render.SetMaterial( self.Mat )
	
	local sinWave = math.sin( fDelta * math.pi )
	
	render.DrawBeam( self.EndPos - self.Dir * (fDelta - sinWave * self.Length ), 		
					 self.EndPos - self.Dir * (fDelta + sinWave * self.Length ),
					 2 + sinWave * 15, 
					 1,					
					 0,				
					 Color( 255, 255, 255, 255 ) )
	
end
