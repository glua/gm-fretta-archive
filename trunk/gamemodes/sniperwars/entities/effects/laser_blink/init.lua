
function EFFECT:Init( data )

	self.Pos = data:GetOrigin( ) 
	
	local emitter = ParticleEmitter( self.Pos )
	
	local particle = emitter:Add( "effects/blueflare1", self.Pos )
	particle:SetColor( 255, 0, 0 )
	particle:SetStartSize( 8 )
	particle:SetEndSize( 0 )
	particle:SetStartAlpha( 200 )
	particle:SetEndAlpha( 0 )
	particle:SetDieTime( 0.5 )
	particle:SetVelocity( Vector(0,0,0) )
		
	particle:SetAirResistance( 100 )
	particle:SetGravity( Vector( 0, 0, 0 ) )

	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
