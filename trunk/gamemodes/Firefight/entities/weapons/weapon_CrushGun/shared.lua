-- not actually used because its crap

if (SERVER) then 
 
   AddCSLuaFile ("shared.lua");
 
   SWEP.Weight = 5;
   SWEP.AutoSwitchTo = false;
   SWEP.AutoSwitchFrom = false;
 
end
 
if (CLIENT) then 
 
   SWEP.PrintName = "Crush Gun";
   SWEP.Slot = 1;
   SWEP.SlotPos = 1;
   SWEP.DrawAmmo = false;
   SWEP.DrawCrosshair = true;
 
end
 
 
SWEP.Author = "Carnag3";
SWEP.Contact = "mousey76397@gmail.com";
SWEP.Purpose = "Crush Stuff";
SWEP.Instructions = "Shoot away from Face!";
 
SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;
 
SWEP.ViewModel = "models/weapons/v_pistol.mdl";
SWEP.WorldModel = "models/weapons/w_pistol.mdl";
 
SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "none";
 
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";
 
 
function SWEP:Reload()
end
 
function SWEP:Think()
end
 
function SWEP:PrimaryAttack()
	self.BaseClass.ShootEffects(self);	
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.75 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 1.75 )
	
	if (!SERVER) then return end;
 
	local ent = ents.Create ("prop_physics");
	ent:SetModel("models/props_junk/TrashDumpster01a.mdl");
	ent:SetPos(self.Owner:GetEyeTrace().HitPos + Vector(0,0,200));
	ent:SetAngles(self.Owner:EyeAngles());
	local physobj = ent:GetPhysicsObject()
		if physobj:IsValid() then
			physobj:SetMass(5000)
		end
	ent:Spawn();
	
	timer.Simple(5, function() ent:Remove() end)
end
 

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end
 