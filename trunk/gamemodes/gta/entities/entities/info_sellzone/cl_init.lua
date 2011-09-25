
include('shared.lua')

ENT.DropMat = Material( "gta/dropoff" )

function ENT:Initialize()
	
end

function ENT:Think()

end

function ENT:Draw()
	
	local dist = LocalPlayer():GetPos():Distance( self.Entity:GetPos() )
	local size = ScrW() * 0.050	
	local alpha = 0
	
	if LocalPlayer():Team() == TEAM_GANG and ValidEntity( LocalPlayer():GetNWEntity( "Car", nil ) ) then
		
		dist = math.Clamp( dist, 0, 1000 )
		alpha = 255 * ( dist / 1000 )
		
	elseif LocalPlayer():Team() == TEAM_POLICE then
		
		dist = math.Clamp( dist, 0, 2500 )
		alpha = 255 - ( 255 * ( dist / 2500 ) )
		
	end
	
	render.SetMaterial( self.DropMat ) 
	render.DrawSprite( self.Entity:GetPos(), size * 2, size, Color( 255, 255, 255, alpha ) ) 
	
end



