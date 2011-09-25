include('shared.lua')

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	
end

function ENT:Think()

	local teamnum = self.Entity:GetNWInt( "Team", 0 )
	local col = table.Copy( team.GetColor( teamnum ) ) 

	local particle = self.Emitter:Add( "effects/yellowflare", self.Entity:GetPos() + Vector(0,0,100) )
	
	particle:SetVelocity( VectorRand() * 200 ) 
	particle:SetDieTime( math.Rand( 2.5, 5.0 ) ) 
	particle:SetStartAlpha( 255 ) 
	particle:SetEndAlpha( 0 ) 
	particle:SetStartSize( math.random( 5, 10 ) ) 
	particle:SetEndSize( 0 ) 
	particle:SetColor( col.r, col.g, col.b )
	particle:SetRoll( math.random( -360, 360 ) )
	particle:SetRollDelta( math.Rand( -0.5, 0.5 ) )

	particle:SetGravity( Vector( 0, 0, 400 ) )

end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
	
	end

end

local matLight = Material( "sprites/light_glow02_add" )

function ENT:Draw()

	self.Entity:DrawModel()
	
	local teamnum = self.Entity:GetNWInt( "Team", 0 )
	local col = table.Copy( team.GetColor( teamnum ) ) 
	local size = math.random( 100, 150 )
	
	render.SetMaterial( matLight )
	render.DrawSprite( self.Entity:GetPos() + Vector(0,0,100), size, size, col )
	
end

