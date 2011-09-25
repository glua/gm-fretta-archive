AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 20 )
	ent:Spawn()
	ent:Activate()	
	
	return ent

end


function ENT:Initialize()	

	self:SetModel( "models/props_junk/wood_crate001a.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()  	
	if phys:IsValid() then  		
		phys:Wake()  	
	end
	
	self:SetMoveType(MOVETYPE_NONE)
	
end


function ENT:Think()
	
end


function ENT:OnRemove()
end







