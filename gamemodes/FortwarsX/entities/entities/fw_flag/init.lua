
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include( "shared.lua" )
 
function ENT:Initialize()

	self.Entity:SetModel( "models/fw/fw_flag.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )  
	
	local phys = self.Entity:GetPhysicsObject()
	if ( phys:IsValid() ) then
		phys:Sleep() //ZZZZZzzzzzz.....
	end

end

function ENT:OnTakeDamage( dmg )
	self.Entity:TakePhysicsDamage( dmg ) 
end
 
function ENT:PhysicsUpdate()
	//Flags don't need updating physics!
end