AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Damage = 300
ENT.Incoming = Sound( "weapons/mortar/mortar_shell_incomming1.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/props_junk/propane_tank001a.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:ApplyForceCenter( self.Entity:GetOwner():GetForward() * 500 )
	
	end
	
end

function ENT:Think()

	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,-1500)
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	if tr.HitWorld and not self.EmitOnce then
	
		self:EmitSound( self.Incoming, 100, math.random(70,90) )
		self.EmitOnce = true
		
	end

end

function ENT:PhysicsCollide( phys, delta )

	self.Entity:Remove()
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,-200)
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )

	if tr.HitWorld then
	
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetMagnitude( 1.25 )
		util.Effect( "smoke_crater", ed, true, true )
		
		util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	
	end
	
end

function ENT:OnRemove()

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "mininuke_explosion", ed, true, true )
	
	self.Entity:EmitSound( table.Random( GAMEMODE.BombExplosion ), 100, math.random(90,110) )
	
	util.ScreenShake( self.Entity:GetPos(), math.Rand(3,6), math.Rand(3,6), math.Rand(3,6), 600 ) 
	util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 400, self.Damage )
	
end