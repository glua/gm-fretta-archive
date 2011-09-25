
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
include( "ai_translations.lua" )

local ActIndex = {}
	ActIndex[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL
	ActIndex[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1
	ActIndex[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE
	ActIndex[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2
	ActIndex[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN
	ActIndex[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG
	ActIndex[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN
	ActIndex[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW
	ActIndex[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE
	ActIndex[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM
	ActIndex[ "normal" ]		= ACT_HL2MP_IDLE

function SWEP:SetWeaponHoldType( t )

	local index = ActIndex[ t ]
	
	if (index == nil) then
		Msg( "Error! Weapon's act index is NIL!\n" )
		return
	end

	self.ActivityTranslate = {}
	self.ActivityTranslate [ ACT_HL2MP_IDLE ] 					= index
	self.ActivityTranslate [ ACT_HL2MP_WALK ] 					= index+1
	self.ActivityTranslate [ ACT_HL2MP_RUN ] 					= index+2
	self.ActivityTranslate [ ACT_HL2MP_IDLE_CROUCH ] 			= index+3
	self.ActivityTranslate [ ACT_HL2MP_WALK_CROUCH ] 			= index+4
	self.ActivityTranslate [ ACT_HL2MP_GESTURE_RANGE_ATTACK ] 	= index+5
	self.ActivityTranslate [ ACT_HL2MP_GESTURE_RELOAD ] 		= index+6
	self.ActivityTranslate [ ACT_HL2MP_JUMP ] 					= index+7
	self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= index+8
	
	self:SetupWeaponHoldTypeForAI( t )

end

/*---------------------------------------------------------
   Name: weapon:TranslateActivity( )
   Desc: Translate a player's Activity into a weapon's activity
		 So for example, ACT_HL2MP_RUN becomes ACT_HL2MP_RUN_PISTOL
		 Depending on how you want the player to be holding the weapon
---------------------------------------------------------*/
function SWEP:TranslateActivity( act )

	if ( self.Owner:IsNPC() ) then
		if ( self.ActivityTranslateAI[ act ] ) then
			return self.ActivityTranslateAI[ act ]
		end
		return -1
	end

	if ( self.ActivityTranslate[ act ] != nil ) then
		return self.ActivityTranslate[ act ]
	end
	
	return -1

end

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
