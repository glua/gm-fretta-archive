AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

function ENT:Initialize()

	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self.BurnTime = 0
	
end

function ENT:Think()
	
	if self.BurnTime < CurTime() then
	
		self.BurnTime = CurTime() + 0.2
		
		for k,v in pairs( team.GetPlayers( TEAM_ALIVE ) ) do
		
			local dist = v:GetPos():Distance(self:GetPos())
		
			if dist < 500 and v:Alive() then
			
				local scale = math.Clamp(  dist / 800, 0.2, 1.0 )
				v:AddRadiation( math.random( 1, 5 ), scale )
				
			end
		end
	end
end

function ENT:PhysicsCollide( data, phys )
	
end