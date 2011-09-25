
function EFFECT:Init( data )
	self.Pos = data:GetOrigin( ) 
	
	local emitter = ParticleEmitter( self.Pos )
	for i=1,30 do
		local particle = emitter:Add( "effects/blueflare1", self.Pos )
		particle:SetColor(50,150,50)
		particle:SetStartSize( math.Rand(2,4) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand(2,3) )
		particle:SetVelocity( VectorRand( ) * 50 + Vector(0,0,100) )
		
		particle:SetBounce(0.9)
		particle:SetGravity( Vector( 0, 0, -200 ) )
		particle:SetCollide(true)
	end
	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
