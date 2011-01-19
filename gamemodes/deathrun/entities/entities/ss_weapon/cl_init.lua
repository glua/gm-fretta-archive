include( "shared.lua" )

ENT.Entity = {}
ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Initialize()
	
	self.Size = 1
	self.LastPos = self.Entity:GetPos()
	self.Emitter = ParticleEmitter( self.LastPos )
	
end

function ENT:Think()

	self.Col = Color( 50, 100, 150, 255 )
	
	if self.LastPos != self.Entity:GetPos() and ValidEntity( self.Entity:GetOwner() ) then
	
		local particle = self.Emitter:Add( "effects/yellowflare", self.Entity:GetOwner():GetPos() + Vector(0,0,math.random(30,50)) ) 
		
		particle:SetVelocity( VectorRand() * 10 ) 
		particle:SetDieTime( math.Rand( 2.0, 4.0 ) ) 
		particle:SetStartAlpha( 255 ) 
		particle:SetEndAlpha( 0 ) 
		particle:SetStartSize( math.random( 5, 10 ) ) 
		particle:SetEndSize( 0 ) 
		particle:SetRoll( math.random( -360, 360 ) ) 
		particle:SetRollDelta( math.Rand( -0.3, 0.3 ) ) 
		particle:SetColor( self.Col.r, self.Col.g, self.Col.b ) 
		
		particle:SetAirResistance( 10 )
		particle:SetGravity( Vector( 0, 0, math.random( -20, -10 ) ) )
	
	end
	
	self.LastPos = self.Entity:GetPos()
	
/*	local dlight = DynamicLight( self:EntIndex() )

	if dlight then
	
		dlight.Pos = self.Entity:GetPos()
		dlight.r = self.Col.r
		dlight.g = self.Col.g
		dlight.b = self.Col.b
		dlight.Brightness = 6
		dlight.Size = 200
		dlight.DieTime = CurTime() + 0.1
	
	end */
	
end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
	
	end

end

local matSprite = Material( "effects/blueflare1" )

function ENT:Draw()

	if ValidEntity( self.Entity:GetOwner() ) then return end
	if self.Entity.Type == "weapon_crowbar" then
		self.Entity:SetAngles(Angle(0, 0, 0))
	else
		self.Entity:SetAngles(Angle(0, RealTime() * 50, 0))
	end
	self.Entity:DrawModel()
	
	local Size = (math.sin(5 * CurTime()) * 20) + 60
	
	render.SetMaterial( matSprite )
	
	for i=1,8 do
	
		local sin, cos = math.sin( CurTime() * 5 + ( i / 5 ) ) * 30, math.cos( CurTime() * 5 + ( i / 5 ) ) * 30
		local pos = Vector( 0, cos, sin )
		render.DrawSprite( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) + pos, i, i, self.Col )
	
	end
	
end


