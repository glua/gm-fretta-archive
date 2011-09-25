
function EFFECT:Init( data )
	
	self.Ent = data:GetEntity()
	
	if not ValidEntity( self.Ent ) then
	
		self.Kill = true
		return 
	
	end
	
	self.DieTime = CurTime() + 5
	self.Pos = self.Ent:GetPos()
	self.Teamnum = data:GetScale()
	self.Emitter = ParticleEmitter( self.Pos )
	self.Col = table.Copy( team.GetColor( self.Teamnum ) )
	
	for i=1, 40 do
		
		local particle = self.Emitter:Add( "effects/spark", self.Pos + Vector(0,0,math.random(0,50)) )
			
		particle:SetVelocity( VectorRand() * 25 )
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
		particle:SetStartAlpha( 255 )
		particle:SetStartSize( math.random( 4, 8 ) )
		particle:SetEndSize( 0 ) 
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.Rand( -30, 30 ) )
		particle:SetColor( self.Col.r, self.Col.g, self.Col.b )
		particle:SetGravity( Vector(0,0,math.random(25,50)) )
	
	end
	
	WorldSound( table.Random( GAMEMODE.SpawnSounds ), self.Pos, 100, 200 )

end

function EFFECT:Think( )

	if self.Kill or not ValidEntity( self.Ent ) or self.DieTime < CurTime() then
	
		if !self.Kill then
		
			self.Emitter:Finish()
		
		end
		
		return false
	
	end
	
	self.Pos = self.Ent:GetPos()
	
	local particle = self.Emitter:Add( "effects/spark", self.Pos + Vector(0,0,math.random(0,50)) )
			
	particle:SetVelocity( VectorRand() * 25 )
	particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
	particle:SetStartAlpha( 255 )
	particle:SetStartSize( math.Rand( 3, 6 ) )
	particle:SetEndSize( 0 ) 
	particle:SetRoll( math.random( -360, 360 ) )
	particle:SetRollDelta( math.Rand( -35, 35 ) )
	particle:SetColor( self.Col.r, self.Col.g, self.Col.b )
	particle:SetGravity( Vector(0,0,math.random(25,50)) )

	return true
	
end

function EFFECT:Render()
	
end



