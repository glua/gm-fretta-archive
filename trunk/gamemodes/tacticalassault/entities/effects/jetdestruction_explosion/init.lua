
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/

local particleLimiter = 0

function EFFECT:Init( data )
	
	local vOffset = data:GetOrigin()
	local vNorm = data:GetStart()
	local NumParticles = 5
	
	local emitter = ParticleEmitter( vOffset )
	
		for i=0, NumParticles do
		
			particle = emitter:Add( "particle/particle_smokegrenade", vOffset )
			if (particle) then
				
				local Vec = vNorm + VectorRand()
				particle:SetVelocity( Vector(Vec.x, Vec.y, math.Rand(0.5,2)) * 1500)
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.5 )
				
				particle:SetStartAlpha( 0 )
				particle:SetEndAlpha( 0 )
				
				particle:SetStartSize( 5 )
				particle:SetEndSize( 5 )
				
				particle:SetColor(100,100,90)
				particle:SetAirResistance( 70 )
				
				particle:SetGravity( Vector( 0, 0, -1000 ) )
				
				particle:SetCollide( true )
				particle:SetBounce( 0.5 )
				particle:SetThinkFunction(ParticleThink)
				particle:SetNextThink(CurTime() + 0.1)
			
			end
			
			particle2 = emitter:Add( "particles/smokey", vOffset )
			if (particle2) then
				
				local Vec2 = VectorRand()
				particle2:SetVelocity( Vector(Vec2.x, Vec2.y, math.Rand(0.1,1.5)) * 1200)
				
				particle2:SetLifeTime( 0 )
				particle2:SetDieTime( 3 )
				
				particle2:SetStartAlpha( 250 )
				particle2:SetEndAlpha( 0 )
				
				particle2:SetStartSize( 150 )
				particle2:SetEndSize( 200 )
				
				particle2:SetColor(50,50,40)
				
				particle2:SetAirResistance( 250 )
				
				particle2:SetGravity( Vector( 100, 100, -80 ) )
				
				particle2:SetLighting( true )
				particle2:SetCollide( true )
				particle2:SetBounce( 0.5 )
			
			end
			
			particle3 = emitter:Add( "particle/particle_smokegrenade", vOffset )
			if (particle3) then
				
				local Vec3 = VectorRand()
				particle3:SetVelocity( Vector(Vec3.x, Vec3.y, math.Rand(0.05,1.5)) * 500)
					
				particle3:SetLifeTime( 0 )
				particle3:SetDieTime( 2 )
				
				particle3:SetStartAlpha( 250 )
				particle3:SetEndAlpha( 0 )
					
				particle3:SetStartSize( 100 )
				particle3:SetEndSize( 120 )
				
				particle3:SetColor(255,80,20)			
				
				particle3:SetRoll( math.Rand(0, 360) )
				particle3:SetRollDelta( math.Rand(-2, 2) )
					
				particle3:SetAirResistance( 150 )
				
				particle3:SetGravity( Vector( math.Rand(-200,200), math.Rand(-200,200), 400 ) )					
				particle3:SetCollide( true )
				particle3:SetBounce( 1 )
			
			end
			
		end
		
	emitter:Finish()
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end

function ParticleThink( part )

	if part:GetLifeTime() > 0.18 then 
	
		particleLimiter = particleLimiter + 1
	
		if particleLimiter >= 3 then
			particleLimiter = 0
		end
	
		if particleLimiter == 0 then
		
			local vOffset = part:GetPos()	
			local emitter = ParticleEmitter( vOffset )
		
			if emitter == nil then return end
			local particle = emitter:Add( "particles/smokey", vOffset )
			
			if (particle) then
			
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 2.5 - part:GetLifeTime() * 2 )
					
				particle:SetStartAlpha( 150 )
				particle:SetEndAlpha( 0 )
					
				particle:SetStartSize( (90 - (part:GetLifeTime() * 100)) / 2 )
				particle:SetEndSize( 100 - (part:GetLifeTime() * 100) )
				
				particle:SetColor(100,100,90)
					
				particle:SetRoll( math.Rand(-0.5, 0.5) )
				particle:SetRollDelta( math.Rand(-0.5, 0.5) )
					
				particle:SetAirResistance( 250 )
					
				particle:SetGravity( Vector( 200, 200, -100 ) )
					
				particle:SetLighting( true )
				particle:SetCollide( true )
				particle:SetBounce( 0.5 )

			end		
			emitter:Finish()
		end
		
		
		
		
	end
	
	part:SetNextThink( CurTime() + 0.5 )
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end
