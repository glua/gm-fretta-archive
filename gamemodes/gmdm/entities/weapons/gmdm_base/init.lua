
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_anim.lua" )
AddCSLuaFile( "ai_translations.lua" )

include( "shared.lua" )

SWEP.Weight				= 5			// Decides whether we should switch from/to this
SWEP.AutoSwitchTo		= true		// Auto switch to if we pick it up
SWEP.AutoSwitchFrom		= true		// Auto switch from if you pick up a better weapon

function SWEP:GMDMInit()

	self.StartPos = self:GetPos()
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )

end

/*---------------------------------------------------------
   Name: OnRestore
   Desc: The game has just been reloaded. This is usually the right place
		to call the GetNetworked* functions to restore the script's values.
---------------------------------------------------------*/
function SWEP:OnRestore()
end


/*---------------------------------------------------------
   Name: AcceptInput
   Desc: Accepts input, return true to override/accept input
---------------------------------------------------------*/
function SWEP:AcceptInput( name, activator, caller )
	return false
end


/*---------------------------------------------------------
   Name: KeyValue
   Desc: Called when a keyvalue is added to us
---------------------------------------------------------*/
function SWEP:KeyValue( key, value )

	if ( key == "respawn" ) then
	
		self.Respawner = value
		self:SetNetworkedBool( "Respawner", true )
	
	end

end


/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function SWEP:OnRemove()
end


/*---------------------------------------------------------
   Name: Equip
   Desc: Player picked up the weapon
---------------------------------------------------------*/
function SWEP:Equip( NewOwner )

	self.bRemove = nil

	if ( !self.Respawner ) then return end
	
	self:SetNetworkedBool( "Respawner", false )
	timer.Simple( GAMEMODE:WeaponRespawnTime( self.Weapon:GetClass() ), SpawnEntityTimed, self.Weapon:GetClass(), self.StartPos )
	self.Respawner = nil
	
	self:FirstTimePickup( NewOwner )

end

SWEP.EquipAmmo = SWEP.Equip

/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function SWEP:WeaponRemoveThink()

	if ( !ValidEntity( self ) ) then return end
	if ( !self.bRemove ) then return end

	self:Remove()
	self.bRemove = nil

end


/*---------------------------------------------------------
   Name: FirstTimePickup
   Desc: First time this respawner weapon has been picked up
		 (Use this to give them ammo)
---------------------------------------------------------*/
function SWEP:FirstTimePickup( Owner )

end


/*---------------------------------------------------------
   Name: HasUsableAmmo
   Desc: If the weapon doesn't have ammo it won't be dropped on kill
---------------------------------------------------------*/
function SWEP:HasUsableAmmo()
	return true
end


function SWEP:CheckRedundancy()

	if ( self:HasUsableAmmo() ) then return end
	if ( !ValidEntity( self.Owner ) ) then return end
	self.Owner:DropWeapon( self )
	self:Remove()

end

function SWEP:GetCapabilities()
	return CAP_WEAPON_RANGE_ATTACK1 | CAP_INNATE_RANGE_ATTACK1 | CAP_WEAPON_RANGE_ATTACK2 | CAP_INNATE_RANGE_ATTACK2
end

function SWEP:Operator_HandleAnimEvent( event, operator )
	Msg( "Handle anim event\n" )
end
/*---------------------------------------------------------
   Name: NPCShoot_Secondary
   Desc: NPC tried to fire primary attack
---------------------------------------------------------*/
function SWEP:NPCShoot_Primary( ShootPos, ShootDir )
	Msg( "Trying to shoot GMDM weapon\n");
	self:PrimaryAttack()

end


/*---------------------------------------------------------
   Name: NPCShoot_Secondary
   Desc: NPC tried to fire secondary attack
---------------------------------------------------------*/
function SWEP:NPCShoot_Secondary( ShootPos, ShootDir )
	Msg( "Trying to shoot GMDM weapon\n");
	self:PrimaryAttack()

end
