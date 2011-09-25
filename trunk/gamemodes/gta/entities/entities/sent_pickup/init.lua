
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.PickupSound = Sound( "items/ammopickup.wav" )

function ENT:Initialize()
	
	self.Entity:SetCollisionBounds( Vector( -25, -25, -25 ), Vector( 25, 25, 0 ) )
	self.Entity:PhysicsInitBox( Vector( -25, -25, -25 ), Vector( 25, 25, 0 ) )
	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:DrawShadow( false )	
		
	local phys = self.Entity:GetPhysicsObject()
	
	if phys:IsValid() then
		
		phys:Wake()
		phys:SetDamping( 0, 100 )
		
	end
	
	self.RemoveTime = CurTime() + 60
	
end

function ENT:Touch( entity )

	if ( !entity:IsPlayer() || entity:Team() == TEAM_POLICE || self.TakeOnce ) then return end
	
	self.TakeOnce = true
	
	self.Entity:DoPickup( entity ) 
	
end

function ENT:Think()

	if self.RemoveTime < CurTime() then
		self.Entity:Remove()
	end
	
end
 
function ENT:DoPickup( ply )

	ply:StripWeapons()
	ply:Give( self.WeaponType or "gta_m4" )
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) )
	util.Effect( "gun_take", ed, true, true )
	
	self.Entity:EmitSound( self.PickupSound )
	self.Entity:Remove()
	
end

function ENT:SetType( name )
	
	self.Entity:SetModel( ( self.Types[ name ] or "models/weapons/w_smg_tmp.mdl" ) )
	self.WeaponType = name

end

 
function ENT:OnTakeDamage( dmg )
	
end

function ENT:PhysicsCollide( data, phys )

end
