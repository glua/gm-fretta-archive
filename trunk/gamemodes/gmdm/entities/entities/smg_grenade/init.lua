
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local Grenade_Sound = Sound( "npc/headcrab/headcrab_burning_loop2.wav" )
local Bounce_Sound = Sound( "physics/concrete/rock_impact_hard4.wav" )


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	// Use the helibomb model just for the shadow (because it's about the same size)
	self.Entity:SetModel( "models/props_c17/lamp001a.mdl" )
	
	// Don't use the model's physics - create a sphere instead
	self.Entity:PhysicsInitSphere( 16, "metal_bouncy" )
	
	// Wake the physics object up. It's time to have fun!
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetDamping( 0.2, 0 )
		phys:AddAngleVelocity( VectorRand() * 360 )
	end
	
	// Set collision bounds exactly
	self.Entity:SetCollisionBounds( Vector()*-16, Vector()*16 )
	
	self.ExplodeTime = CurTime() + self.FuseLength
	self.Entity:SetNetworkedFloat( "ExplodeTime", self.ExplodeTime )
	
	self.Sound = CreateSound( self.Entity, Grenade_Sound )
	self.Sound:SetSoundLevel( 80 )
	self.Sound:Play()
	self.Sound:ChangePitch( 255, self.FuseLength )
	self.Sound:ChangeVolume( 10, 0.1 )
	
	
	//self.SpriteTrail1 = util.SpriteTrail( self, 0, Color(100, 200, 255), true, 16, 0, 4, 0, "sprites/bluelaser1.vmt" )
	//self.SpriteTrail2 = util.SpriteTrail( self, 0, Color(255, 255, 255), true, 64, 0, 2, 0, "sprites/bluelaser1.vmt" )

	self.SpriteTrail1 = util.SpriteTrail( self, 0, Color(30, 50, 30), true, 16, 0, 4, 0, "sprites/bluelaser1.vmt" )
	self.SpriteTrail2 = util.SpriteTrail( self, 0, Color(30, 50, 30), true, 64, 0, 2, 0, "sprites/bluelaser1.vmt" )
	
	
end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:OnRemove()

	if ( self.Sound ) then
	
		self.Sound:Stop()
	
	end
	
end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Think()

	if ( self.ExplodeTime > CurTime() ) then return end
	
	self:Explode()
	
end

function ENT:Explode()

	if ( self.Exploded ) then return end
	
	self.Exploded = true
	
	self.SpriteTrail1:SetParent( NULL )
	self.SpriteTrail2:SetParent( NULL )
	
	SafeRemoveEntityDelayed( self.SpriteTrail1, 4 )
	SafeRemoveEntityDelayed( self.SpriteTrail2, 4 )
	
	GMDM_Explosion_Electric( self.Entity:GetPos(), self.Entity:GetOwner(), self.Entity, 110, 512, 1 )

	self.Entity:Remove()

end

/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )
	
	if ( data.HitEntity && data.HitEntity:IsValid() && data.HitEntity:IsPlayer() ) then
	
		self:Explode()
	
	end
	
	// Play sound on bounce
	if (data.Speed > 80 && data.DeltaTime > 0.2 ) then
	
		self.Entity:EmitSound( Bounce_Sound, 80 )
		
		local effectdata = EffectData()
			effectdata:SetOrigin( data.HitPos )
			effectdata:SetScale( data.Speed )
		util.Effect( "fireball_bounce", effectdata )
	
	end
	
	// Bounce like a crazy bitch
	local LastSpeed = data.OurOldVelocity:Length()
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * 0.7
	
	physobj:SetVelocity( TargetVelocity )
	
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )

	// React physically when shot/getting blown
	self.Entity:TakePhysicsDamage( dmginfo )
	
	// Explode now, but delayed
	self.ExplodeTime = CurTime() + 0.1
	
end


/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use( activator, caller )

	self.Entity:Remove()
	
	if ( activator:IsPlayer() ) then
	
		// Give the collecting player some free health
		local health = activator:Health()
		activator:SetHealth( health + 5 )
		
	end

end



