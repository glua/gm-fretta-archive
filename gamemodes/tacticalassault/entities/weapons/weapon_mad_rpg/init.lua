AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


/*---------------------------------------------------------
   Name: SWEP:NPCShoot_Primary()
   Desc: NPC tried to fire primary attack.
---------------------------------------------------------*/
function SWEP:NPCShoot_Primary(ShootPos, ShootDir)

	if (not self:CanPrimaryAttack()) then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	self.Weapon:EmitSound(self.Primary.Sound)

	self:TakePrimaryAmmo(1)

	self:Rocket()
end