
SWEP.Author			= "Levybreak"
SWEP.Contact		= "Facepunch"
SWEP.Purpose		= "EMP! Pronounced 'EMP' not 'E-EM-PEE'"
SWEP.Instructions	= "Temporarily Disables all electronic devices in 750 unit radius. (7 seconds) Single use only."

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/Weapons/v_bugbait.mdl"
SWEP.WorldModel			= "models/Weapons/w_bugbait.mdl"
SWEP.HoldType			= "slam"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.RangeRadius = 750
SWEP.Duration = 7

local PlySnd = Sound("npc/roller/mine/rmine_shockvehicle2.wav")

function SWEP:Initialize()
	if ( SERVER ) then
       self:SetWeaponHoldType( self.HoldType )
	else

	end
end

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
	
end

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()
	if math.random(0,100) >= 75 then
		self.Weapon:SendWeaponAnim(ACT_VM_FIDGET)
	end
end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	
	
		self.Weapon:SetNextPrimaryFire(CurTime() + 1)
		
		if (!SERVER) then return end
		
		self.Weapon:SendWeaponAnim(ACT_VM_THROW)
		
		local ply = self.Owner
		local nade = ents.Create("prop_physics")
		nade:SetPos(ply:GetShootPos())
		nade:SetModel("models/Weapons/w_bugbait.mdl")
		nade:Spawn()
		nade:Activate()
		local phys = nade:GetPhysicsObject()

		phys:ApplyForceCenter(ply:GetAimVector()*3000)
		phys:SetDamping(phys:GetDamping()/2)

		local radius = self.RangeRadius
		timer.Simple(2, function() 
			if nade and ValidEntity(nade) then
				for k,v in ipairs(ents.FindInSphere(nade:GetPos(),radius)) do
					if v.TemporarilyDisable and not v.Hardened then
						v:TemporarilyDisable(self.Duration)
						local efct = EffectData()
						efct:SetEntity(v)
						efct:SetOrigin(v:GetPos())
						efct:SetStart(nade:GetPos())
						efct:SetScale(1)
						efct:SetMagnitude(5)
						util.Effect("TeslaZap",efct)
					end
				end
	
				nade:EmitSound(PlySnd)
				
				local efct = EffectData()
				efct:SetMagnitude(2)
				efct:SetScale(radius)
				efct:SetOrigin(nade:GetPos())
				util.Effect("emp_blast",efct)
				
				nade:Remove()
			end
		end)
		
		timer.Simple(1,function()
		local idx = nil
		for k,v in ipairs(ply.ItemList) do
			if v.Item and string.find(v.Item:GetName(),"EMP") then
				if v.Entity then v.Entity:Remove() end
				idx = k
				break				
			end
		end

		if idx and idx ~= nil then
			table.remove(ply.ItemList,idx)
			if not ply:HasItems({"Pocket EMP"}) then
				ply:StripWeapon("weapon_emp")
				ply:SendItems()
			else
				ply:SendItems()
			end
		else
			print("Lolwhat? No item?")
			ply:StripWeapon("weapon_emp")
		end
		end)
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	
	self.Weapon:SetNextSecondaryFire(CurTime() + 2)
		
		if (!SERVER) then return end
		
		--GAMEMODE:SetPlayerAnimation( self.Owner, PLAYER_ATTACK1 )
		
		local ply = self.Owner
		
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		
		for k,v in ipairs(ents.FindInSphere(ply:GetShootPos(),self.RangeRadius)) do
			if v.TemporarilyDisable and not v.Hardened then
				v:TemporarilyDisable(self.Duration)
				local efct = EffectData()
				efct:SetEntity(v)
				efct:SetOrigin(v:GetPos())
				efct:SetStart(ply:GetShootPos())
				efct:SetScale(1)
				efct:SetMagnitude(5)
				util.Effect("TeslaZap",efct)
			end
		end
	
		local efct = EffectData()
		efct:SetMagnitude(2)
		efct:SetScale(self.RangeRadius)
		efct:SetOrigin(ply:GetShootPos())
		util.Effect("emp_blast",efct)

		ply:EmitSound(PlySnd)
		
		
		local idx = nil
		for k,v in ipairs(ply.ItemList) do
			if v.Item and string.find(v.Item:GetName(),"EMP") then
				if v.Entity then v.Entity:Remove() end
				idx = k
				break				
			end
		end

		if idx and idx ~= nil then
			table.remove(ply.ItemList,idx)
			if not ply:HasItems({"Pocket EMP"}) then
				ply:StripWeapon("weapon_emp")
				ply:SendItems()
			else
				ply:SendItems()
			end
		else
			print("Lolwhat? No item?")
			ply:StripWeapon("weapon_emp")
		end
end


/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:DrawHUD()

	if (!CLIENT) then return end

end
