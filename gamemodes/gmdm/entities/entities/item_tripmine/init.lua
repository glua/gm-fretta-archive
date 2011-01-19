
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local sndStick = Sound( "physics/metal/sawblade_stick3.wav" )

ENT.Remote = false;

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self:DrawShadow( false )
	self:SetModel( "models/dav0r/buttons/button.mdl" )
	self:SetMaterial( "models/debug/debugwhite" )
	self:SetColor( 0, 0, 0, 255 )
	self:PhysicsInit( SOLID_VPHYSICS )
	
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetTrigger( true )
	
	self.Exploded = false;
	self.BulletDamage = false;
end

function ENT:Think( )
	if self.ExplodeTimer and self.ExplodeTimer < CurTime( ) then
		self:Explode( )
	end
end

function ENT:OnTakeDamage( dmginfo )
	if( dmginfo:IsBulletDamage() and dmginfo:GetAttacker():IsPlayer() ) then
		self.BulletDamage = true;
		self:SetNetworkedEntity( "Thrower", dmginfo:GetAttacker() );
	end
	
	self.ExplodeTimer = CurTime( ) +  0.1
end

function ENT:PhysicsCollide( data, physobj )
	if not data.HitEntity:IsWorld( ) then return end
	
	physobj:EnableMotion( false )
	physobj:Sleep( )
	
	self:StartTripmineMode( data.HitPos, data.HitNormal:GetNormal( ) * -1 )
end

function ENT:StartTripmineMode( hitpos, forward )
	self.Placed = true
	
	if hitpos then self:SetPos( hitpos ) end
	self:SetAngles( forward:Angle( ) + Angle( 90, 0, 0 ) )

	local trace = {}
		trace.start = self:GetPos()
		trace.endpos = self:GetPos() + (forward * 4096)
		trace.mask = MASK_NPCWORLDSTATIC
		
	local tr = util.TraceLine( trace )
	
	local ent = ents.Create( "item_tripmine_laser" )	
		ent:SetPos( self:GetPos( ) + ( self:GetUp( ) * 3 ) )
		ent:Spawn( )
		ent:Activate( )
		ent:SetEndPos( tr.HitPos )
		ent:SetActiveTime( CurTime( ) + 2 )
		ent:SetParent( self )
		ent:SetOwner( self )
		
	self.Laser = ent
	
	self:EmitSound( sndStick )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetNormal( forward )
		effectdata:SetMagnitude( 3 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 4 )
	util.Effect( "Sparks", effectdata )
end

function ENT:Explode( remote )

	if( remote ) then
		self.Remote = remote;
	end
	
	if self.Exploded then return end
	
	self.Exploded = true
	
	local Forward = self.Entity:GetAngles( ):Forward( )

/*	local ent = ents.Create( "env_explosion" )
	if ent and ent != NULL then
		ent:SetPos( self.Entity:GetPos( ) + Forward * 16 )
		ent:Spawn( )
		ent:Activate( )
		ent:SetOwner( self.Entity:GetNetworkedEntity( "Thrower" ) )
		
		if( self.BulletDamage == true ) then
			ent:SetKeyValue( "iMagnitude", "200" ) -- bigger blast raidus for bullet damag
		else
			ent:SetKeyValue( "iMagnitude", "150" )
		end
		
		ent:Fire( "Explode", 0, 0 )
	end*/
	
	local damage = 250
	local radius = 300
	
	if( self.BulletDamage ) then
		damage = 360
		radius = 325
	end
	
	util.BlastDamage( self.Entity, self.Entity:GetNetworkedEntity( "Thrower" ), self.Entity:GetPos( ) + Forward * 16, radius, damage )
	
	local effectdata = EffectData( )
		effectdata:SetOrigin( self.Entity:GetPos( ) + Forward * 16 )
	util.Effect( "Super_Explosion", effectdata, true, true )

	local effectdata = EffectData( )
		effectdata:SetOrigin( self.Entity:GetPos( ) + Forward * 16 )
	util.Effect( "gmdm_explosion", effectdata, true, true )
	
	self.Entity:EmitSound( "explode_1" );
	self.Entity:Remove( )
end

function ENT:UpdateTransmitState( )
	return TRANSMIT_ALWAYS
end
