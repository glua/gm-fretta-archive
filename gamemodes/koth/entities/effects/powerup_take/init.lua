
function EFFECT:Init( data )

	self.Pos = data:GetOrigin( ) 
	self.Col = data:GetStart()
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1,30 do
	
		local particle = emitter:Add( "effects/blueflare1", self.Pos )
		particle:SetColor( self.Col.x, self.Col.y, self.Col.z )
		particle:SetStartSize( math.Rand(2,4) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand(1.5,2.5) )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,0,100) )
		
		particle:SetCollide( true )
		particle:SetBounce( 1.0 )
		particle:SetGravity( Vector( 0, 0, -200 ) )
		
	end
	
	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
