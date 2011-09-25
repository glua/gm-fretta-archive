AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

ENT.HitSound = Sound( "npc/attack_helicopter/aheli_mine_drop1.wav" )
ENT.Break = Sound( "weapons/mortar/mortar_explode2.wav" )
ENT.Bounciness = 1.10

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/items/grenadeammo.mdl" ) )
	
	self.Entity:PhysicsInitSphere( 15 )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		phys:Wake()
		phys:EnableDrag(false)
		phys:SetVelocityInstantaneous( self.Entity:GetAngles():Forward():Normalize() * 800 )
	end
	
	self.NumBounces = 0
	
end

function ENT:Think() 

	if not ValidEntity( self.Entity:GetOwner() ) then
		self.Entity:Remove()
	end

	if self.NumBounces > 8 and not self.KillTime then
	
		self.KillTime = CurTime() + 0.25
	
	end
	
	if self.KillTime and self.KillTime < CurTime() then
	
		self.Entity:DieEffects()
	
	end
	
end

function ENT:DieEffects()

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "grenade_explode", ed, true, true )
	
	self.Entity:ShootRandom()
	util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 400, 75 )
	
	self.Entity:EmitSound( self.Break, 100, math.random(90,110) )
	self.Entity:Remove()
	
end

function ENT:ShootRandom()
	
	local bullet = {}
	bullet.Num 		= 45
	bullet.Src 		= self.Entity:GetPos()		
	bullet.Dir 		= Vector(0,0,-1)
	bullet.Spread 	= Vector(1,1,1)
	bullet.Tracer	= 1	
	bullet.Force	= 200						
	bullet.Damage	= 1
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "betsy_tracer"
	bullet.Callback = function ( attacker, tr, dmginfo ) 
		if tr.Entity:IsPlayer() then
			tr.Entity:TakeDamage( math.random(50,75), self.Entity:GetOwner(), self.Entity )
		end
	end
		
	self.Entity:GetOwner():FireBullets( bullet )
	
	self.Entity:EmitSound( table.Random( GAMEMODE.NearMiss ), 100, math.random(90,110) )

end

function ENT:PhysicsCollide( data, physobj )

	if ( data.Speed > 50 && data.DeltaTime > 0.2 ) then
		self.Entity:EmitSound( self.HitSound, 100, math.random(120,140) )
	end

	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	NewVelocity.z = NewVelocity.z + 0.1
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * self.Bounciness 
	
	physobj:SetVelocity( TargetVelocity )
	
	self.Entity:CheckPlayers()
	
end

function ENT:CheckPlayers()

	for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != self.Entity:GetOwner():Team() then
		
			if v:GetPos():Distance( self.Entity:GetPos() ) < 300 then
			
				self.KillTime = CurTime() + 0.25
				return
			
			end
		end
	end
	
	self.NumBounces = self.NumBounces + 1
	
end

