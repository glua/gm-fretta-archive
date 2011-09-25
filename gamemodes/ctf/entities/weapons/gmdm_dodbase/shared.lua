SWEP.IsCSWeapon					= true;
SWEP.Base						= "gmdm_csbase";

if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	SWEP.HoldType = "rifle"
end

SWEP.ViewModelFlip = false;
SWEP.ViewModelFOV = 54;

local ActIndex = {}
	ActIndex[ "pistol" ] 		= ACT_DOD_STAND_AIM_PISTOL;
	ActIndex[ "c96"	]			= ACT_DOD_STAND_AIM_C96;
	ActIndex[ "rifle" ]			= ACT_DOD_STAND_AIM_RIFLE;
	ActIndex[ "bolt" ]			= ACT_DOD_STAND_AIM_BOLT;
	ActIndex[ "tommy" ]			= ACT_DOD_STAND_AIM_TOMMY;
	ActIndex[ "mp40" ]			= ACT_DOD_STAND_AIM_MP40;
	ActIndex[ "mp44" ]			= ACT_DOD_STAND_AIM_MP44;
	ActIndex[ "grease" ]		= ACT_DOD_STAND_AIM_GREASE;
	ActIndex[ "mg" ]			= ACT_DOD_STAND_AIM_MG;
	ActIndex[ "30cal" ]			= ACT_DOD_STAND_AIM_30CAL;
	ActIndex[ "gren_frag" ]		= ACT_DOD_STAND_AIM_GREN_FRAG;
	ActIndex[ "knife" ]			= ACT_DOD_STAND_AIM_KNIFE;
	ActIndex[ "spade" ]			= ACT_DOD_STAND_AIM_SPADE;
	ActIndex[ "bazooka" ]		= ACT_DOD_STAND_AIM_BAZOOKA;
	ActIndex[ "pschreck" ]		= ACT_DOD_STAND_AIM_PSCHRECK;
	ActIndex[ "bar" ]			= ACT_DOD_STAND_AIM_BAR;
	
local PrimaryAttackGestures = {}
	PrimaryAttackGestures[ "pistol" ] 		= ACT_DOD_PRIMARYATTACK_PISTOL;
	PrimaryAttackGestures[ "c96"	]			= ACT_DOD_PRIMARYATTACK_C96;
	PrimaryAttackGestures[ "rifle" ]			= ACT_DOD_PRIMARYATTACK_RIFLE;
	PrimaryAttackGestures[ "bolt" ]			= ACT_DOD_PRIMARYATTACK_BOLT;
	PrimaryAttackGestures[ "tommy" ]			= ACT_DOD_PRIMARYATTACK_TOMMY;
	PrimaryAttackGestures[ "mp40" ]			= ACT_DOD_PRIMARYATTACK_MP40;
	PrimaryAttackGestures[ "mp44" ]			= ACT_DOD_PRIMARYATTACK_MP44;
	PrimaryAttackGestures[ "grease" ]		= ACT_DOD_PRIMARYATTACK_GREASE;
	PrimaryAttackGestures[ "mg" ]			= ACT_DOD_PRIMARYATTACK_MG;
	PrimaryAttackGestures[ "30cal" ]			= ACT_DOD_PRIMARYATTACK_30CAL;
	PrimaryAttackGestures[ "gren_frag" ]		= ACT_DOD_PRIMARYATTACK_GREN_FRAG;
	PrimaryAttackGestures[ "knife" ]			= ACT_DOD_PRIMARYATTACK_KNIFE;
	PrimaryAttackGestures[ "spade" ]			= ACT_DOD_PRIMARYATTACK_SPADE;
	PrimaryAttackGestures[ "bazooka" ]		= ACT_DOD_PRIMARYATTACK_BAZOOKA;
	PrimaryAttackGestures[ "pschreck" ]		= ACT_DOD_PRIMARYATTACK_PSCHRECK;
	PrimaryAttackGestures[ "bar" ]			= ACT_DOD_PRIMARYATTACK_BAR;	

local ReloadGestures = {}
	ReloadGestures[ "pistol" ] 		= ACT_DOD_RELOAD_PISTOL;
	ReloadGestures[ "c96"	]			= ACT_DOD_RELOAD_C96;
	ReloadGestures[ "rifle" ]			= ACT_DOD_RELOAD_RIFLE;
	ReloadGestures[ "bolt" ]			= ACT_DOD_RELOAD_BOLT;
	ReloadGestures[ "tommy" ]			= ACT_DOD_RELOAD_TOMMY;
	ReloadGestures[ "mp40" ]			= ACT_DOD_RELOAD_MP40;
	ReloadGestures[ "mp44" ]			= ACT_DOD_RELOAD_MP44;
	ReloadGestures[ "grease" ]		= ACT_DOD_RELOAD_GREASE;
	ReloadGestures[ "mg" ]			= ACT_DOD_RELOAD_MG;
	ReloadGestures[ "30cal" ]			= ACT_DOD_RELOAD_30CAL;
	ReloadGestures[ "gren_frag" ]		= ACT_DOD_RELOAD_PISTOL;
	ReloadGestures[ "knife" ]			= ACT_DOD_RELOAD_PISTOL;
	ReloadGestures[ "spade" ]			= ACT_DOD_RELOAD_PISTOL;
	ReloadGestures[ "bazooka" ]		= ACT_DOD_RELOAD_BAZOOKA;
	ReloadGestures[ "pschreck" ]		= ACT_DOD_RELOAD_PSCHRECK;
	ReloadGestures[ "bar" ]			= ACT_DOD_RELOAD_BAR;	
	
function SWEP:SetWeaponHoldType( t )

	local index = ActIndex[ t ]
	
	if (index == nil) then
		Msg( "Error! Weapon's act index is NIL!\n" )
		return
	end

	self.ActivityTranslate = {}
	self.ActivityTranslate [ ACT_HL2MP_IDLE ] 					= index+6
	self.ActivityTranslate [ ACT_HL2MP_RUN ] 					= index+11
	self.ActivityTranslate [ ACT_HL2MP_WALK ]					= index+9
	self.ActivityTranslate [ ACT_HL2MP_IDLE_CROUCH ] 			= index+7
	self.ActivityTranslate [ ACT_HL2MP_WALK_CROUCH ] 			= index+2
	self.ActivityTranslate [ ACT_HL2MP_GESTURE_RANGE_ATTACK ] 	= PrimaryAttackGestures[ t ]
	self.ActivityTranslate [ ACT_HL2MP_GESTURE_RELOAD ] 		= ReloadGestures[ t ]
	self.ActivityTranslate [ ACT_HL2MP_JUMP ] 					= ACT_HOP
	--self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= PrimaryAttackGestures[ t ]
	
	self:SetupWeaponHoldTypeForAI( t )

end

