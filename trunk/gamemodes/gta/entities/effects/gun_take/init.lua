
function EFFECT:Init( data )

	if LocalPlayer():Team() == TEAM_POLICE then return end

	self.Pos = data:GetOrigin() 
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1, 25 do
	
		local particle = emitter:Add( "effects/yellowflare", self.Pos + VectorRand() * 5 )
		particle:SetColor( 0, 100, 255 )
		particle:SetStartSize( math.Rand( 1, 5 ) )
		particle:SetEndSize( 0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetDieTime( math.Rand( 1.5, 2.5 ) )
		particle:SetVelocity( VectorRand() * 100 + Vector(0,0,50) )
		
		particle:SetBounce( 0.5 )
		particle:SetGravity( Vector(0,0,-200) )
		particle:SetCollide( true )
	
	end
	
	local particle = emitter:Add( "effects/blueflare1", self.Pos )
	particle:SetColor( 0, 100, 255 )
	particle:SetStartSize( 20 )
	particle:SetEndSize( 0 )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetDieTime( 1.5 )
	particle:SetVelocity( Vector(0,0,0) )

	particle:SetGravity( Vector(0,0,0) )
	
	emitter:Finish( )
	
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render( )

end
