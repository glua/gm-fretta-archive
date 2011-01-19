
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheModel("models/weapons/ar2_grenade.mdl")

local Start_Sound = Sound("npc/scanner/scanner_nearmiss2.wav")
local Bounce_Sound = Sound("physics/concrete/concrete_block_impact_hard1.wav")

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:SetModel("models/weapons/ar2_grenade.mdl")
	
	// Don't use the model's physics - create a sphere instead
	self.Entity:PhysicsInitSphere( 4, "metal_bouncy" )
	
	// Wake the physics object up. It's time to have fun!
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetDamping( .0001, .0001 )
	end
	
	// Make it face the right way
	self.Entity:SetAngles(self.Entity:GetOwner():GetAimVector():Angle())
	
	// Set collision bounds exactly
	self.Entity:SetCollisionBounds( Vector()*-4, Vector()*4 )
	
	self:StartMotionController()
	
	// Sprite trail (white) 
	self.Trail = util.SpriteTrail(self, 0, Color(250, 230, 200, 250), false, 2, 1, 0.10, 1/32 * 0.1, "trails/plasma.vmt")
	
	self.Activator = CurTime() + math.Rand(1,3)
	self.FlyAngle = self:GetAngles()
	
	self:EmitSound(Start_Sound)
	
end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:OnRemove()
	
end

function ENT:Think() 

	if self.Activator < CurTime() then
		self.Dead = true
	end

	if self.Dead then
		self:Explode()
	end
	
	if self.Activated then
		if self.Activated < CurTime() then
			self.Dead = true
		end
	end
	
end

/*---------------------------------------------------------
   Name: Explode
---------------------------------------------------------*/
function ENT:Explode()

	if ( self.Exploded ) then return end
	
	self.Exploded = true
	
	GMDM_Explosion( self.Entity:GetPos(), self.Entity:GetOwner(), self.Entity, 30, 200, 1 )

	self.Trail:Remove()
	self.Entity:Remove()

end

/*---------------------------------------------------------
   Name: Physics sim
---------------------------------------------------------*/
function ENT:PhysicsSimulate( phys, deltatime )

	if self.Dead or not self.Activated then return SIM_NOTHING end
		
	local fSin = math.sin( CurTime() * 20 ) * 1.1
	local fCos = math.cos( CurTime() * 20 ) * 1.1
	
	local vAngular = Vector(0,0,0)
	local vLinear = (self.FlyAngle:Right() * fSin) + (self.FlyAngle:Up() * fCos)
	vLinear = vLinear * deltatime * 1.001

	return vAngular, vLinear, SIM_GLOBAL_FORCE
	
end

/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )

	if data.HitEntity then
		if data.HitEntity:IsPlayer() then
			self.Dead = true
		end
	end
	
	self:EmitSound(Bounce_Sound,100,math.random(90,110))
	
end
