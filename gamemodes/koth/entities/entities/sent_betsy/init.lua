AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

ENT.Jump = Sound( "npc/scanner/cbot_discharge1.wav" )
ENT.Break = Sound( "npc/scanner/cbot_energyexplosion1.wav" )
ENT.Land = Sound( "npc/roller/blade_in.wav" )
ENT.Gunfire = Sound( "npc/turret_floor/shoot1.wav" )

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/items/grenadeammo.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self.Entity:StartMotionController()

	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		phys:Wake()
		phys:SetDamping( 0, 15 )
		phys:SetVelocityInstantaneous( self.Entity:GetAngles():Forward():Normalize() * 800 )
	end
	
	self.AutoRemove = CurTime() + 60
	
	self.Mode = 0
	self.Check = 0
	self.Shots = 10
	
end

function ENT:PhysicsUpdate( phys, deltatime )

	phys:Wake()
	
end

function ENT:Think() 

	if not ValidEntity( self.Entity:GetOwner() ) then
		self.Entity:Remove()
	end

	if self.AutoRemove < CurTime() then
		self.Entity:DieEffects()
	end
	
	if self.Mode == 0 then return end
	
	if self.Mode == 1 then
		if self.Check < CurTime() then 
			self.Check = CurTime() + 0.5
			for k,v in pairs( player.GetAll() ) do
				if v:Team() != self.Entity:GetOwner():Team() and v:Team() != TEAM_SPECTATOR then
					if v:GetPos():Distance( self.Entity:GetPos() ) < 150 and v:Alive() then
						self.Entity:LaunchUp()
						self.Mode = 2
						self.ShootTime = CurTime() + 0.5
					end
				end
			end
		end
	elseif self.Mode == 2 then
		if self.ShootTime < CurTime() then
			if self.Shots < 1 then 
				self.Entity:DieEffects()
				return 
			end
			self.Entity:ShootDown()
			self.Shots = self.Shots - 1
		end
	end
end

function ENT:DieEffects()

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	ed:SetNormal( Vector(0,0,1) )
	util.Effect( "betsy_explode", ed, true, true )
	
	self.Entity:EmitSound( self.Break, 100, math.random(100,120) )
	self.Entity:Remove()
	
end

function ENT:LaunchUp()

	self.Entity:SetNWBool( "Smoke", true )
	
	self.Entity:EmitSound( self.Jump, 100, 120 )

	local phys = self.Entity:GetPhysicsObject()
	
	if not ValidEntity( phys ) then
		self.Entity:Remove()
	end

	self.Entity:SetAngles( Angle(0,0,0) )
	phys:EnableMotion( true )
	phys:SetVelocityInstantaneous( Vector(0,0,1) * 600 )
	
end

function ENT:ShootDown()

	self.Entity:SetNWBool( "Smoke", false )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if not ValidEntity( phys ) then
		self.Entity:Remove()
	end

	self.Entity:SetAngles( Angle(0,0,0) )
	phys:SetDamping( 60, 15 )

	local bullet = {}
	bullet.Num 		= 15
	bullet.Src 		= self.Entity:GetPos()		
	bullet.Dir 		= Vector( 0, 0, -1 )	
	bullet.Spread 	= Vector( 0.75, 0.75, 0 )	
	bullet.Tracer	= 1	
	bullet.Force	= 200						
	bullet.Damage	= 1
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "betsy_tracer"
	bullet.Callback = function ( attacker, tr, dmginfo ) 
		if tr.Entity:IsPlayer() then
			tr.Entity:TakeDamage( math.random(70,110), self.Entity:GetOwner(), self )
		end
	end
	
	self.Entity:GetOwner():FireBullets( bullet )
	
	self.Entity:EmitSound( table.Random( GAMEMODE.NearMiss ), 100, math.random(100,120) )
	self.Entity:EmitSound( self.Gunfire, 100, math.random(70,80) )

end

function ENT:PhysicsCollide( data, phys )

	if self.Mode >= 1 then 
	
		if self.Mode == 2 then
			phys:EnableMotion( false )
			self.Entity:SetAngles( Angle(0,0,0) )
		end
	
		return 
		
	end 
	
	if data.HitNormal.z > -0.9 then return end
	
	self.Mode = 1
	self.Entity:EmitSound( self.Land, 100, 120 )
	
	phys:EnableMotion( false )
	self.Entity:SetAngles( Angle(0,0,0) )
	
	local ed = EffectData()
	ed:SetOrigin( data.HitPos )
	ed:SetNormal( data.HitNormal )
	util.Effect( "betsy_bounce", ed, true, true )
	
end


