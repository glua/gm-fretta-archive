
function EFFECT:Init( d )
	self.Pos = d:GetOrigin()
	
	local emitter = ParticleEmitter( self.Pos )
	
	for i=1, 35 do
	
		local particle = emitter:Add( "effects/spark", self.Pos )
		particle:SetVelocity( VectorRand() * 150 )
		particle:SetDieTime( math.Rand( 1.4, 2.4 ) )
		particle:SetStartAlpha( math.Rand( 200, 250 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 4, 8 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand(0, 360) )
		particle:SetRollDelta( math.Rand(-150, 150) )
		particle:SetColor( 255, 255, 225 )
			
		particle:SetAirResistance( 20 )
		particle:SetGravity( Vector(0,0,-300) )
		particle:SetCollide( true )
		particle:SetBounce( math.Rand( 0.9, 1.1 ) )
			
	end
	
	for i=1, math.random(10,15) do
	
		local particle = emitter:Add( "particles/smokey", self.Pos ) 
 		 
 		particle:SetVelocity( VectorRand() * 200 ) 
 		particle:SetLifeTime( 0 ) 
 		particle:SetDieTime( math.Rand(2.0,2.8) ) 
 		particle:SetStartAlpha( math.Rand(100,150) ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random(10,20) ) 
 		particle:SetEndSize( math.random(150,200) ) 
		particle:SetRoll( math.Rand(0, 90) )
		particle:SetRollDelta( math.Rand(-2, 2) )
		local dark = math.Rand(50,100)
 		particle:SetColor( dark, dark, dark ) 
		
		particle:SetAirResistance( 100 )
		particle:SetGravity( Vector( 0, 0, -200 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.4 )
 				 
 	end 
	
	emitter:Finish( )
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	if dlight then
		dlight.Pos = self.Pos
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 4 * math.Rand( 0.8, 1.0 )
		dlight.Decay = 2048
		dlight.size = 512 * math.Rand( 0.4, 0.6 )
		dlight.DieTime = CurTime() + 0.4
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end