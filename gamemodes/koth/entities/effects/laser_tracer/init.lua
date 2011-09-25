

EFFECT.Mat = Material( "effects/spark" )

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.StartPos 	= data:GetStart()	
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.TracerTime = 0.1
	self.Length = math.Rand( 0.15, 0.25 )
	
	// Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime
	
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	if CurTime() > self.DieTime then
		return false 
	end
	
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )

	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 ) ^ 0.5
			
	render.SetMaterial( self.Mat )
	
	local sinWave = math.sin( fDelta * math.pi )
	
	render.DrawBeam( self.EndPos - self.Dir * (fDelta - sinWave * self.Length ), 		
					 self.EndPos - self.Dir * (fDelta + sinWave * self.Length ),
					 2 + sinWave * 32, //16					
					 1,					
					 0,				
					 Color( 0, 200, 255, 255 ) )
					 
end
