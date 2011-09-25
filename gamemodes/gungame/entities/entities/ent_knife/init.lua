AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	
	self:SetModel( "models/weapons/w_knife_t.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	self.NextThink = CurTime() +  1

	if ( phys:IsValid() ) then
		phys:Wake()
		phys:SetMass( 10 )
	end

	util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
	util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet1.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet2.wav")
	util.PrecacheSound("physics/flesh/flesh_impact_bullet3.wav")

	self.Hit = { 
	Sound( "physics/metal/metal_grenade_impact_hard1.wav" ),
	Sound( "physics/metal/metal_grenade_impact_hard2.wav" ),
	Sound( "physics/metal/metal_grenade_impact_hard3.wav" ) };
	self.FleshHit = { 
	Sound( "physics/flesh/flesh_impact_bullet1.wav" ),
	Sound( "physics/flesh/flesh_impact_bullet2.wav" ),
	Sound( "physics/flesh/flesh_impact_bullet3.wav" ) }

	self:GetPhysicsObject():SetMass( 2 )	
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
	
	self.lifetime = self.lifetime or CurTime() + 20
	if CurTime() > self.lifetime then
		self:Remove()
	end
end

/*---------------------------------------------------------
Disable
---------------------------------------------------------*/
function ENT:Disable()
	self.PhysicsCollide = function() end
	self.lifetime = CurTime() + 30
end

/*---------------------------------------------------------
PhysicsCollided
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, phys )
	
	local Ent = data.HitEntity
	if !(ValidEntity( Ent ) || Ent:IsWorld()) then return end

	if Ent:IsWorld() then
			util.Decal( "ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal )
			self:EmitSound( self.Hit[math.random(1,#self.Hit)] );
			self:Disable()

	elseif Ent.Health then
		if not(Ent:IsPlayer() || Ent:IsNPC() || Ent:GetClass() == "prop_ragdoll") then 
			util.Decal( "ManhackCut", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal )
			self:EmitSound( self.Hit[math.random(1,#self.Hit)] );
		end

		Ent:TakeDamage( 100, self:GetOwner() )

		if (Ent:IsPlayer() || Ent:IsNPC() || Ent:GetClass() == "prop_ragdoll") then 
			local effectdata = EffectData()
			effectdata:SetStart( data.HitPos )
			effectdata:SetOrigin( data.HitPos )
			effectdata:SetScale( 1 )
			util.Effect( "BloodImpact", effectdata )

			self:EmitSound( self.FleshHit[math.random(1,#self.Hit)] );
			self:Remove()
		end
	end

	self.Entity:SetOwner( NUL )
	
end

/*---------------------------------------------------------
Use
---------------------------------------------------------*/
function ENT:Use( activator, caller )
	self.Entity:Remove()
	if ( activator:IsPlayer() ) then
		activator:GiveAmmo(1, "Xbowbolt")
	end
end
