
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "ai_translations.lua" )

SWEP.Weight             = 5         // Decides whether we should switch from/to this
SWEP.AutoSwitchTo       = true      // Auto switch to if we pick it up
SWEP.AutoSwitchFrom     = true      // Auto switch from if you pick up a better weapon

local ActIndex = {}
    ActIndex[ "pistol" ]        = ACT_HL2MP_IDLE_PISTOL
    ActIndex[ "smg" ]           = ACT_HL2MP_IDLE_SMG1
    ActIndex[ "grenade" ]       = ACT_HL2MP_IDLE_GRENADE
    ActIndex[ "ar2" ]           = ACT_HL2MP_IDLE_AR2
    ActIndex[ "shotgun" ]       = ACT_HL2MP_IDLE_SHOTGUN
    ActIndex[ "rpg" ]           = ACT_HL2MP_IDLE_RPG
    ActIndex[ "physgun" ]       = ACT_HL2MP_IDLE_PHYSGUN
    ActIndex[ "crossbow" ]      = ACT_HL2MP_IDLE_CROSSBOW
    ActIndex[ "melee" ]         = ACT_HL2MP_IDLE_MELEE
    ActIndex[ "slam" ]          = ACT_HL2MP_IDLE_SLAM
    ActIndex[ "normal" ]        = ACT_HL2MP_IDLE


/*---------------------------------------------------------
   Name: SetWeaponHoldType
   Desc: Sets up the translation table, to translate from normal
            standing idle pose, to holding weapon pose.
---------------------------------------------------------*/
function SWEP:SetWeaponHoldType( t )

    local index = ActIndex[ t ]

    if (index == nil) then
        Msg( "SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set!\n" )
        return
    end

    self.ActivityTranslate = {}
    self.ActivityTranslate [ ACT_HL2MP_IDLE ]                   = index
    self.ActivityTranslate [ ACT_HL2MP_WALK ]                   = index+1
    self.ActivityTranslate [ ACT_HL2MP_RUN ]                    = index+2
    self.ActivityTranslate [ ACT_HL2MP_IDLE_CROUCH ]            = index+3
    self.ActivityTranslate [ ACT_HL2MP_WALK_CROUCH ]            = index+4
    self.ActivityTranslate [ ACT_HL2MP_GESTURE_RANGE_ATTACK ]   = index+5
    self.ActivityTranslate [ ACT_HL2MP_GESTURE_RELOAD ]         = index+6
    self.ActivityTranslate [ ACT_HL2MP_JUMP ]                   = index+7
    self.ActivityTranslate [ ACT_RANGE_ATTACK1 ]                = index+8

    self:SetupWeaponHoldTypeForAI( t )

end

// Default hold pos is the pistol
SWEP:SetWeaponHoldType( "pistol" )

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
function SWEP:AcceptInput( name, activator, caller, data )
    return false
end


/*---------------------------------------------------------
   Name: KeyValue
   Desc: Called when a keyvalue is added to us
---------------------------------------------------------*/
function SWEP:KeyValue( key, value )
end


/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function SWEP:OnRemove()
end

/*---------------------------------------------------------
   Name: Equip
   Desc: A player or NPC has picked the weapon up
---------------------------------------------------------*/
function SWEP:Equip( NewOwner )

end

/*---------------------------------------------------------
   Name: EquipAmmo
   Desc: The player has picked up the weapon and has taken the ammo from it
        The weapon will be removed immidiately after this call.
---------------------------------------------------------*/
function SWEP:EquipAmmo( NewOwner )

end


/*---------------------------------------------------------
   Name: OnDrop
   Desc: Weapon was dropped
---------------------------------------------------------*/
function SWEP:OnDrop()

end

/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
    return true
end

/*---------------------------------------------------------
   Name: GetCapabilities
   Desc: For NPCs, returns what they should try to do with it.
---------------------------------------------------------*/
function SWEP:GetCapabilities()

    return CAP_WEAPON_RANGE_ATTACK1 | CAP_INNATE_RANGE_ATTACK1

end

/*---------------------------------------------------------
   Name: NPCShoot_Secondary
   Desc: NPC tried to fire secondary attack
---------------------------------------------------------*/
function SWEP:NPCShoot_Secondary( ShootPos, ShootDir )

    self:SecondaryAttack()

end

/*---------------------------------------------------------
   Name: NPCShoot_Secondary
   Desc: NPC tried to fire primary attack
---------------------------------------------------------*/
function SWEP:NPCShoot_Primary( ShootPos, ShootDir )

    self:PrimaryAttack()

end

// These tell the NPC how to use the weapon
AccessorFunc( SWEP, "fNPCMinBurst",         "NPCMinBurst" )
AccessorFunc( SWEP, "fNPCMaxBurst",         "NPCMaxBurst" )
AccessorFunc( SWEP, "fNPCFireRate",         "NPCFireRate" )
AccessorFunc( SWEP, "fNPCMinRestTime",  "NPCMinRest" )
AccessorFunc( SWEP, "fNPCMaxRestTime",  "NPCMaxRest" )
