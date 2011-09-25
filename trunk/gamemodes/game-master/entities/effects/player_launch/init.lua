function EFFECT:Init( data )
	
	self.Ent = data:GetEntity()
	self.DieTime = CurTime() + 1.75 //1.75 seconds of particle goodness!
	
end

function EFFECT:Think( )

	local lbone = self.Ent:LookupBone( "ValveBiped.Bip01_L_Foot" )
	local rbone = self.Ent:LookupBone( "ValveBiped.Bip01_R_Foot" )
	local lbonepos, lboneang = self.Ent:GetBonePosition( lbone )
	local rbonepos, rboneang = self.Ent:GetBonePosition( rbone )
	
	self:EmitEffect( lbonepos )
	self:EmitEffect( rbonepos )
	
	LocalPlayer():InvalidateBoneCache() //To fix the player's bones getting messed up
	
	return ( self.DieTime > CurTime() )
	
end

function EFFECT:Render()
end

function EFFECT:EmitEffect( vPos )

	local emitter = ParticleEmitter( vPos )
	
		for i = 0, 10 do
			
			local randdir = VectorRand()
			local particle = emitter:Add( "effects/spark", vPos ) //table.Random( sprites )
			if ( particle ) then
			
				particle:SetVelocity( randdir * math.Rand( 15, 40 ) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.4, 1.6 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( ( self.DieTime - CurTime() ) * 6 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetColor( 20, math.Rand( 150, 240 ), 50, 200 )
				
				particle:SetAirResistance( 0 )
				particle:SetGravity( Vector( 0, 0, 0 ) ) //-700
				
			end
			
		end
		
	emitter:Finish()
	
end