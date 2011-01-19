AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

util.PrecacheModel( "models/items/ar2_grenade.mdl" )

function ENT:Initialize()

	self:SetModel( "models/items/ar2_grenade.mdl" )
	
	self:DrawShadow( false )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:StartMotionController()
	
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
	
		phys:EnableCollisions( true )
		phys:EnableDrag( false )
		phys:EnableGravity( false )
		phys:SetMass( 999 )
		phys:Wake()
		
	end
	
	self.RicoSound = Sound("npc/manhack/mh_blade_snick1.wav")
	self.HitFlechette = Sound("npc/roller/blade_in.wav")
	self.HitFlesh1 = Sound("weapons/crossbow/bolt_skewer1.wav")
	self.HitFlesh2 = Sound("physics/flesh/flesh_impact_bullet1.wav")
	self.HitSound = Sound("npc/roller/blade_out.wav")
	self.Break = Sound("physics/glass/glass_impact_bullet1.wav")

	self.Trail = util.SpriteTrail( self, 0, Color(250,50,50,250), false, 2, 1, 0.20, 1/32 * 0.5, "trails/plasma.vmt" )
	
end

function ENT:Think()
	
	if self.DieTime then
		if self.DieTime < CurTime() then
			self:DoExplode() 
		end
	end
	
	self:NextThink(CurTime())
	
	return true
	
end

function ENT:PhysicsUpdate( phys, deltatime )

	if self.HitWeld then 
	
		phys:EnableGravity( true ) 
		phys:EnableDrag( true )
		return SIM_NOTHING 
		
	end
	
	phys:Wake()
	phys:SetVelocityInstantaneous( self:GetAngles():Forward():Normalize() * 99999 )
	phys:AddAngleVelocity( Angle( 0, 0.15, 0 ) )
	
end

function ENT:DoExplode()

	self:EmitSound( self.Break, 100, math.random(90,110) )
	
	for i=1,10 do
		
		local dir =  ( ( self:GetAngles():Forward() * -1 ):Angle() + Angle( math.random(-20,20), math.random(-20,20), math.random(-20,20) ) ):Forward()
		
		local bullet = {}
		bullet.Num 		= 1
		bullet.Src 		= self:GetPos()		
		bullet.Dir 		= dir	
		bullet.Spread 	= Vector(0,0,0)	
		bullet.Tracer	= 1	
		bullet.Force	= 200						
		bullet.Damage	= 1
		bullet.AmmoType = "Pistol"
		bullet.TracerName 	= "flechette_tracer"
		bullet.Callback = function ( attacker, tr, dmginfo ) 
			if tr.Entity:IsPlayer() then
				tr.Entity:TakeDamage( 40, self:GetOwner(), self )
				tr.Entity:EmitSound( self.HitFlechette, 100, math.random(120,140) )
			elseif SERVER then
				WorldSound( self.RicoSound, tr.HitPos, 100, math.random(100,150) )
			end
		end
		
		if( ValidEntity( self:GetOwner() ) ) then
			self:GetOwner():FireBullets(bullet)
		end
		
	end
	
	self.Trail:Remove()
	self:Remove()
	
end

function ENT:Touch(ent)

	if ent:IsPlayer() or string.find(ent:GetClass(),"prop_phys") then
	
		if ent == self:GetOwner() or self.HitWeld then return end
		
		if ent:IsPlayer() then
		
			ent:TakeDamage( 100, self.Entity:GetOwner(), self )
			self:EmitSound( self.HitFlesh1, 100, math.random( 130, 140 ) )
			self:EmitSound( self.HitFlesh2, 100, math.random( 130, 140 ) )
			
			self.Trail:Remove()
			self:Remove()
			
		else
		
			self.HitWeld = self:Weld( ent )
			self.DieTime = CurTime() + 5
			self:EmitSound( self.HitSound, 100, math.random(130,150) )
			
		end

	end
	
end

function ENT:Weld( ent )
	return constraint.Weld( ent, self, 0, 0, 0, true )
end

function ENT:PhysicsCollide( data, phys )

	if data.HitEntity:IsWorld() and not self.HitWeld then
	
		self.DieTime = CurTime() + 5
		self:EmitSound( self.HitSound, 100, math.random(130,150) )
		phys:EnableMotion( false )

	end
	
end


