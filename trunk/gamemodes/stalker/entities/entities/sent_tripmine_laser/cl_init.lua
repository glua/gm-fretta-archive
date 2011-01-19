
include( 'shared.lua' )

function ENT:Initialize()
	
end

function ENT:Think()

	if self.Entity:GetActiveTime() == 0 or self.Entity:GetActiveTime() > CurTime( ) then return end

	self.Entity:SetRenderBoundsWS( self.Entity:GetEndPos( ), self.Entity:GetPos( ) )
	
end

local matTripmineLaser 		= Material( "sprites/bluelaser1" )
local matLight 				= Material( "effects/blueflare1" )

function ENT:Draw()
	
	if self.Entity:GetActiveTime() == 0 or self.Entity:GetActiveTime() > CurTime() then return end
	
	local offset = CurTime() * 3
	local distance = self.Entity:GetEndPos():Distance( self.Entity:GetPos() )
	local size = math.Rand( 2, 4 )
	local normal = ( self.Entity:GetPos() - self.Entity:GetEndPos() ):GetNormal() * 0.1
	
	render.SetMaterial( matTripmineLaser )
	render.DrawBeam( self.Entity:GetEndPos(), self.Entity:GetPos(), 4, offset, offset + distance / 8, Color( 150, 150, 255, 50 ) )
	render.DrawBeam( self.Entity:GetEndPos(), self.Entity:GetPos(), 2, offset, offset + distance / 8, Color( 150, 150, 255, 50 ) )
	
	render.SetMaterial( matLight )
	render.DrawQuadEasy( self.Entity:GetEndPos() + normal, normal, size, size, Color( 150, 150, 255, 50 ), 0 )
	 
end

