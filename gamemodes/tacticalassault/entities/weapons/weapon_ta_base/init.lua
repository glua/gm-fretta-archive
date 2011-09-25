AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight					= 5		// Decides whether we should switch from/to this
SWEP.AutoSwitchTo				= true	// Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true	// Auto switch from if you pick up a better weapon

SWEP.HoldType				= "pistol"

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self.Owner:ChatPrint("USING PRIMARY ATTACK")
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNWBool("Ironsights",!self.Weapon:GetNWBool("Ironsights"))
end

function SWEP:CanPrimaryAttack()
	if self.Owner:KeyDown(IN_SPEED) then return false end
	
	return true
end

/*---------------------------------------------------------
   Name: SWEP:OnRestore()
   Desc: The game has just been reloaded. This is usually the right place
	   to call the GetNetworked* functions to restore the script's values.
---------------------------------------------------------*/
function SWEP:OnRestore()
end

/*---------------------------------------------------------
   Name: SWEP:AcceptInput()
   Desc: Accepts input, return true to override/accept input.
---------------------------------------------------------*/
function SWEP:AcceptInput(name, activator, caller, data)

	return false
end

/*---------------------------------------------------------
   Name: SWEP:KeyValue()
   Desc: Called when a keyvalue is added to us.
---------------------------------------------------------*/
function SWEP:KeyValue(key, value)
end

/*---------------------------------------------------------
   Name: SWEP:OnRemove()
   Desc: Called just before entity is deleted.
---------------------------------------------------------*/
function SWEP:OnRemove()
end

/*---------------------------------------------------------
   Name: SWEP:Equip()
   Desc: A player or NPC has picked the weapon up.
---------------------------------------------------------*/
function SWEP:Equip(NewOwner)
end

/*---------------------------------------------------------
   Name: SWEP:EquipAmmo()
   Desc: The player has picked up the weapon and has taken the ammo from it.
	   The weapon will be removed immidiately after this call.
---------------------------------------------------------*/
function SWEP:EquipAmmo(NewOwner)
end

/*---------------------------------------------------------
   Name: SWEP:OnDrop()
   Desc: Weapon was dropped.
---------------------------------------------------------*/
function SWEP:OnDrop()
end

/*---------------------------------------------------------
   Name: SWEP:ShouldDropOnDie()
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()

	return true
end
