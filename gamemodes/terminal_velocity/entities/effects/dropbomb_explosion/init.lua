

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	
	local emitter = ParticleEmitter( pos )
	
	for i=1,math.random(10,15) do
		
		local particle = emitter:Add( "particles/smokey", pos )

		particle:SetVelocity(Vector(math.random(-90, 90),math.random(-90, 90), math.random(-70, 70)))
		particle:SetDieTime( math.Rand(3,6) )
		particle:SetStartAlpha( math.Rand( 55, 115 ) )
		particle:SetStartSize( math.Rand( 20, 30 ) )
		particle:SetEndSize( math.Rand( 140, 240 ) )
		particle:SetRoll( math.Rand( -95, 95 ) )
		particle:SetRollDelta( math.Rand( -0.12, 0.12 ) )
		particle:SetColor( 10,10,10 )
		
	end
	
	for i=1, math.random(10,15) do
		
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + Vector(math.random(-40,40),math.random(-40,40),math.random(-30,50)))

		particle:SetVelocity( Vector(math.random(-150,150),math.random(-150,150),math.random(100,200)) )
		particle:SetDieTime( math.Rand(1,1.5) )
		particle:SetStartAlpha( math.Rand( 200, 240 ) )
		particle:SetStartSize( 5 )
		particle:SetEndSize( math.Rand( 90, 100 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
		particle:VelocityDecay( false )
				
	end
	
	for i=1, math.random(15,25) do
		
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), pos + Vector(math.random(-40,40),math.random(-40,40),math.random(10,20)))

		particle:SetVelocity( Vector(math.random(-200,200),math.random(-200,200),math.random(0,60)) )
		particle:SetDieTime( math.Rand( 1, 2 ) )
		particle:SetStartAlpha( math.Rand( 200, 240 ) )
		particle:SetStartSize( 48 )
		particle:SetEndSize( math.Rand( 168, 190 ) )
		particle:SetRoll( math.Rand( 360,480 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
		particle:VelocityDecay( true )	
				
	end
	
	for i=0,math.random(5,9) do
	
		local particle = emitter:Add("effects/fire_embers"..math.random(1,3).."", pos )
		particle:SetVelocity( Vector(math.random(-400,400),math.random(-400,400),math.random(300,550)) )
		particle:SetDieTime(math.Rand(2,5))
		particle:SetStartAlpha(math.random(140,220))
		particle:SetEndAlpha(50)
		particle:SetStartSize(math.random(3,4))
		particle:SetEndSize(0)
		particle:SetRoll(math.random(-200,200))
		particle:SetRollDelta( math.random( -1, 1 ) )
		particle:SetColor(255, 220, 100)
		particle:SetGravity(Vector(0,0,-520)) //-600 is normal
		particle:SetCollide(true)
		particle:SetBounce(0.45) 
		
	end
	emitter:Finish()
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	// Die instantly
	return false
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	// Do nothing - this effect is only used to spawn the particles in Init
	
end



