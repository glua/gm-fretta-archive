AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

ENT.Damage = 50
ENT.Shadow = {}

function ENT:Initialize()

	self.Entity:SetModel( "models/Roller.mdl" )
	
	self.Entity:PhysicsInitSphere( 20 )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetTrigger( true )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:EnableGravity( false )
	
	end
	
	self.Entity:StartMotionController()
	
end

function ENT:Think() 

end

function ENT:PhysicsSimulate( phys, deltatime )
	
	local dir = self.Entity:GetAngles() + Angle(15,0,0)
	
	self.Shadow.secondstoarrive = 1 
	self.Shadow.pos = self.Entity:GetPos() + self.Entity:GetForward() * 500 
	self.Shadow.angle = dir
	self.Shadow.maxangular = 100
	self.Shadow.maxangulardamp = 100
	self.Shadow.maxspeed = 10000
	self.Shadow.maxspeeddamp = 10000
	self.Shadow.dampfactor = 0.5 
	self.Shadow.teleportdistance = 0 
	self.Shadow.deltatime = deltatime 

	phys:Wake()
	phys:ComputeShadowControl( self.Shadow )
	
end

function ENT:Touch( ent )

	if not ValidEntity( self.Entity:GetOwner() ) then
	
		self.Entity:Remove()
		return
	
	end

	if ValidEntity( ent ) and ent:IsPlayer() and ent:Team() != self.Entity:GetOwner():Team() then

		ent:TakeDamage( self.Damage, self.Entity:GetOwner(), self.Entity )
		ent:DoIgnite( self.Entity:GetOwner() )
		
		local dir = ( self.Entity:GetOwner():GetPos() - self.Entity:GetPos() ):Normalize()
		
		self.Entity:Explode( dir )
		self.Entity:Remove()
	
	end

end

function ENT:PlaceFlames()

	local pos = self.Entity:GetPos()
	
	local trace = {}
	trace.start = pos
	trace.endpos = pos + Vector( 0, 0, -200 )
	trace.mask = MASK_SOLID_BRUSHONLY
	
	local tr = util.TraceLine( trace )
	
	if not tr.Hit then return end
		
	local flame = ents.Create( "sent_flame_immobile" )
	flame:SetPos( tr.HitPos )
	flame:SetOwner( self.Entity:GetOwner() )
	flame:Spawn()

end

function ENT:Explode( dir )

	self.Entity:PlaceFlames()
	self.Entity:EmitSound( table.Random( GAMEMODE.PlasmaExplosion ), 100, math.random(90,110) )
	
	util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 200, self.Damage )
	util.ScreenShake( self.Entity:GetPos(), math.Rand(3,6), math.Rand(3,6), math.Rand(3,6), 400 ) 

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	ed:SetNormal( dir )
	util.Effect( "plasma_explosion", ed, true, true )

end

function ENT:PhysicsCollide( data, phys )
	
	self.Entity:Explode( data.HitNormal )
	self.Entity:Remove()
	
end

