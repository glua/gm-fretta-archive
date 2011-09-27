/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )

	local Team = data:GetAttachment()
	local Ply = data:GetEntity()
	
	if LocalPlayer() == Ply then return end

	local NumParticles = Ply:GetBoneCount()
	
	local emitter = ParticleEmitter( Ply:GetPos() )
	
		for i=0, NumParticles do
			
			if Ply:GetBonePosition(i) then
				local particle = emitter:Add( "sprites/light_glow02_add", Ply:GetBonePosition(i) )
				if (particle) then
					
					particle:SetVelocity( Ply:GetVelocity()/2 )
					
					particle:SetLifeTime( 0 )
					particle:SetDieTime( math.Rand(1,2) )
					
					particle:SetStartAlpha( 255 )
					particle:SetEndAlpha( 0 )
					
					particle:SetStartSize( math.Rand(20,25) )
					particle:SetEndSize( 0 )
					
					particle:SetRoll( math.Rand(0, 360) )
					particle:SetRollDelta( math.Rand(-200, 200) )
					
					particle:SetAirResistance( math.Rand(80,100) )
					
					particle:SetGravity( Vector( 0, 0, 0 ) )
					
					if Team == TEAM_CYAN then
						particle:SetColor(0,156,215,255)
					else
						particle:SetColor(245,130,32,255)
					end
				
				end
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
