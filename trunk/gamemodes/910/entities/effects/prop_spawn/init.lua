
function EFFECT:Init( d )
	self.Pos = d:GetOrigin( ) 
	
	local emitter = ParticleEmitter( self.Pos )
	for i=1,30 do
		local particle = emitter:Add( "effects/bubble", self.Pos )
		particle:SetStartSize( math.Rand(5,9) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand(1,3) )
		particle:SetVelocity( VectorRand( ) * 50 )
		
		particle:SetAirResistance( 100 )
		particle:SetBounce(0.9)
		particle:SetGravity( Vector( 0, 0, -90 ) )
		particle:SetCollide(true)
	end
	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
