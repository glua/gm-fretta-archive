
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.tWeapons = {};
ENT.tAmmo = {};

function ENT:Initialize( )

	self:SetModel( "models/Items/BoxSRounds.mdl" ); -- ammo pack model
	self:PhysicsInit( SOLID_VPHYSICS ); -- we need physics to work
	self:SetMoveType( MOVETYPE_VPHYSICS ); -- physics...
	self:SetSolid( SOLID_VPHYSICS );
	
	--self:SetCollisionGroup( COLLISION_GROUP_WEAPON ); -- no colliding or slow down
	
	local pPhys = self:GetPhysicsObject(); -- get the physics object
	
	if( pPhys:IsValid() ) then -- check the physics object is valid
		pPhys:Wake() -- wakey wakey
	end
	
end

function ENT:FillFromPlayer( ply )
	for k, v in pairs( ply:GetWeapons() ) do -- get all the weapons and loop
		if( gmdm_activeweapondrop:GetBool() == false and v != ply:GetActiveWeapon() ) then 
			table.insert( self.tWeapons, v:GetClass() );
			
			local sPriAmmo = v:GetPrimaryAmmoType(); -- primary ammo type
			local sSecAmmo = v:GetSecondaryAmmoType(); -- sec
			
			if( sPriAmmo != "none" and ply:GetAmmoCount( sPriAmmo ) > 0 ) then
				self.tAmmo[ sPriAmmo ] = ply:GetAmmoCount( sPriAmmo );
			end
			
			if( sSecAmmo != "none" and ply:GetAmmoCount( sSecAmmo ) > 0 ) then
				self.tAmmo[ sSecAmmo ] = ply:GetAmmoCount( sSecAmmo );
			end
		end
	end
end

/*---------------------------------------------------------
   Name: StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( entity )
	if( entity:IsPlayer() and entity:Alive() ) then
		for k, weapon in pairs( self.tWeapons ) do
			entity:Give( weapon );
		end
		
		for atype, amount in pairs( self.tAmmo ) do
			entity:GiveAmmo( amount, atype );
		end
	
		-- lol @ recycling effects
		local effectdata = EffectData();
		effectdata:SetOrigin( self:GetPos() );
		util.Effect( "itemrespawn", effectdata );
		
		self:Remove();	
	end
end

/*---------------------------------------------------------
   Name: Touch
---------------------------------------------------------*/
function ENT:Touch( entity )
end
