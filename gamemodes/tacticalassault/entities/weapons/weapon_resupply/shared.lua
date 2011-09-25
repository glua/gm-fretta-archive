if (SERVER) then
	AddCSLuaFile("shared.lua")
	
	SWEP.Weight = 1
	SWEP.HoldType = "slam"
end

if (CLIENT) then

	SWEP.PrintName = "RESUPPLY"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.BounceWeaponIcon   	= false
	
	// Override this in your SWEP to set the icon in the weapon selection
	if (file.Exists("../materials/weapons/weapon_resupply.vmt")) then
		SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_resupply")
	end

end

 SWEP.Author = "Entoros"; 
 SWEP.Contact = ""; 
 SWEP.Purpose = "Replenish ammo"; 
 SWEP.Instructions = "Primary: Give to target\nSecondary: Give to self";
 
 SWEP.Spawnable = false
 SWEP.AdminSpawnable = true;
   
 SWEP.ViewModel = "models/weapons/v_c4.mdl"
 SWEP.WorldModel = "models/weapons/w_c4.mdl"

 SWEP.Primary.ClipSize = -1; 
 SWEP.Primary.DefaultClip = -1; 
 SWEP.Primary.Automatic = false; 
 SWEP.Primary.Ammo = "none";
 
 SWEP.Secondary.Ammo = "none";
 SWEP.Primary.SelfGive		= Sound("weapons/c4/c4_disarm.wav")
SWEP.Primary.PlyGive        = Sound("buttons/weapon_confirm.wav") 
 SWEP.Delay = 15
SWEP.AmmoTypes = {
	[1] = "AR2",
	[4] = "SMG1",
	[3] = "Pistol",
	[5] = "357",
	[7] = "Buckshot",
	[6] = "XBowBolt",
	[10] = "Grenade",
	[8] = "RPG_Round",
	[20] = "AirboatGun",
}

SWEP.AmmoInfo = {
	["AR2"] = {max = 150,inc=50},
	["SMG1"] = {max=180,inc=60},
	["Pistol"] = {max=90,inc=30},
	["357"] = {max=45,inc=15},
	["Buckshot"] = {max=50,inc=15},
	["XBowBolt"] = {max=35,inc=10},
	["Grenade"] = {max=6,inc=2},
	["RPG_Round"] = {max=6,inc=2},
	["Slam"] = {max=6,inc=2},
	["AirboatGun"] = {max=200,inc=50},
}
   
 function SWEP:PrimaryAttack()
	
	local ent = self.Owner:GetEyeTrace().Entity
	if not self.Owner:GetEyeTrace().HitNonWorld or not ent:IsPlayer() or ent:GetPos():Distance(self.Owner:GetPos()) > 100  then return false end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Delay )

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self:AddAmmo(ent,true)
end

function SWEP:Deploy()
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end

function SWEP:AddAmmo(pl,primary)
	if SERVER then
		if primary then
			self.Weapon:EmitSound(self.Primary.PlyGive)
			local ammotype = pl:GetActiveWeapon():GetPrimaryAmmoType()
			if self.AmmoTypes[ammotype] then pl:GiveAmmo(self.AmmoInfo[self.AmmoTypes[ammotype]].inc,self.AmmoTypes[ammotype]) end
		else
			self.Weapon:EmitSound(self.Primary.SelfGive)
			local t = 0
			while !self.AmmoTypes[t] do
				t = table.Random(pl:GetWeapons()):GetPrimaryAmmoType()
			end
			pl:GiveAmmo(self.AmmoInfo[self.AmmoTypes[t]].inc,self.AmmoTypes[t])
		end
	end
	timer.Simple(self.Delay,function()
		if self.Owner and self.Weapon and self.Weapon:IsValid() and self.Owner:Alive() and self.Owner:GetActiveWeapon() == self.Weapon then self.Weapon:SendWeaponAnim( ACT_VM_DRAW ) end
	end)
end

function SWEP:SecondaryAttack()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Delay )
	
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self:AddAmmo(self.Owner,false)
end
