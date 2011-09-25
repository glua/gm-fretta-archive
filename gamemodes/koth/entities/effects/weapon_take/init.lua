
function EFFECT:Init( data )
	self.Pos = data:GetOrigin( ) 
	
	local emitter = ParticleEmitter( self.Pos )
	for i=1,20 do
		local particle = emitter:Add( "effects/blueflare1", self.Pos )
		particle:SetColor(math.Rand(50,150),150,math.Rand(50,150))
		particle:SetStartSize( math.Rand(2,4) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 250 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand(1,2) )
		particle:SetVelocity( VectorRand( ) * 50 + Vector(0,0,50) )
		
		particle:SetBounce(1.0)
		particle:SetGravity( Vector( 0, 0, -100 ) )
		particle:SetCollide(true)
	end
	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
