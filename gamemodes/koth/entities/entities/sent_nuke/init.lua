AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

util.PrecacheModel( "models/props_junk/garbage_glassbottle001a.mdl" )

ENT.Damage = 200
ENT.Explode = Sound( "ambient/explosions/explode_6.wav" )
ENT.Warn = Sound( "buttons/button8.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/props_junk/garbage_glassbottle001a.mdl" )
	self.Entity:SetMaterial( "models/props_wasteland/wood_fence01a" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		phys:Wake()
	end
	
	self.DieTime = CurTime() + 0.4

	self.Entity:EmitSound( self.Warn, 100, 80 )
	
end

function ENT:Think()

	if self.DieTime < CurTime() then 
	
		self.Entity:DoExplode()
		self.DieTime = nil
		
	end
end

function ENT:DoExplode()

	local trace = {}
	trace.start = self.Entity:GetPos() + VectorRand() * 20
	trace.endpos = trace.start + Vector(0,0,-250)
	trace.filter = self
	local tr = util.TraceLine( trace )
	
	if tr.HitWorld then
		util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	end

	local pos = self.Entity:GetPos()

	local ed = EffectData()
	ed:SetOrigin( pos )
	util.Effect( "nuke_explode", ed )
	
	for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
		if v:GetPos():Distance( pos ) < 500 then
			if not v:IsPlayer() then
				local phys = v:GetPhysicsObject()
				if ValidEntity( phys ) then
					v:SetPhysicsAttacker( self.Entity:GetOwner() )
					local dir = ( v:GetPos() - self.Entity:GetPos() ):Normalize()
					phys:ApplyForceCenter( dir * ( 1500 * ( phys:GetMass() / 2 ) ) )
				end
			end
		end
	end
	
	util.BlastDamage( self, self.Entity:GetOwner(), self.Entity:GetPos(), 500, self.Damage )
	
	local rad = ents.Create( "sent_radiation" )
	rad:SetPos( pos )
	rad:SetOwner( self.Entity:GetOwner() )
	rad:SetPlayer()
	rad:SetDamage( 120 )
	rad:Spawn()
	
	self.Entity:GetOwner():TakeDamage( 100, self.Entity:GetOwner() )

	self.Entity:EmitSound( self.Explode, 100, math.random(90,120) )
	self.Entity:Remove()
	
end

function ENT:PhysicsCollide( data, physobj )
	
end

