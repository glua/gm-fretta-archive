
function EFFECT:Init( data )

	self.Entity:SetRenderBounds( Vector() * -512, Vector() * 512 )
	
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter( pos )
	
	local particle = emitter:Add( "particle/fire", pos )
	particle:SetDieTime( math.Rand( 0.2, 0.5 ) )
	particle:SetStartAlpha( 0 )
	particle:SetEndAlpha( 255 )
	particle:SetStartSize( 250 )
	particle:SetEndSize( 10 )
	particle:SetRoll( 0 )
	particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )

	for i=1, 30 do
	
		local particle = emitter:Add( "particles/flamelet"..math.random(1,5), pos )

		particle:SetVelocity( VectorRand() * 100 )
		particle:SetDieTime( math.Rand( 0.2, 0.5 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 25, 50 ) )
		particle:SetEndSize( math.Rand( 100, 200 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( 0 )
		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
	
	end
	
	for i=1, 15 do
	
		local particle = emitter:Add( "particles/smokey", pos )

		particle:SetVelocity( Vector( math.random(-50,50), math.random(-50,50), math.random(-10,50) ) )
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 20, 40 ) )
		particle:SetEndSize( math.Rand( 100, 200 ) )
		particle:SetRoll( math.Rand( -90, 90 ) )
		particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
		
		local dark = math.Rand( 50, 100 )
 		particle:SetColor( dark, dark, dark ) 
	
	end
	
	emitter:Finish()
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = pos
		dlight.r = 250
		dlight.g = 200
		dlight.b = 50
		dlight.Brightness = math.Rand( 4, 8 )
		dlight.Decay = 1024
		dlight.size = 512
		dlight.DieTime = CurTime() + 3
		
	end
	
end

function EFFECT:Think( )
	
	return false
	
end

function EFFECT:Render()

end
