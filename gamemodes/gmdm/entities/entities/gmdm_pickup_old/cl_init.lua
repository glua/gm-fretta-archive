
include('shared.lua')

surface.CreateFont( "coolvetica", 24, 500, true, false, "GMDMPickup" )

local rtName 		= GetRenderTarget( "gmdmname", 128, 32, true )

local matLight 		= Material( "sprites/gmdm_pickups/light" )
local matCubeWall 	= Material( "sprites/gmdm_pickups/base" )
local matRefraction	= Material( "sprites/gmdm_pickups/base_r" )
local matStar		= Material( "sprites/gmdm_pickups/over" )
local matName		= Material( "sprites/gmdm_pickups/name" )

function ENT:Initialize()	

	self.Entity:SetCollisionBounds( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	self.Entity:SetSolid( SOLID_NONE )
	self.ColPercent = 0
	self.up = true
	
end


local FADETIME = 0.5

local function DrawBox( pos, size, rot, angrot )

	local Fwd = Vector( math.sin( rot ), math.cos( rot ), 0 )
	local Lft = Vector( math.sin( rot + math.pi/2 ), math.cos( rot + math.pi/2 ), 0 )
	
	render.DrawQuadEasy( pos - Fwd * size/2, Fwd, size, size, color_white, angrot )
	render.DrawQuadEasy( pos + Fwd * size/2, Fwd, size, size, color_white, angrot )
	render.DrawQuadEasy( pos - Lft * size/2, Lft, size, size, color_white, angrot )
	render.DrawQuadEasy( pos + Lft * size/2, Lft, size, size, color_white, angrot )
	
end

// MajorVictory
function FadeToColor(Color1, Color2, Percent)
	local NewColor = Color()
	for k,value in pairs(Color1) do
		NewColor[k] = Color1[k] + ((Color2[k] - Color1[k])*Percent)
	end
	return NewColor
end

function ENT:Think( )
	if self:GetActiveTime() > CurTime( ) then
		return
	end
	
	if self.up then
		self.ColPercent = self.ColPercent + ( 30 * FrameTime( ) )
	else
		self.ColPercent = self.ColPercent - ( 30 * FrameTime( ) )
	end
	
	if self.ColPercent <= 0 then
		self.up = true
	elseif self.ColPercent >= 10 then
		self.up = false
	end
	
	local dlight = DynamicLight( self:EntIndex( ) )
	
	local col = FadeToColor( Color( 20, 200, 10 ), Color( 200, 200, 10 ), self.ColPercent / 10 )
	
	if dlight then
		dlight.Pos = self:GetPos( )
		dlight.r = col.r
		dlight.g = col.g
		dlight.b = col.b
		dlight.Brightness = 3
		dlight.Decay = 200
		dlight.size = 100
		dlight.DieTime = CurTime( ) + .1
	end
end

function ENT:Draw()

	if ( self:GetActiveTime() > CurTime() ) then return end
	
	GAMEMODE:DrawPickupWorldModel( self, true )
	
	local Pos = self:GetPos( )
	
	// Distance from eye to pos
	local Distance = ( 1.0 - EyePos():Distance( Pos ) / 512 )
	
	// Draw the base of the box
	// Having 2 boxes here gives a cool looking inside of the box
	render.SetMaterial( matCubeWall )
	DrawBox( Pos, 30, CurTime(), 180 )
	DrawBox( Pos, 31, CurTime(), 180 )
	
	// Draw the 'Skin' on top of the box
	render.SetMaterial( matStar )
	DrawBox( Pos, 38 + math.sin( CurTime() * 20 ) * 5, CurTime(), 180 )
	
	render.SetMaterial( matName )	
	matName:SetMaterialTexture( "$basetexture", rtName )
	local rot = CurTime()
	local Fwd = Vector( math.sin( rot ), math.cos( rot ), 0 )
	local Lft = Vector( math.sin( rot + math.pi/2 ), math.cos( rot + math.pi/2 ), 0 )
	
	render.DrawQuadEasy( Vector(0,0,-11) + Pos - Fwd * 36/2, Fwd*-1, 32, 8, color_white, 180 )
	render.DrawQuadEasy( Vector(0,0,-11) + Pos + Fwd * 36/2, Fwd, 32, 8, color_white, 180 )
	render.DrawQuadEasy( Vector(0,0,-11) + Pos - Lft * 36/2, Lft*-1, 32, 8, color_white, 180 )
	render.DrawQuadEasy( Vector(0,0,-11) + Pos + Lft * 36/2, Lft, 32, 8, color_white, 180 )
end
