if (SERVER) then
	AddCSLuaFile("shared.lua")
	
	SWEP.Weight = 1
	SWEP.HoldType = "slam"
end

if (CLIENT) then
	
	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "C4 EXPLOSIVE"
	SWEP.IconLetter = "H"
	SWEP.Slot = 5
	
	if (file.Exists("../materials/weapons/weapon_mad_c4.vmt")) then
		SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_c4")
	end

end

 SWEP.Author = "Entoros"; 
 SWEP.Contact = ""; 
 SWEP.Purpose = "Destroy objectives"; 
 SWEP.Instructions = "Primary: Plant bomb";
 
 SWEP.Spawnable = false
 SWEP.AdminSpawnable = true;
   
 SWEP.ViewModel = "models/weapons/v_c4.mdl"
 SWEP.WorldModel = "models/weapons/w_c4.mdl"

 SWEP.Primary.ClipSize = -1; 
 SWEP.Primary.DefaultClip = -1; 
 SWEP.Primary.Automatic = false; 
 SWEP.Primary.Ammo = "none";
 
 SWEP.Secondary.Ammo = "none";
 SWEP.Beep = Sound("weapons/c4/c4_beep1.wav")
   
 function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()
	if !tr.HitNonWorld || tr.Entity:GetClass() != "obj_explode_win" || tr.Entity:GetPos():Distance(self.Owner:GetPos()) > 100 then 
		if SERVER then self.Owner:SendLua("surface.PlaySound(\"common/wpn_denyselect.wav\")") end
		return
	end
 
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Owner:Freeze(true)
	
		timer.Simple(3.8,function()
			
			local tr = {}
			tr.start = self.Owner:GetShootPos()
			tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
			tr.filter = {self.Owner}
			local trace = util.TraceLine(tr)

			if not trace.Hit then
				timer.Simple(0.6, function()
					if self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
						self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
					else
						self.Weapon:Remove()
						self.Owner:ConCommand("lastinv")
					end
				end)

				return 
			end

			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self:TakePrimaryAmmo(1)

			if (CLIENT) then return end
			local C4 = ents.Create("ent_bomb")

			C4:SetPos(trace.HitPos + trace.HitNormal)

			trace.HitNormal.z = -trace.HitNormal.z

			C4:SetAngles(trace.HitNormal:Angle() - Angle(90, 180))

			C4:Spawn()

			if trace.Entity and trace.Entity:IsValid() then
				if not trace.Entity:IsNPC() and not trace.Entity:IsPlayer() and trace.Entity:GetPhysicsObject():IsValid() then
					constraint.Weld(C4, trace.Entity)
				end
			else
				C4:SetMoveType(MOVETYPE_NONE)
			end

			C4:TurnOn(self.Owner)
			C4:SetNWInt("Team",self.Owner:Team())
			C4:SetNWEntity("target",tr.Entity)
			trace.Entity:SetNWEntity("bomb",prop)
			trace.Entity:SetNWInt("bomb_team",self.Owner:Team())
			
			self.Owner:Freeze(false)
			self.Owner:SelectWeapon(self.Owner:GetWeapons()[1]:GetClass())
		end)

		
end

function SWEP:Deploy()
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end