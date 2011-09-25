
function EFFECT:Init( d )

	self.Pos = d:GetOrigin()
	
	local emitter = ParticleEmitter( self.Pos )

	for i=1, 20 do
	
		local particle = emitter:Add( "effects/yellowflare", self.Pos )
		particle:SetVelocity( VectorRand() * 250 + Vector(0,0,100) )
		particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 5, 10 ) )
		particle:SetEndSize( 0 )
		particle:SetStartLength( 0.1 )
		particle:SetEndLength( 0.2 )
		particle:SetRoll( 0 )
		particle:SetColor( 200, 200, 255 )
			
		particle:SetAirResistance( 50 )
		particle:SetVelocityScale( true )
		particle:SetGravity( Vector( 0, 0, -500 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.8 )
		
	end
	
	for i=1, math.random(10,15) do
	
		local particle = emitter:Add( "particles/smokey", self.Pos ) 
 		
 		particle:SetVelocity( VectorRand() * 250 ) 
 		particle:SetLifeTime( 0 ) 
 		particle:SetDieTime( math.Rand(1.5,2.5) ) 
 		particle:SetStartAlpha( math.Rand(100,200) ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( 10 ) 
 		particle:SetEndSize( math.random(50,100) ) 
		particle:SetRoll( math.Rand(0, 90) )
		particle:SetRollDelta( math.Rand(-2, 2) )
		local dark = math.Rand(50,100)
 		particle:SetColor( dark, dark, dark ) 
		
		particle:SetAirResistance( 100 )
		particle:SetGravity( Vector( 0, 0, -200 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.2 )
 		
 	end 
	
	emitter:Finish( )
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Pos
		dlight.r = 200
		dlight.g = 200
		dlight.b = 255
		dlight.Brightness = 3
		dlight.Decay = 2048
		dlight.size = 512 * math.Rand( 0.5, 1.0 )
		dlight.DieTime = CurTime() + 1
		
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end