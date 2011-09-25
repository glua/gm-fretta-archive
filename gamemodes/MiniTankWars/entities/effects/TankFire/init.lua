  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
TankFireRing init.lua
	-Tank Fire 'MuzzleFlash'+Smoke Effect init
*/

function EFFECT:Init( data )
	
	local BarrelAng = data:GetAngle()
	local BarrelPos = data:GetOrigin()
	
	local emitter = ParticleEmitter( BarrelPos )
	
	//fire
		for i=0, 16 do	
			local vPos = BarrelPos+BarrelAng:Forward()*i*3
			local particle = emitter:Add( "effects/fire_cloud2", vPos)
			if (particle) then		
				particle:SetVelocity( BarrelAng:Forward()*i*5 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.1, 0.2 ) )
				particle:SetStartAlpha( 200 )
				particle:SetEndAlpha( 50 )
				particle:SetStartSize( i )
				particle:SetEndSize( i+math.Rand(5,15) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-10,10) )
				
				particle:SetAirResistance( 25 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
				particle:SetCollide( false )				
			end
		end
	//smoke
		for i=0, 32 do	
			local vPos = BarrelPos+BarrelAng:Forward()*i*5+Vector(math.Rand(-20,20),math.Rand(-20,20),math.Rand(-20,20))
			local particle = emitter:Add( "particle/particle_smokegrenade", vPos)
			if (particle) then		
				particle:SetVelocity( BarrelAng:Forward()*i*30 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
				particle:SetStartAlpha( math.Rand( 200, 250 )*((32-i)+16)/32 )
				particle:SetEndAlpha( 0 )
				particle:SetColor(150, 150, 150, 255)
				particle:SetStartSize( i*1.25+math.Rand(10,20) )
				particle:SetEndSize( i*2+15+math.random(10) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 3 )
				
				particle:SetAirResistance( 50 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
				particle:SetCollide( false )				
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

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end
