AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.HitDamage = 80
ENT.SplashDamage = 40

function ENT:Initialize()
 
	self.Entity:SetModel( Model( "models/props/cs_italy/orange.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetMaterial( "freezetag/snow" )

	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		phys:Wake()
		phys:SetVelocityInstantaneous( self.Entity:GetAngles():Forward():Normalize() * 1500 )
	end

	self.Break = table.Random( GAMEMODE.SnowballHit )
	
end

function ENT:Think() 
	
end

function ENT:DieEffects()

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "snowball_explode", ed, true, true )
	
	self.Entity:EmitSound( self.Break, 100, math.random(90,110) )
	self.Entity:Remove()
	
end

function ENT:PhysicsCollide( data, phys )

	if data.HitEntity:IsPlayer() then
		data.HitEntity:TakeDamage( self.HitDamage, self.Entity:GetOwner(), self.Entity )
	end
	
	for k,v in pairs( player.GetAll() ) do
		if v:GetPos():Distance( self.Entity:GetPos() ) < 100 and v != data.HitEntity then
			v:TakeDamage( self.SplashDamage, self.Entity:GetOwner(), self.Entity )
		end
	end
	
	self.Entity:DieEffects()
	
end


