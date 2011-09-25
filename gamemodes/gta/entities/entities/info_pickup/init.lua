
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.RespawnTime = 30
ENT.PickupSound = Sound( "items/ammopickup.wav" )
ENT.RespawnSound = Sound( "HL1/FVOX/fuzz.wav" )

function ENT:Initialize()
	
	self.Entity:SetCollisionBounds( Vector( -25, -25, -25 ), Vector( 25, 25, 0 ) )
	self.Entity:PhysicsInitBox( Vector( -25, -25, -25 ), Vector( 25, 25, 0 ) )
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetActiveTime( CurTime() + 1 )
	self.Entity:SetType()
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,-500)
	trace.filter = self.Entity
	local tr = util.TraceLine( trace )
	
	self.Entity:SetPos( tr.HitPos + Vector(0,0,25) )
	
end

function ENT:Touch( ent )

	if self.Entity:GetActiveTime() > CurTime() then return end
	
	if not ValidEntity( ent ) or not ent:IsPlayer() then return end
	
	self.Entity:DoPickup( ent ) 
	
end

function ENT:Think()
	
end
 
function ENT:DoPickup( ply )

	ply:StripWeapons()
	ply:Give( self.WeaponType or "gta_m249" )
	ply:Notice( table.Random( GAMEMODE.WeaponNotices ), 2, 0, 255, 255 )
	
	if ply:Team() == TEAM_POLICE then
		ply:Give( "gta_billyclub" )
	end
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "gun_take", ed, true, true )
	
	self.Entity:EmitSound( self.PickupSound )
	self.Entity:SetActiveTime( CurTime() + self.RespawnTime )
	self.Entity:SetType()
	
	local function effect( center )
	
		if not ValidEntity( self.Entity ) then return end
		
		self.Entity:EmitSound( self.RespawnSound, 100, 150 ) 
		
		local ed = EffectData()
		ed:SetOrigin( center )
		util.Effect( "pickup_spawn", ed, true, true )
		
	end
	
	timer.Simple( self.RespawnTime, effect, self.Entity:GetPos() )
	
end

function ENT:SetType()

	self.WeaponType = table.Random{ "gta_m4_silenced", "gta_m249", "gta_scout", "gta_xm1014" }
	self.Entity:SetModel( self.Types[ self.WeaponType ] or "models/weapons/w_mach_m249para.mdl" )

end
 
function ENT:OnTakeDamage( dmg )
	
end

function ENT:PhysicsCollide( data, phys )

end
