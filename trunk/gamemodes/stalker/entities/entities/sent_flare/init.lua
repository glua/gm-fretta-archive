
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.HitSound = Sound( "physics/metal/metal_grenade_impact_hard2.wav" )
ENT.Burn = Sound( "Weapon_FlareGun.Burn" )
ENT.Explode = Sound( "weapons/flashbang/flashbang_explode1.wav" )

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/weapons/w_eq_flashbang.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )
	
	self.Entity:SetNWFloat( "BurnDelay", CurTime() + 3 )
	self.BurnTime = 0
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:SetDamping( 0, 10 )
		phys:ApplyForceCenter( self.Entity:GetAngles():Forward() * 2500 )
	
	end
	
end

function ENT:Think()

	if self.BurnTime < CurTime() and self.Entity:GetNWFloat( "BurnDelay", 0 ) < CurTime() then
		
		self.BurnTime = CurTime() + 1.0
		
		for k,v in pairs( team.GetPlayers( TEAM_STALKER ) ) do
		
			if v:GetPos():Distance( self.Entity:GetPos() ) < 100 then
			
				v:TakeDamage( 2, self.Entity:GetOwner(), self.Entity )
			
			end
		
		end
		
		if not self.Burning then
		
			self.Burning = true
			self.Entity:EmitSound( self.Burn )
			self.Entity:EmitSound( self.Explode, 100, math.random(90,110) )
		
		end
	
	end

end

function ENT:OnRemove()

	self.Entity:StopSound( self.Burn )

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )

	if data.Speed > 50 and data.DeltaTime > 0.2 then
	
		self.Entity:EmitSound( self.HitSound, 100, math.random(90,110) )
		
	end
	
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

