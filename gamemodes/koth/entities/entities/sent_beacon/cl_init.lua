include('shared.lua')

function ENT:Initialize()
	
end

function ENT:Think()
	
end

local matFlare = Material( "sprites/light_glow02_add" )

function ENT:Draw()

	self.Entity:DrawModel()
	
	local size = math.random(10,20)
	
	if not self.Entity:GetNWBool( "Frozen", false ) then 
		size = 5
	end

	render.SetMaterial( matFlare )
	render.DrawSprite( self.Entity:GetPos() + self.Entity:GetForward() * -10, size, size, Color( 200, 200, 255, 255 ) ) 
	
end

