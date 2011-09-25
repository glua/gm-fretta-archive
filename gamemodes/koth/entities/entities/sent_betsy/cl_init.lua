include('shared.lua')

local matFlare = Material( "effects/blueflare1" )

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self:GetPos() )
	
end

function ENT:OnRemove()

	if self.Emitter then
		self.Emitter:Finish()
	end

end

function ENT:Think()

	if self:GetNWBool( "Smoke", false ) then
	
		local offset = self:LocalToWorld( self:OBBCenter() ) 
		local vel = self:GetVelocity()
	
		for i=0,8 do
		
			local particle = self.Emitter:Add( "particles/smokey", offset + vel * ( i * -0.005 ) ) 
	 		 
	 		particle:SetVelocity( VectorRand() * 5 )
	 		particle:SetDieTime( math.Rand(0.1,0.2) ) 
	 		particle:SetStartAlpha( 200 ) 
	 		particle:SetEndAlpha( 0 ) 
	 		particle:SetStartSize( math.random(4,8) ) 
	 		particle:SetEndSize( 0 ) 
			
			local dark = math.Rand(50,100)
	 		particle:SetColor( dark, dark, dark ) 
			
			particle:SetAirResistance( 50 )
			particle:SetGravity( Vector( 0, 0, -100 ) )
	 		
	 	end 
	end
end

function ENT:Draw()

	self.Entity:DrawModel()
	
	if not ValidEntity( self.Entity:GetOwner() ) then return end
	
	render.SetMaterial( matFlare )
	
	local size = 5
	local col = team.GetColor( self.Entity:GetOwner():Team() )
	local color = Color( col.r, col.g, col.b, 255 )
	
	render.DrawSprite( self.Entity:GetPos() + self.Entity:GetUp() * size, size, size, color ) 
	
end

