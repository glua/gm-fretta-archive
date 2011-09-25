
include('shared.lua')

ENT.FriendMat = Material( "gta/defend" )
ENT.EnemyMat = Material( "gta/target" )

function ENT:Initialize()
	
end

function ENT:Think()

end

function ENT:Draw()
	
	local dist = LocalPlayer():GetPos():Distance( self.Entity:GetPos() )
	
	if dist > 1000 then return end
	
	if LocalPlayer():Team() == TEAM_GANG then
		
		render.SetMaterial( self.EnemyMat ) 
		
	elseif LocalPlayer():Team() == TEAM_POLICE then
		
		render.SetMaterial( self.FriendMat )
		
	end
	
	local size = ScrW() * 0.025
	local alpha = 255 - ( 255 * ( dist / 1000 ) )	
	
	render.DrawSprite( self.Entity:GetPos() + Vector(0,0,90), size * 2, size, Color( 255, 255, 255, alpha ) ) 
	
end



