
function EFFECT:Init( d )
	self.Pos = d:GetOrigin()
	self.Norm = d:GetNormal()
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1, 35 do
	
		local particle = emitter:Add( "effects/spark", self.Pos )
		particle:SetVelocity( self.Norm * math.Rand( 100, 300 ) + VectorRand() * 80 )
		particle:SetDieTime( math.Rand( 1.5, 2.5 ) )
		particle:SetStartAlpha( math.Rand( 200, 250 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 5, 10 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -150, 150 ) )
		particle:SetColor( 0, 200, 255 )
			
		particle:SetAirResistance( 20 )
		particle:SetGravity( Vector(0,0,0) )
		particle:SetCollide( true )
		particle:SetBounce( math.Rand( 0.9, 1.1 ) )
			
	end
	
	emitter:Finish( )
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
		dlight.Pos = self.Pos + self.Norm * 5
		dlight.r = 0
		dlight.g = 200
		dlight.b = 255
		dlight.Brightness = 4 * math.Rand( 0.8, 1.0 )
		dlight.Decay = 1024
		dlight.size = 512 * math.Rand( 0.8, 1.0 )
		dlight.DieTime = CurTime() + 0.4
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end