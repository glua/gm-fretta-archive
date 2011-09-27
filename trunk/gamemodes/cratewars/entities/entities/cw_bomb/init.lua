AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/Items/AR2_Grenade.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
		
	local phys = self.Entity:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:PhysicsCollide( data, physobj )	
	local effectdata = EffectData()
	effectdata:SetOrigin(self.Entity:GetPos())
	util.Effect( "Explosion", effectdata )
	local boxes = ents.FindInSphere(self.Entity:GetPos(), 75)
	for k, v in pairs(boxes) do
		if( v:GetClass() == "box_ent" ) or ( v:IsPlayer() ) then
			if ( v:GetNWEntity("OwnerObj") == NULL ) then 
				if( v.IsNeutral ) then
					v:Remove()
					GAMEMODE:addStat(self.Entity:GetOwner(), "broken", 1)
				end
			else
				GAMEMODE:addStat(self.Entity:GetOwner(), "broken", 1)
				v:Remove()
			end
		end
	end
	self.Entity:Remove() 
end