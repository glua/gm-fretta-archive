AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

ENT.Damage = 200

function ENT:Initialize()

	self.Entity:SetModel( "models/weapons/w_eq_fraggrenade.mdl" )
	
	self.Entity:PhysicsInitSphere( 3 )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:SetVelocityInstantaneous( self.Entity:GetAngles():Forward():Normalize() * 1000 )
	
	end
	
	self.Trail = util.SpriteTrail( self.Entity, 0, Color( 50, 50, 50, 255 ), true, 3, 15, 0.2, 0.01, "trails/smoke.vmt" )
	
end

function ENT:Think() 

end

function ENT:PhysicsCollide( data, phys )

	phys:EnableMotion( false )

	if not ValidEntity( self.Entity:GetOwner() ) then
	
		self.Entity:Remove()
		return
	
	end
	
	local ed = EffectData()
	ed:SetOrigin( data.HitPos )
	ed:SetNormal( data.HitNormal * -1 )
	util.Effect( "bomb_explosion", ed, true, true )
	
	if data.HitEntity:IsPlayer() and data.HitEntity:Team() != self.Entity:GetOwner():Team() then
	
		data.HitEntity:SetHealth( math.Clamp( data.HitEntity:Health() / 2, 1, 100 ) )
	
	end
	
	self.Entity:Explode( data.HitPos )
	self.Entity:Remove()
	
end

function ENT:Explode( pos )
	
	util.BlastDamage( self.Entity, self.Entity:GetOwner(), pos, 200, self.Damage )
	util.ScreenShake( self.Entity:GetPos(), math.Rand(3,6), math.Rand(3,6), math.Rand(3,6), 400 ) 
	
	self.Entity:EmitSound( table.Random( GAMEMODE.BombExplosion2 ), 100, math.random(90,110) )
	
	self.Trail:Remove()
	
end


