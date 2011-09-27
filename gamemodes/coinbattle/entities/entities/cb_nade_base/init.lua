
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    
	self.Entity:SetModel( "models/weapons/w_models/w_grenade_grenadelauncher.mdl" )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()

		local ang = self:GetOwner():GetAimVector():Angle()
		ang:RotateAroundAxis( ang:Right(), 15)
		self:SetAngles(ang)
		phys:AddVelocity(ang:Forward()*600)
		phys:AddAngleVelocity(VectorRand()*100)
	end

	local skin = 0
	if self:Team() == TEAM_CYAN then
		skin = 1
	end
	self:SetSkin(skin)

	timer.Simple(3,function(ent)
		if ent:IsValid() and ent:GetOwner():IsValid() then
			ent:DoExplode()
		end
	end, self)
    
end

function ENT:SetTeam(int)
	self.dt.CurTeam = int
end

function ENT:DoExplode(delay)
		
	util.BlastDamage(self, self:GetOwner(), self:GetPos(), 160, 50)
	local ED = EffectData()
	ED:SetOrigin(self:GetPos())
	util.Effect("explosion",ED)

	self:Remove()
	
end