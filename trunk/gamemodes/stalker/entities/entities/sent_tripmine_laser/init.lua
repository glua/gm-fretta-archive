
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Online = Sound( "NPC_Turret.Ping" )

function ENT:Initialize()

	self.Entity:DrawShadow( false )
	self.Entity:SetSolid( SOLID_BBOX )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:SetTrigger( true )
	
end

function ENT:Think()

	if self.Entity:GetActiveTime() == 0 or self.Entity:GetActiveTime() > CurTime() then return end
	if self.IsActivated then return end
	
	self.IsActivated = true
	
	local parent = self.Entity:GetParent()
	
	if not ValidEntity( parent ) then
	
		self.Entity:Remove()
	
	end
	
	parent:EmitSound( self.Online )

end


function ENT:Touch( ent )

	if self.Entity:GetActiveTime() == 0 or self.Entity:GetActiveTime() > CurTime() then return end
	
	local parent = self.Entity:GetParent()
	
	if not ValidEntity( parent ) then

		self.Entity:Remove()
	
	end
	
	if not ent:IsPlayer() then return end
	
	if ent:Team() == TEAM_STALKER then
		
		parent:DoAlarm( true )

	elseif ent:Team() == TEAM_HUMAN then
	
		parent:DoAlarm( false )
		
	end

end

