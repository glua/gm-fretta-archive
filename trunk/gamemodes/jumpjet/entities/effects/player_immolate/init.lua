
function EFFECT:Init( data )
	
	self.Ent = data:GetEntity()
	
	if not ValidEntity( self.Ent ) then
	
		self.Kill = true
		return
	
	end
	
	self.Emitter = ParticleEmitter( self.Ent:GetPos() )
	self.Sound = CreateSound( self.Ent, Sound( "fire_medium" ) )
	
	self.Sound:PlayEx( 0.5, 110 )

end

function EFFECT:Think( )

	if self.Kill or !ValidEntity( self.Ent ) or !self.Ent:Alive() or not self.Ent:GetNWBool( "Fire", false ) then
	
		if not self.Kill then
		
			self.Emitter:Finish()
			
			if self.Sound:IsPlaying() then
		
				self.Sound:Stop()
			
			end
			
		end
	
		return false
	
	end
	
	local pos = self.Ent:GetPos() + WindVector + Vector( math.random(-10,10), math.random(-10,10), math.random(5,50) )

	local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), pos )
 		
 	particle:SetVelocity( Vector(0,0,60) )  
 	particle:SetDieTime( math.Rand( 2.0, 3.0 ) ) 
 	particle:SetStartAlpha( 255 ) 
 	particle:SetEndAlpha( 0 ) 
 	particle:SetStartSize( math.random(25,50) ) 
 	particle:SetEndSize( 0 ) 
 	particle:SetColor( 0, math.random(100,150), 255 )
	particle:SetRoll( math.random( -360, 360 ) ) 
	particle:SetRollDelta( math.Rand( -1.5, 1.5 ) ) 
		
	if math.random(1,5) == 1 then
		
		local particle = self.Emitter:Add( "effects/yellowflare", pos )
			
		particle:SetVelocity( Vector(0,0,80) + VectorRand() * 10 )  
		particle:SetDieTime( math.Rand( 3.0, 4.0 ) ) 
		particle:SetStartAlpha( 255 ) 
		particle:SetEndAlpha( 0 ) 
		particle:SetStartSize( 5 )
		particle:SetEndSize( 0 ) 
		particle:SetColor( 0, math.random(100,150), 255 )
			
 	else
	
		local particle = self.Emitter:Add( "effects/yellowflare", pos )
			
		particle:SetVelocity( VectorRand() * 10 )  
		particle:SetDieTime( math.Rand( 3.0, 4.0 ) ) 
		particle:SetStartAlpha( 255 ) 
		particle:SetEndAlpha( 0 ) 
		particle:SetStartSize( 5 )
		particle:SetEndSize( 0 ) 
		particle:SetColor( 0, math.random(100,150), 255 )
		
		particle:SetGravity( Vector(0,0,-30) )
		particle:SetCollide( true )
		
		particle:SetLifeTime( 0 )
		particle:SetThinkFunction( EmberThink )
	
	end
	
	return true
	
end

function EFFECT:Render()
	
end


function EmberThink( part )

	part:SetNextThink( CurTime() + 0.05 )
	part:SetGravity( Vector( 0, math.sin( CurTime() * 5 ) * 60, -30 ) )

end
