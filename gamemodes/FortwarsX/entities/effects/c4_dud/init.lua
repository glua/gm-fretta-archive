
local sprites = { "particle/smokesprites_0001", 
	"particle/smokesprites_0002", 
	"particle/smokesprites_0003", 
	"particle/smokesprites_0004", 
	"particle/smokesprites_0005", 
	"particle/smokesprites_0006", 
	"particle/smokesprites_0007", 
	"particle/smokesprites_0008", 
	"particle/smokesprites_0009", 
	"particle/smokesprites_0010", 
	"particle/smokesprites_0011", 
	"particle/smokesprites_0012", 
	"particle/smokesprites_0013", 
	"particle/smokesprites_0014", 
	"particle/smokesprites_0015", 
	"particle/smokesprites_0016"
}

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local vPos = data:GetOrigin()
	local emitter = ParticleEmitter( vPos )
	
		for i=0, 30 do
			
			local randdir = VectorRand() * 4.5
			local particle = emitter:Add( table.Random( sprites ), vPos + randdir ) //effects/spark
			if ( particle ) then
			
				particle:SetVelocity( randdir * 2 )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.5, 2.0 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 4 )
				particle:SetEndSize( 8 )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -1, 1 ) )
				particle:SetColor( 127, 127, 127, 255 )
				particle:SetLighting( true )
				
				particle:SetAirResistance( 60 )
				particle:SetGravity( Vector( 0, 0, 0 ) ) //-700
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
