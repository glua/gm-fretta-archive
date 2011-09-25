AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Damage = 100
ENT.Shadow = {}

function ENT:Initialize()

	self.Entity:SetModel( "models/weapons/w_missile.mdl" )
	self.Entity:PhysicsInitSphere( 5 )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:EnableGravity( false )
		phys:ApplyForceCenter( self.Entity:GetAngles():Forward() * 500 )
		phys:SetDamping( 0, 2000 )
	
	end
	
	self.Entity:StartMotionController()
	
end

function ENT:Think()

end

function ENT:PhysicsSimulate( phys, deltatime )
	
	local dir = self.Entity:GetAngles() + Angle(8,0,0)
	
	self.Shadow.secondstoarrive = 1 
	self.Shadow.pos = self.Entity:GetPos() + self.Entity:GetForward() * 800 
	self.Shadow.angle = dir
	self.Shadow.maxangular = 50
	self.Shadow.maxangulardamp = 100
	self.Shadow.maxspeed = 100000
	self.Shadow.maxspeeddamp = 10000
	self.Shadow.dampfactor = 0.5 
	self.Shadow.teleportdistance = 0 
	self.Shadow.deltatime = deltatime 

	phys:Wake()
	phys:ComputeShadowControl( self.Shadow )
	
end

function ENT:PhysicsCollide( data, phys )

	local ed = EffectData()
	ed:SetOrigin( data.HitPos )
	ed:SetNormal( data.HitNormal * -1 )
	util.Effect( "bomb_explosion", ed, true, true )
	
	if data.HitEntity:IsPlayer() then
		
		data.HitEntity:SetHealth( math.Clamp( data.HitEntity:Health() / 2, 1, 100 ) )
		
	end

	self.Entity:Explode( self.Entity:GetPos() )
	self.Entity:Remove()

end

function ENT:Explode( pos )
	
	util.BlastDamage( self.Entity, self.Entity:GetOwner(), pos, 200, self.Damage )
	util.ScreenShake( self.Entity:GetPos(), math.Rand(3,6), math.Rand(3,6), math.Rand(3,6), 400 ) 
	
	self.Entity:EmitSound( table.Random( GAMEMODE.BombExplosion2 ), 100, math.random(90,110) )
	
end
