
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	-- Use the helibomb model just for the shadow (because it's about the same size)
	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
	
	-- Don't use the model's physics - create a sphere instead
	self.Entity:PhysicsInitSphere( self.Size, "metal_bouncy" )
	
	-- Wake the physics object up. It's time to have fun!
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity( false )
	end
	
	-- Set collision bounds exactly
	self.Entity:SetCollisionBounds( Vector( -self.Size, -self.Size, -self.Size), Vector( self.Size, self.Size, self.Size ) )
end

function ENT:SetInternalVisibility( isVisible )
	self:SetDTBool(1, not isVisible )
end

/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )
	
	-- Play sound on bounce
	if (data.Speed > 80 and data.DeltaTime > 0.2 ) then
		self.Entity:EmitSound( "Rubber.BulletImpact" )
	end
	
	local overrideVeloMod = false
	if (GAMEMODE.Minigame and GAMEMODE.Minigame.WarePhysicsCollideStream) then
		overrideVeloMod = GAMEMODE.Minigame:WarePhysicsCollideStream( self, data, physobj ) or false
	end
	
	if not overrideVeloMod then
		-- Bounce like a bouncy ball
		local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
		local NewVelocity = physobj:GetVelocity()
		NewVelocity:Normalize()
		
		LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
		
		local TargetVelocity = NewVelocity * LastSpeed * 0.85
		
		physobj:SetVelocity( TargetVelocity )
	end
	
end


/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )

	-- React physically when shot/getting blown
	dmginfo:SetDamageForce(dmginfo:GetDamageForce() * 0.015)
	self.Entity:TakePhysicsDamage( dmginfo )
	
	local ply = dmginfo:GetAttacker( )
	if ValidEntity(ply) and ply:IsPlayer() and ply:IsWarePlayer() then
		ply:SendHitConfirmation( )
		ply.BULLSEYE_Hit = (ply.BULLSEYE_Hit or 0) + 1
	end
	
end
