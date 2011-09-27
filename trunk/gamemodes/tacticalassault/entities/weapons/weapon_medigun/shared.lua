// DYANMIC LIGHT + SPRITES UNDER TARGET (SEE - GMOD_LIGHT)

if (SERVER) then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	
	SWEP.Weight = 1
end

if (CLIENT) then

	SWEP.PrintName = "MEDIGUN"
	SWEP.Slot = 2
	SWEP.SlotPos = 2
	if (file.Exists("../materials/weapons/weapon_mad_medic.vmt")) then
		SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_medic")
	end
	
	language.Add("npc_cscanner","Medibot")

end

 SWEP.Author = "Entoros"; 
 SWEP.Contact = ""; 
 SWEP.Purpose = "Create healbots"; 
 SWEP.Instructions = "Primary: Lay down health packs\nSecondary: Spawn/direct healbot\nSecondary+Reload: Remove healbot"
 SWEP.Base = "weapon_ta_base";
 
 SWEP.Spawnable = false
 SWEP.AdminSpawnable = true;
   
SWEP.ViewModel			= "models/items/v_medkit2.mdl"
SWEP.WorldModel			= "models/items/w_medkit.mdl"
SWEP.ViewModelFOV 		= 80
SWEP.HoldType = "slam"

SWEP.Primary.Sound 		= Sound("HealthVial.Touch")
SWEP.Secondary.Sound 		= Sound("WeaponFrag.Throw")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 10

SWEP.Primary.ClipSize		= 1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.RunAng = Angle(20,0,15)
SWEP.RunPos = Vector(0,0,-1)

SWEP.Scanner = nil
SWEP.Target = nil
SWEP.ActionDelay = 0
SWEP.ScannerTimer = 0
SWEP.ScannerDelay = 30
 
 function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	timer.Create(self:EntIndex().."heal",0.2,0,function() 
		if ValidEntity(self.Scanner) and ValidEntity(self.Target) and self.Scanner:GetPos():Distance(self.Target:GetPos()) < 250 then
			self.Target:SetHealth(math.Clamp(self.Target:Health() + 2,0,100))
		end
	end)
 end
 
 function SWEP:Think()
	 self:UpdateScanner()
	 self:NextThink(CurTime())
	 return true
end
 
 function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(0.7)
	return true
end

function SWEP:Holster()
	if ValidEntity(self.Owner) and self.Owner:GetViewModel():IsValid() then self.Owner:GetViewModel():SetPlaybackRate(1) end
	return true
end
 
 function SWEP:PrimaryAttack()
	
	if !self:CanPrimaryAttack() then return end

	if not IsFirstTimePredicted() then return end
	if self.ActionDelay > CurTime() then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.ActionDelay = (CurTime() + self.Primary.Delay)

	self.Weapon:SendWeaponAnim(ACT_VM_HOLSTER) 			// View model animation

	timer.Simple(1, function()
		if (not self.Owner:Alive() or self.Weapon:GetOwner():GetActiveWeapon():GetClass() ~= "weapon_medigun" or not IsFirstTimePredicted()) then return end
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW) 			// View model animation
	end)

	timer.Simple(0.75, function()
		self.Owner:SetAnimation(PLAYER_ATTACK1)				// 3rd Person Animation

		if (SERVER) then
			self.Weapon:EmitSound(self.Secondary.Sound)
		end

		if (CLIENT) then return end

		local health = ents.Create("ent_mad_medic")

		health.Owner = self.Owner
		
		local pos = self.Owner:GetShootPos() + self.Owner:GetUp() * -12.5
		health:SetPos(pos)	
		
		health:SetAngles(self.Owner:GetAngles())
		health:Spawn()

		local phys = health:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector() * 200)
		
		timer.Simple(15,function() if ValidEntity(health) then health:Remove() end end)
	end)
	
end

function SWEP:MakeScanner()
	self.Scanner = ents.Create("npc_cscanner")
	self.Scanner:SetPos(self.Owner:GetShootPos() + Vector(0,0,70))
	self.Scanner:SetNWInt("Team",self.Owner:Team())
	self.Scanner:SetKeyValue("OnlyInspectPlayers","1")
	self.Scanner:SetKeyValue("spotlightlength","1000")
	self.Scanner:SetKeyValue("spotlightwidth","1000")
	self.Scanner:Spawn()
	
	self.Owner:SetName(self.Owner:SteamID())

	self.Scanner:Fire("StartScripting","",0)
	self.Scanner:Fire("SetFlightSpeed","400",0)
	self.Scanner:Fire("SetFollowTarget",self.Owner:SteamID(),0)
	self.Scanner:Fire("InspectTargetSpotlight",self.Owner:SteamID(),1)
	
	self.Target = self.Owner
	self.ScannerTimer = CurTime()
	
	self.Weapon:EmitSound("weapons/physcannon/physcannon_drop.wav")
	self:SetNWEntity("scanner",self.Scanner)
end

function SWEP:SecondaryAttack()

	if !self:CanPrimaryAttack() || CLIENT then return end
	
	if not self.Scanner and CurTime() - self.ScannerTimer > self.ScannerDelay then
		
		self:MakeScanner()
		if not self.Scanner:IsInWorld() then
			self.Owner:ChatPrint("That is not a valid location!")
			self.Scanner:Remove()
		end
		
	elseif self.Owner:KeyDown(IN_RELOAD) and ValidEntity(self.Scanner) then
	
		self.Scanner:Remove()
		self.Scanner = nil
	
	elseif self.Scanner then
	
		local ent = self.Owner:GetEyeTrace().Entity
		if ValidEntity(ent) and ent:IsPlayer() and ent:Team() == self.Owner:Team() then
		
			self.Target = ent
			self:SetNWEntity("targ",ent)
			self.Target:SetName(self.Target:SteamID())
			self.Owner:ChatPrint("Healing "..self.Target:Name())
			
			self.Weapon:EmitSound("UI/buttonclickrelease.wav")
		else
			self.Weapon:EmitSound("common/wpn_denyselect.wav")
		end
		
		
	else
		self.Owner:ChatPrint("Wait "..tostring(math.ceil(self.ScannerDelay - (CurTime() - self.ScannerTimer))).. " more seconds before creating a medibot.")
	end
end

function SWEP:UpdateScanner()
	if ValidEntity(self.Scanner) and ValidEntity(self.Target) and self.Target:IsPlayer() then
		self.Scanner:Fire("SetFollowTarget",self.Target:SteamID(),0)
		self.Scanner:Fire("InspectTargetSpotlight",self.Target:SteamID(),0)
	end
end


function SWEP:Think()
	
	if not ValidEntity(self.Scanner) then self.Scanner = nil end
	if not ValidEntity(self.Target) then self.Target = nil end
end

function SWEP:OnRemove()
	if ValidEntity(self.Scanner) then self.Scanner:Remove() end
	
	timer.Destroy(self:EntIndex().."heal")
end