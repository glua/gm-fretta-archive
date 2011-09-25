AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Damage = 45
ENT.Shadow = {}

function ENT:Initialize()

	self.Entity:SetModel( "models/weapons/w_missile.mdl" )
	self.Entity:PhysicsInitSphere( 10, "metal_bouncy" )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:EnableGravity( false )
		phys:ApplyForceCenter( self.Entity:GetAngles():Forward() * 500 )
		phys:SetDamping( 0, 20000 )
	
	end
	
	self.Entity:StartMotionController()
	
end

function ENT:SetTarget( ent )

	self.Target = ent

end

function ENT:Think()

	if not ValidEntity( self.Target ) then return end
	
	if ( self.Target:IsPlayer() and !self.Target:Alive() ) then
	
		self.Entity:SetTarget()
		return
	
	end

	if self.Entity:GetPos():Distance( self.Target:GetPos() ) < 100 then
	
		self.Entity:Remove()
	
	end

end

function ENT:PhysicsSimulate( phys, deltatime )

	if not ValidEntity( self.Target ) then return SIM_NOTHING end
	
	local dir = ( self.Target:GetPos() - self.Entity:GetPos() ):Normalize():Angle()
	
	self.Shadow.secondstoarrive = 1 
	self.Shadow.pos = self.Entity:GetPos() + self.Entity:GetForward() * 600 
	self.Shadow.angle = dir
	self.Shadow.maxangular = 150
	self.Shadow.maxangulardamp = 200
	self.Shadow.maxspeed = 100000
	self.Shadow.maxspeeddamp = 10000
	self.Shadow.dampfactor = 0.5 
	self.Shadow.teleportdistance = 0 
	self.Shadow.deltatime = deltatime 

	phys:Wake()
	phys:ComputeShadowControl( self.Shadow )
	
end

function ENT:PhysicsCollide( phys, delta )

	self.Entity:Remove()

end

function ENT:OnRemove()

	local ed = EffectData()
	ed:SetOrigin( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) )
	util.Effect( "heatseeker_explosion", ed, true, true )
	
	self.Entity:EmitSound( table.Random( GAMEMODE.BombExplosion2 ), 100, math.random(90,110) )
	
	util.ScreenShake( self.Entity:GetPos(), math.Rand(3,6), math.Rand(3,6), math.Rand(3,6), 400 ) 
	util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 100, self.Damage )
	
end
