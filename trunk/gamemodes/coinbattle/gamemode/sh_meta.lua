
local PLAYER = FindMetaTable("Player")

if not PLAYER then return end

function PLAYER:SetCoins(num)
	
	if not SERVER then return end
	num = math.Clamp(num,0,num)
	self:SetNWInt("Coins", num)
	
end

function PLAYER:GetCoins()
	
	return self:GetNWInt("Coins") or 0
	
end

function PLAYER:AddCoins(num)
	
	self:SetCoins(self:GetCoins() + num)
	
end

function PLAYER:SetBankCoins(num)
	
	if not SERVER then return end
	num = math.Clamp(num,0,num)
	self.BankCoins = num
	
	SendUserMessage("BankCoinsUpdate",self,num)
	
end

usermessage.Hook("BankCoinsUpdate",function(um)
	
	LocalPlayer().BankCoins = um:ReadLong()
	
end)

function PLAYER:GetBankCoins()
	
	return self.BankCoins or 0
	
end

function PLAYER:AddBankCoins(num)
	
	self:SetBankCoins(self:GetBankCoins() + num)
	
end

function PLAYER:SetLOWeapon(slot, weapon)
	
	if not SERVER then return end
	self.loadout = self.loadout or {}
	
	local want = WeaponTable[slot][weapon]
	
	if slot == 3 then

		if self:GetBankCoins() >= want.cost and want ~= self.loadout[slot] then
			self:SetGrenades(3)
			self:AddBankCoins(-want.cost)
			self.loadout[slot] = want
		end

	else

		for _,wep in pairs(WeaponTable[slot]) do
			
			if self:GetBankCoins() >= want.cost then
				if want ~= wep then
					if self:HasWeapon(wep.entity) then
						self:GetWeapon(wep.entity):Remove()
					end
				else
					if not self:HasWeapon(want.entity) then
						self:Give(wep.entity)
						self:SelectWeapon(wep.entity)
						self:AddBankCoins(-wep.cost)
						self.loadout[slot] = want
					end
				end
			end
			
		end

	end
	
end

function PLAYER:GetLOWeapon(slot)
	
	if not SERVER then return end
	return self.loadout[slot]
	
end

function PLAYER:SetInvisible(bool)

	if not SERVER then return end
	self:SetNWBool("Invisible", bool)

	timer.Simple(0,function(ply)
		if ply:IsValid() then
			local wep = ply:GetActiveWeapon()
			if wep:IsValid() then
				wep:SetNextPrimaryFire(CurTime()+0.5)
				wep:SetNextSecondaryFire(CurTime()+0.5)
			end
		end
	end,self)

end

function PLAYER:GetInvisible()
	return self:GetNWBool("Invisible", false)
end

function PLAYER:SetGrenades(num)
	
	if not SERVER then return end
	num = math.Clamp(num,0,num)
	self.Grenades = num
	
	SendUserMessage("GrenadesUpdate",self,num)
	
end

usermessage.Hook("GrenadesUpdate",function(um)
	
	LocalPlayer().Grenades = um:ReadLong()
	
end)

function PLAYER:GetGrenades()
	
	return self.Grenades or 0
	
end

function PLAYER:AddGrenades(num)
	
	self:SetGrenades(self:GetGrenades() + num)
	
end

function PLAYER:FireGrenade(nade)

	if not SERVER then return end

	if self:GetLOWeapon(3) and self.NextGrenadeFire <= CurTime() and self:GetGrenades() > 0 then
		local ent = ents.Create(self:GetLOWeapon(3).entity)
		ent:SetPos(self:GetPos() + Vector(0,0,48))
		ent:SetOwner(self)
		ent:SetTeam(self:Team())
		ent:Spawn()
		self.NextGrenadeTime = CurTime()+2
		self:AddGrenades(-1)
	end

end