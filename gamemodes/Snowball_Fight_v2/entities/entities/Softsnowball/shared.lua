ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName			= "Snowball"
ENT.Author			= "NECROSSIN"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

if SERVER then

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self.Entity:SetModel("models/weapons/w_snowball_thrown.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass(1)
		phys:Wake()
	end	
	
end

function ENT:PhysicsCollide( data, physobj )
		-- if it is a player
		if data.HitEntity and data.HitEntity:IsValid() and data.HitEntity:IsPlayer() and data.HitEntity != self.Entity:GetOwner() then
			
			--data.HitEntity = p
			self.Entity:EmitSound("player/footsteps/snow"..math.random(1,6)..".wav")
			
			data.HitEntity:ViewPunch(Angle(math.random(-1, 1), math.random(-1, 1), math.random(-10, 10)))
			data.HitEntity:TakeDamage( math.random(5,5), self.Entity:GetOwner() )
			
			umsg.Start( "SnowHit", data.HitEntity )
			umsg.End()
			
			local Pos1 = data.HitPos + data.HitNormal
			local Pos2 = data.HitPos - data.HitNormal
			util.Decal("PaintSplatBlue", Pos1, Pos2) 
			
			self.Entity:Remove()
		-- if it is an entity (not a player)	
		elseif data.HitEntity and data.HitEntity:IsValid() and !data.HitEntity:IsPlayer() then
		
			local Pos1 = data.HitPos + data.HitNormal
			local Pos2 = data.HitPos - data.HitNormal
			util.Decal("PaintSplatBlue", Pos1, Pos2) 
			self.Entity:EmitSound("player/footsteps/snow"..math.random(1,6)..".wav")
			self.Entity:Remove()
		-- if its a world	
		else
		
			local Pos1 = data.HitPos + data.HitNormal
			local Pos2 = data.HitPos - data.HitNormal
			util.Decal("PaintSplatBlue", Pos1, Pos2) 
			self.Entity:EmitSound("player/footsteps/snow"..math.random(1,6)..".wav")
			self.Entity:Remove()
			
		end
end

end

if CLIENT then

function ENT:Draw()

	self.Entity:DrawModel()
	--cool snow effect :p
	local Emitter = ParticleEmitter(self.Entity:GetPos())

	if self.Entity:GetVelocity():Length() > 28 and math.random(1,3) == 2 then
		local particle = Emitter:Add("effects/blood_drop", self.Entity:GetPos())
		particle:SetVelocity(VectorRand() * 15)
		particle:SetDieTime(3)
		particle:SetStartAlpha(255)
		particle:SetStartSize(10)
		particle:SetEndSize(1)
		particle:SetRoll(180)
		particle:SetColor(255, 255, 255)
		--particle:SetLighting(true)
	end
	
end

end
