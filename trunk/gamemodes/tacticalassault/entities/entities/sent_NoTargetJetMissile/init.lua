AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.MissileSound = NULL
ENT.ExplosionDel = CurTime() + 1
ENT.ExplodeOnce = 0
ENT.MissileForceDel = CurTime() + 5

function ENT:SpawnFunction( ply, tr ) 
 	ent:Spawn()
 	ent:Activate() 
 	ent.Owner = ply
	ent:GetPhysicsObject():SetMass(1)
	return ent 
	
end

function ENT:Initialize()


	self.Entity:SetModel("models/weapons/W_missile_closed.mdl")
	self.Entity:SetOwner(self.Owner)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	self.Entity:SetSolid(SOLID_VPHYSICS)	
    local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end

	util.SpriteTrail(self.Entity, 0, Color(200,200,200,255), false, 4, 0, 3, 1/(15+1)*0.5, "trails/smoke.vmt")

	
self.MissileSound = CreateSound(self.Entity,"weapons/rpg/rocket1.wav")
self.MissileSound:Play()
	self.Entity:SetCollisionGroup( 1 )
end

-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity
	
	if self.ExplosionDel < CurTime() then
		self.Entity:SetCollisionGroup( 3 )
	end
	
	if self.ExplodeOnce == 0 then
		self.ExplodeOnce = 1
		local expl = ents.Create("env_explosion")
		expl:SetKeyValue("spawnflags",128)
		expl:SetPos(self.Entity:GetPos())
		expl:Spawn()
		expl:Fire("explode","",0)
		
			local FireExp = ents.Create("env_physexplosion")
			FireExp:SetPos(self.Entity:GetPos())
			FireExp:SetParent(self.Entity)
			FireExp:SetKeyValue("magnitude", 500)
			FireExp:SetKeyValue("radius", 600)
			FireExp:SetKeyValue("spawnflags", "1")
			FireExp:Spawn()
			FireExp:Fire("Explode", "", 0)
			FireExp:Fire("kill", "", 5)
			util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 500, 100)
		
		local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetStart( Vector(0,0,90) )
		util.Effect( "jetbomb_explosion", effectdata )
		
		
		self.Entity:Remove()
	end
end
-------------------------------------------PHYSICS =D
function ENT:PhysicsUpdate( physics )
	local entphys = self.Entity:GetPhysicsObject()

	if self.MissileForceDel < CurTime() then
	entphys:ApplyForceCenter(self.Entity:GetForward() * 40000 )
	end
end
-------------------------------------------DAMAGE
function ENT:OnTakeDamage(dmg)

	if self.ExplosionDel < CurTime() then
		self.Entity:SetCollisionGroup( 3 )
	end

	if self.ExplosionDel < CurTime() and self.ExplodeOnce == 0 then
		self.ExplodeOnce = 1
		local expl = ents.Create("env_explosion")
		expl:SetKeyValue("spawnflags",128)
		expl:SetPos(self.Entity:GetPos())
		expl:Spawn()
		expl:Fire("explode","",0)
		
			local FireExp = ents.Create("env_physexplosion")
			FireExp:SetPos(self.Entity:GetPos())
			FireExp:SetParent(self.Entity)
			FireExp:SetKeyValue("magnitude", 500)
			FireExp:SetKeyValue("radius", 600)
			FireExp:SetKeyValue("spawnflags", "1")
			FireExp:Spawn()
			FireExp:Fire("Explode", "", 0)
			FireExp:Fire("kill", "", 5)
			util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 500, 100)
		
		local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetStart( Vector(0,0,90) )
		util.Effect( "jetbomb_explosion", effectdata )
		
		self.Entity:Remove()
	end
end
-------------------------------------------THINK
function ENT:Think()
	local entphys = self.Entity:GetPhysicsObject()

		entphys:Wake()

	if self.ExplosionDel < CurTime() then
	self.Entity:SetCollisionGroup( 3 )
	end
		
end

function ENT:OnRemove()
self.MissileSound:Stop()
end
