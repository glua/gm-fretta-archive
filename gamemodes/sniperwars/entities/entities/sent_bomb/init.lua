AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

util.PrecacheModel("models/props_junk/garbage_glassbottle001a.mdl")

function ENT:Initialize()

	self:SetModel("models/props_junk/garbage_glassbottle001a.mdl")
	self:SetMaterial("models/props_wasteland/wood_fence01a")
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:EnableCollisions(true)
		phys:EnableDrag(false)
		phys:EnableGravity(true)
		phys:Wake()
	end
	
	self.Damage = 200
	
	self.Explode = Sound("ambient/explosions/explode_6.wav")
	
end

function ENT:Think()

end

function ENT:DoExplode()
	
	local trace = {}
	trace.start = self.Entity:GetPos() + VectorRand() * 10
	trace.endpos = trace.start + Vector(0,0,-250)
	trace.filter = self
	local tr = util.TraceLine(trace)
	
	if tr.HitWorld then
		util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
	end

	local pos = self.Entity:GetPos()

	local ed = EffectData()
	ed:SetOrigin( pos )
	util.Effect("nuke_explode", ed)
	
	if not ValidEntity( self.Entity:GetOwner() ) then
	
		self.Entity:Remove()
		return
		
	end
	
	for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
		if v:GetPos():Distance( pos ) < 500 then
			if not v:IsPlayer() then
				local phys = v:GetPhysicsObject()
				if phys:IsValid() then
					v:SetPhysicsAttacker( self.Entity:GetOwner() )
					local dir = ( v:GetPos() - self.Entity:GetPos() ):Normalize()
					phys:ApplyForceCenter( dir * ( 1500 * ( phys:GetMass() / 2 ) ) )
				end
			end
		end
	end
	
	util.BlastDamage( self.Entity, self.Entity:GetOwner(), pos, 600, self.Damage )

	self.Entity:EmitSound( Sound(table.Random(GAMEMODE.BombExplosion)), 100, math.random(90,120) )
	self.Entity:Remove()
	
end

function ENT:PhysicsCollide( data, physobj )

	self:DoExplode()
	
end

