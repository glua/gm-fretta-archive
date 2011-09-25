
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
	
function ENT:SpawnFunction( hitEnt, tr )
   
 	if ( !tr.Hit ) then return end 
 	
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 
 	
 	local ent = ents.Create( "grabber" )
		ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
 	
	return ent 
 	
end

function ENT:Initialize()
	
	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )

	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )

 	local phys = self:GetPhysicsObject()
 	if (phys:IsValid()) then
		phys:Wake() 
 	end
	
	self:SetMaterial("Models/effects/splodearc_sheet")
	self:SetColor(0,180,0,100)
	
	self:DrawShadow( false )
	self.Entity:SetCollisionBounds( Vector( -65, -65, -65 ), Vector( 65, 65, 65 ) )
	
end

function ENT:OnTakeDamage( dmginfo )

 	self:TakePhysicsDamage( dmginfo )
	
end

function ENT:Think()

	if !self:GetOwner():Alive() then
		SafeRemoveEntity(self)
	end
	local cacti = ents.FindInSphere(self:GetPos(), 200)
	for k,v in pairs(cacti) do
		if v:GetClass() == "cactus" then
			if v:GetCactusType() != "explosive" then
				self:GetOwner():CaughtCactus(v)
			end
		end
	end
	
end

function ENT:Remove()
	
end
