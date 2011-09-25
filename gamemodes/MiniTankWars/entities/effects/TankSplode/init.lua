  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
TankSplode init.lua
	-Tank Explode Effect init
*/

function EFFECT:Init( data )
	
	local TargetEntity = data:GetEntity()
	if ( !TargetEntity || !TargetEntity:IsValid() ) then return end
	
	local vOffset = TargetEntity:GetPos()
	
	local emitter = ParticleEmitter( vOffset )
	
		//smoke
		for i=0, 75 do
			local vPos = Vector( math.Rand(-60,60)+vOffset.x, math.Rand(-60,60)+vOffset.y, math.random(60)+vOffset.z )
			local particle = emitter:Add( "particle/particle_smokegrenade", vPos )
			if (particle) then
			
				particle:SetVelocity( (vPos - vOffset) * 3.5 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 2, 3 ) )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetColor(25,25,25,255)
				particle:SetStartSize( 50 )
				particle:SetEndSize( 50 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 2 )
				
				particle:SetAirResistance( 250 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
				particle:SetCollide( false )			
			end			
		end
		//fire
		for i=0, 16 do
			local vPos = Vector( math.Rand(-30,30)+vOffset.x, math.Rand(-30,30)+vOffset.y, math.random(30)+vOffset.z )
			local particle = emitter:Add( "effects/fire_cloud2", vPos )
			if (particle) then
			
				particle:SetVelocity( (vPos - vOffset) * 20 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.1, 0.2 ) )
				particle:SetStartAlpha( math.Rand( 75, 100 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 50 )
				particle:SetEndSize( 30 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 6 )
				
				particle:SetAirResistance( 275 )
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
