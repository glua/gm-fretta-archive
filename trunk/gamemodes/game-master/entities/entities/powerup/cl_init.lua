
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE
local glowmat = Material( "sprites/gmaster/powerup_glow" )

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:Draw()
	
	render.SetMaterial( glowmat )
	render.DrawSprite( self.Entity:GetPos(), 128, 128, powerups[self:GetPowerup()].color )
	self.Entity:DrawModel()
	self.Entity:SetAngles( Angle( 0, CurTime() * 90, 90 ) )

end

