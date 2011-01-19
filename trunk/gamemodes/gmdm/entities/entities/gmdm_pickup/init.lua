AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Dropped = false;
ENT.RespawnTime = 5

function ENT:Initialize()

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	
	self.Entity:SetCollisionBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 0 ) )
	self.Entity:PhysicsInitBox( Vector( -16, -16, -16 ), Vector( 16, 32, 0 ) )

	self.Entity:GetPhysicsObject():EnableGravity(false)
	
	self.Entity:DrawShadow( false )

	if self.Dropped then
		self:SetActiveTime( CurTime()+1 )
	else
		self:SetActiveTime( 0 )
	end
end

function ENT:KeyValue( key, value )
	if ( key == "item" ) then
		self:SetPickupType( value )
	elseif( key == "norespawn" and value == "1" ) then
		self.Dropped = true
	elseif( key == "respawntime" ) then
		self.RespawnTime = tonumber( value );
	end
end

function ENT:Touch( entity )
	if( GetConVarNumber( "gmdm_instagib" ) == 1 ) then return end
	if ( self:GetActiveTime() > CurTime() ) then return end
	if (!entity:IsPlayer()) then return end
	
	local weap = self:GetPickupName();
	
	if( entity:HasWeapon( weap ) ) then
		entity:PrintMessage( HUD_PRINTCENTER, "You picked up some " .. self:GetNiceName() .. " ammo" );
	else
		entity:PrintMessage( HUD_PRINTCENTER, "You picked up the " .. self:GetNiceName() );
		entity:Give( weap )
	end
	
	self:DoAmmoGive( entity )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetEntity( entity )
	util.Effect( "pickup", effectdata, true, true ) -- Allow override, Ignore prediction
	
	entity:EmitSound( "Player.PickupWeapon" );
	
	if( self.Dropped == true ) then
		self:Remove()
		return
	end
	
	local re = self.RespawnTime or 5
	self:SetActiveTime( CurTime() + re )
	
	local f = function ( pos )
	
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		util.Effect( "itemrespawn", effectdata )
	
	end
	
	timer.Simple( re, f, self.Entity:GetPos() )	

end


  
function SpawnPickup( pl, command, args )

	if( pl:IsAdmin() ) then
		Msg( "Spawning pickup...\n" );
		
		local pickup = tostring( args[1] );
		local eyeTrace = pl:GetEyeTrace();
		
		local pos = eyeTrace.HitPos + Vector( 0, 0, 50 );
		
		local ent = ents.Create( "gmdm_pickup" );
		ent:SetKeyValue( "item", pickup );
		ent:SetPos( pos );
		ent:Spawn()
		
		Msg( "Spawned at origin " .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. "    \n" );
		Msg( " \tself:AddPickup( Vector( " .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. " ), \"" .. pickup .. "\" );   \n" );
	end
end

concommand.Add( "spawn_pickup", SpawnPickup );

