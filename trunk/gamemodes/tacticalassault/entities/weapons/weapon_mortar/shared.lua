if (SERVER) then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	
	SWEP.Weight = 1
end

if (CLIENT) then

	SWEP.PrintName = "Mortar"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false

end

SWEP.Author = "Entoros"; 
SWEP.Contact = ""; 
SWEP.Purpose = "Explode"; 
SWEP.Instructions = "Boom!"
SWEP.Base = "weapon_ta_base"
 
SWEP.Spawnable = false 
SWEP.AdminSpawnable = true;
   
SWEP.ViewModel = "models/weapons/v_RPG.mdl"
SWEP.WorldModel = "models/w_rpg.mdl"
	SWEP.HoldType = "rpg"

SWEP.Primary.ClipSize = 10; 
SWEP.Primary.DefaultClip = 10; 
SWEP.Primary.Automatic = false; 
SWEP.Primary.Ammo = "rpg_round";
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1;
 SWEP.ViewModelFlip = true

SWEP.IronSightsPos = Vector (0,0,-45)
SWEP.IronSightsAng = Vector (40, 2, -0.0532)

 
SWEP.Delay = 2
SWEP.FireSound = Sound("weapons/grenade_launcher1.wav")
SWEP.AttackPos = Vector(0,0,-10)
SWEP.AttackAng = Vector(-30,0,0)
    
 function SWEP:PrimaryAttack()
	
	if !self:CanPrimaryAttack() then return end
	
	local pl = self.Owner
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Delay )
	self.Weapon:EmitSound(self.FireSound)
	self.Owner:RemoveAmmo(1,self.Primary.Ammo)
	self.Weapon:SetNWBool("attack_anim",true)
	timer.Simple(2,function() if self.Weapon:IsValid() then self.Weapon:SetNWBool("attack_anim",false) end end)
	
	local bomb = ents.Create("prop_physics")
	bomb:SetPos(pl:GetShootPos() + pl:GetForward() * 10 - pl:GetRight() * 30 - Vector(0,0,50))
	bomb:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	bomb:Spawn()
	bomb:Activate()

	
	local phys = bomb:GetPhysicsObject()
	phys:SetVelocity(pl:GetForward() * 7000 + Vector(0,0,10000))
	
	self.Attack = true

	
end
 
 function SWEP:Initialize()
	self.Attack = false
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end
