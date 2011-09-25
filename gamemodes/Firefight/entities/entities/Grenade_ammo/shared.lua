ENT.Type = "anim"
--ENT.Base = "base_gmodentity"
 
AddCSLuaFile( "shared.lua" )
include('shared.lua')
 
if CLIENT then
	function ENT:Draw()
    self.Entity:DrawModel()
	end
end

if !SERVER then return end
 
function ENT:Initialize()
 
	self.Entity:SetModel( "models/Weapons/w_bugbait.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   
	self.Entity:SetSolid( SOLID_VPHYSICS )       
 
    local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end
 
function ENT:PhysicsCollide(data, obj)
	local vPoint = data.HitPos
	local effectdata = EffectData()
	effectdata:SetStart( vPoint ) 
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	util.Effect( "Explosion", effectdata )	
	
	local attacker 
	if self.Entity:GetOwner():IsPlayer() then
		attacker = self.Entity:GetOwner()
	else
		attacker = self.Entity
	end
	
	util.BlastDamage(self.Entity, attacker, self.Entity:GetPos(), 300, 60)
	self.Entity:Remove()
end
 
function ENT:Think()
end
 
 