  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
APShellExplode init.lua
	-AP Shell Explode(Hit) Effect init
*/

function EFFECT:Init( data )
	
	local vOffset=data:GetOrigin()
	
	local emitter = ParticleEmitter( vOffset )
	
		//smoke
		for i=0, 8 do
			local vPos = Vector( math.Rand(-15,15)+vOffset.x, math.Rand(-15,15)+vOffset.y, math.Rand(-15,15)+vOffset.z )
			local particle = emitter:Add( "particle/particle_smokegrenade", vPos )
			if (particle) then
			
				particle:SetVelocity( (vPos - vOffset) * 12 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1, 1.5 ) )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetColor(25,25,25,255)
				particle:SetStartSize( 40 )
				particle:SetEndSize( 30 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 2 )
				
				particle:SetAirResistance( 350 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
				particle:SetCollide( false )			
			end			
		end
		//fire
		for i=0, 16 do
			local vPos = Vector( math.Rand(-10,10)+vOffset.x, math.Rand(-10,10)+vOffset.y, math.Rand(-10,10)+vOffset.z )
			local particle = emitter:Add( "effects/fire_cloud2", vPos )
			if (particle) then
			
				particle:SetVelocity( (vPos - vOffset) * 12 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.1, 0.2 ) )
				particle:SetStartAlpha( math.Rand( 75, 100 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 30 )
				particle:SetEndSize( 20 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( -6 )
				
				particle:SetAirResistance( 200 )
				particle:SetGravity( Vector( 0, 0, 200 ) )
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
