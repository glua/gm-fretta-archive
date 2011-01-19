include('shared.lua')

local electricity = Material( "sprites/rollermine_shock" )
function ENT:Initialize()
end

function ENT:Draw()
self.Entity:DrawModel()
local pos = self:GetPos()

render.SetMaterial( electricity ) 
	local enhit = self:GetPos() + Vector( math.Rand(-40,40), math.Rand(-40,40), math.Rand(-10,30) )
	local dirmins = ( enhit - self:GetPos() )
	
	render.StartBeam( 7 )
	render.AddBeam( pos , 16, 0, Color( 255, 255, 255, 255 ) )
	for i=2, (6) do
		local curpos = pos + (i/7) * dirmins + VectorRand() * 40
		render.AddBeam( curpos , 50, CurTime() + i/5, Color( 255, 255, 255, 255 ) )
	end
	
	render.AddBeam( enhit , 16, 1, Color( 255, 255, 255, 255 ) )
	render.EndBeam()

	local dlight = DynamicLight( self.Entity:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 20
		dlight.g = 100
		dlight.b = 255	
		dlight.Brightness = 4 * math.Rand( 0.8, 1.0 )
		dlight.Decay = 128
		dlight.size = 1024 * math.Rand( 0.8, 1.0 )
		dlight.DieTime = CurTime() + 0.2
	end
end

function ENT:DrawTranslucent()
	self.Entity:DrawModel()
end

function ENT:Think()
end 
