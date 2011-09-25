  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
TankFireRing init.lua
	-Tank Fire Dust Ring Effect init
*/

function EFFECT:Init( data )
	
	local TargetEntity = data:GetEntity()
	if ( !TargetEntity || !TargetEntity:IsValid() ) then return end
	
	local vOrigin = TargetEntity:GetPos() - TargetEntity:GetUp()*5
	local vOffsetR = TargetEntity:GetRight()*10
	local vOffsetF = TargetEntity:GetForward()*10

	NumParticles = 40
	
	local emitter = ParticleEmitter( vOrigin )
	
		for i=0, NumParticles do
		
			local vPos = (math.Rand(-20,20)/10*vOffsetR) + (math.Rand(-20,20)/10*vOffsetF) + vOrigin
			local particle = emitter:Add( "particle/particle_smokegrenade", vPos-TargetEntity:GetUp()*5 )
			if (particle) then
			
				particle:SetVelocity( (vPos - vOrigin) * 25 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.7, 1.2 ) )
				particle:SetStartAlpha( math.Rand( 200, 250 ) )
				particle:SetEndAlpha( 0 )
				particle:SetColor(128, 108, 78, 255)
				particle:SetStartSize( 50 )
				particle:SetEndSize( 20 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 1.5 )
				
				particle:SetAirResistance( 100 )
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
