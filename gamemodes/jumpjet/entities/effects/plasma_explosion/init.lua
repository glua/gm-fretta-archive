

function EFFECT:Init( data )
	
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local emitter = ParticleEmitter( pos )
	
	for i=1,30 do
	
		local particle = emitter:Add( "effects/muzzleflash"..math.random(1,4), pos )

		particle:SetVelocity( norm * math.random(50,100) + VectorRand() * math.random(50,100) )
		particle:SetDieTime( 1.0 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 20, 40 ) )
		particle:SetEndSize( math.Rand( 100, 200 ) )
		particle:SetRoll( math.Rand( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )
		particle:SetColor( 0, math.random(100,150), 255 )
		
		local particle = emitter:Add( "effects/yellowflare", pos )
		
		local vec = VectorRand()
		vec.x = 0
 		
 		particle:SetVelocity( vec * 150 + norm * 150 )  
 		particle:SetDieTime( math.Rand( 3.0, 4.0 ) ) 
 		particle:SetStartAlpha( 255 ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( 1 ) 
 		particle:SetEndSize( math.random(4,8) ) 
 		particle:SetColor( 0, math.random(100,150), 255 )
		
		particle:SetCollide( true )
		particle:SetBounce( 1.0 )
	
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = pos
		dlight.r = 0
		dlight.g = 150
		dlight.b = 255
		dlight.Brightness = math.Rand( 4, 8 )
		dlight.Decay = 1024
		dlight.size = 2048
		dlight.DieTime = CurTime() + 5
		
	end
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()
	
end



