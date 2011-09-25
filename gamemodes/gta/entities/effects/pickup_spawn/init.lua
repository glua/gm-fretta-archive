
function EFFECT:Init( data )

	self.Pos = data:GetOrigin( ) 
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1,30 do
	
		local particle = emitter:Add( "effects/yellowflare", self.Pos )
		particle:SetColor( 0, 100, 255 )
		particle:SetStartSize( math.Rand( 2, 5 ) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand( 1.5, 3.0 ) )
		particle:SetVelocity( VectorRand( ) * 50 )
		
		particle:SetAirResistance( 100 )
		particle:SetBounce( 1.0 )
		particle:SetGravity( Vector( 0, 0, 0 ) )
		particle:SetCollide( true )
		
	end
	
	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
