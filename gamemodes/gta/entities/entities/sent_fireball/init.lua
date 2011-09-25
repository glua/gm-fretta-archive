
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self.Entity:SetModel( table.Random( GAMEMODE.Debris ) )
	
	self.Entity:SetColor( 50, 50, 50, 255 )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		phys:Wake()
		phys:EnableDrag( false )
		phys:ApplyForceCenter( VectorRand() * 5000 )
	end

	self.DieTime = CurTime() + math.random( 10, 20 )
	
end

function ENT:Think()

	if self.DieTime < CurTime() then
		self.Entity:Remove()
	end
	
end
 
function ENT:OnTakeDamage( dmg )
	
end

function ENT:PhysicsCollide( data, phys )

	if data.Speed > 150 and data.DeltaTime > 0.1 then
	
		self.Entity:EmitSound( table.Random( GAMEMODE.MetalHit ), 100, math.random(90,110) )
		
	end
	
end