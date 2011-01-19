include( "shared.lua" )

local matTripmineLaser 		= Material( "tripmine_laser" )
local matLight 				= Material( "sprites/gmdm_pickups/light" )
local colBeam				= Color( 100, 250, 245, 50 )

function ENT:Think( )
	if self:GetActiveTime( ) == 0 or self:GetActiveTime( ) > CurTime( ) then return end
	
	self:SetRenderBoundsWS( self:GetEndPos( ), self:GetPos( ) )
end

function ENT:Draw( )
	if self:GetActiveTime( ) == 0 or self:GetActiveTime( ) > CurTime( ) then return end
	
	render.SetMaterial( matTripmineLaser )
	
	local TexOffset = CurTime( ) * 3
	
	local Distance = self:GetEndPos( ):Distance( self:GetPos( ) )
	
	
	render.DrawBeam( self:GetEndPos( ), self:GetPos( ), 8, TexOffset, TexOffset + Distance / 8, colBeam )
	render.DrawBeam( self:GetEndPos( ), self:GetPos( ), 4, TexOffset, TexOffset + Distance / 8, colBeam )
	
	render.SetMaterial( matLight )
	local size = math.Rand( 4, 8 )
	local normal = ( self:GetPos( ) - self:GetEndPos( ) ):GetNormal( ) * 0.1
	render.DrawQuadEasy( self:GetEndPos( ) + normal, normal, size, size, colBeam, 0 )
	local size = math.Rand( 8, 16 )
	render.DrawQuadEasy( self:GetPos( ) + ( self:GetRight( ) ), self:GetRight( ), size, size, colBeam, 0 )
end
