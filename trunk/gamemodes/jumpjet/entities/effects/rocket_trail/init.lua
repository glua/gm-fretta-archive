
function EFFECT:Init( data )
	
	self.Ent = data:GetEntity()
	
	if not ValidEntity( self.Ent ) then
	
		self.Kill = true
		return
	
	end
	
	self.Emitter = ParticleEmitter( self.Ent:GetPos() )
	self.LastPos = self.Ent:GetPos()
	self.Col = table.Copy( team.GetColor( self.Ent:Team() ) )
	
	self.Sound = CreateSound( self.Ent, Sound( "ambient.steam01" ) )

end

function EFFECT:Think( )

	if self.Kill or !ValidEntity( self.Ent ) or !self.Ent:Alive() then
	
		if not self.Kill then
		
			self.Emitter:Finish()
			
			if self.Sound:IsPlaying() then
		
				self.Sound:Stop()
			
			end
			
		end
	
		return false
	
	end
	
	if !self.Ent:KeyDown( IN_SPEED ) or self.Ent:OnGround() or self.Ent:GetNWInt( "Fuel", 0 ) <= 1 then 
	
		self.LastPos = self.Ent:GetPos()
		
		if self.Sound:IsPlaying() then
		
			self.Sound:Stop()
			
		end
		
		return true 
	
	end
	
	if not self.Sound:IsPlaying() then

		self.Sound:PlayEx( 0.5, 130 )
	
	end
	
	local pos = self.Ent:GetPos()
	local dir = ( self.LastPos - pos ):Normalize()
	local len = math.Clamp( math.Round( self.LastPos:Distance( pos ) / 5 ), 2, 10 )

	for i=1, len do
		
		local particle = self.Emitter:Add( "effects/yellowflare", pos + dir * ( i * 5 ) )
		particle:SetVelocity( dir * 10 + Vector(0,0,-5) )
		particle:SetDieTime( 1.0 + i * 0.02 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 5, 10 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetColor( self.Col.r / 1.5, 0, self.Col.b / 1.5 )
		
		local particle = self.Emitter:Add( "particles/smokey", ( VectorRand() * 3 ) + pos + dir * ( i * 3 ) )
		particle:SetVelocity( Vector( 0, 0, -10 ) )
		particle:SetDieTime( math.Rand( 2.0, 3.0 ) )
		particle:SetStartAlpha( 150 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 3, 6 ) )
		particle:SetEndSize( math.random( 10, 15 ) )
		
		local col = math.random( 100, 120 )
		particle:SetColor( col, col, col )
	
	end
	
	local particle = self.Emitter:Add( "effects/yellowflare", pos )
	particle:SetVelocity( Vector(0,0,-5) )
	particle:SetDieTime( 0.1 )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 20 )
	particle:SetEndSize( 5 )
	particle:SetRoll( math.random( -360, 360 ) )
	particle:SetColor( self.Col.r / 1.5, 0, self.Col.b / 1.5 )

	self.LastPos = pos
	
	return true
	
end

function EFFECT:Render()
	
end
