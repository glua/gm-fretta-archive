
function EFFECT:Init( data )

	self.Pos = data:GetOrigin( ) 
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1,20 do
		local particle = emitter:Add( "effects/yellowflare", self.Pos + VectorRand() * 5)
		particle:SetColor(255,192,255)
		particle:SetStartSize( math.Rand(5,10) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 250 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand(0.1,0.3) )
		particle:SetVelocity( VectorRand() * 1000 )
		
		particle:SetBounce(2)
		particle:SetGravity( Vector( 0, 0, -150 ) )
		particle:SetCollide(true)
	end
	
	local particle = emitter:Add( "effects/yellowflare", self.Pos)
	particle:SetColor(255,192,255)
	particle:SetStartSize( 100 )
	particle:SetEndSize( 0 )
	particle:SetStartAlpha( 250 )
	particle:SetEndAlpha( 0 )
	particle:SetDieTime( 0.7 )
	particle:SetVelocity( Vector(0,0,0) )
		
	particle:SetBounce(0)
	particle:SetGravity( Vector( 0, 0, 0 ) )
	
	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
