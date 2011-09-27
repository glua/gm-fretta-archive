WMOD.Name		= "'Nade Launcher"
WMOD.PositiveDesc	= "Fire timed nades (USE key)"
WMOD.NegativeDesc	= "Reduces movespeed"
WMOD.Category	= 3

function WMOD:IsApplicable (classname)
	return (classname != "weapon_lnl_pistol") and (classname != "weapon_lnl_cannon") and (classname != "weapon_lnl_crossbow")
end

function WMOD:Apply (wpn)
	local wpntbl = wpn:GetTable()
	wpntbl.Tertiary.Name = "'Nade Launcher"
	wpntbl.Tertiary.Delay = 10
	function wpntbl.Tertiary.Attack (self)
		if (self.Tertiary.NextAttack or 0) > CurTime() or self.ReloadStartTime then
			return
		end
		self.Weapon:SendWeaponAnim (ACT_VM_SECONDARYATTACK)
		self.Tertiary.NextAttack = CurTime() + self.Tertiary.Delay
		if CLIENT then return end
		self.Owner:EmitSound ("weapons/grenade_launcher1.wav")
		local grenade = ents.Create ("lnl_nade")
		
		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:EyeAngles()
		
		pos = pos + 8 * ang:Forward()
		if self.Owner:KeyDown (IN_ATTACK2) then
			pos = pos + 4 * ang:Right()
		else
			pos = pos + 8 * ang:Right()
		end
		pos = pos + -6 * ang:Up()
		
		grenade:SetPos (pos)
		grenade:SetOwner (self.Owner)
		grenade:Spawn()
		
		local phys = grenade:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocity (self.Owner:GetAimVector() * 3000)
		end
	end
	--[[function wpntbl.Tertiary.Think (self)
		
	end]]
	function wpntbl.Tertiary.GetFractionReady (self)
		return math.min (1, 1 - ((self.Tertiary.NextAttack or 0) - CurTime()) / self.Tertiary.Delay)
	end
	
	function wpntbl.Tertiary.DrawHUD (self)
		
	end
	
	wpntbl.WalkSpeedMultiplier	= wpntbl.WalkSpeedMultiplier * 0.8
	wpntbl.RunSpeedMultiplier	= wpntbl.RunSpeedMultiplier * 0.8
end