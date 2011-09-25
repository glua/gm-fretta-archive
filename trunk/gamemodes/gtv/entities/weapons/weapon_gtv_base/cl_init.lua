SWEP.Author = "Ghor"
SWEP.Base = "weapon_base"
SWEP.PrintName = "GTV weapon base"
SWEP.Slot = 2
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Primary.Automatic = true
SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.Ammo = "none"
SWEP.LastFired = 0
SWEP.Cooldown = 0.1
SWEP.AmmoCost = 0

function SWEP:CanFire()
	return (self.LastFired+self.Cooldown < CurTime()) && ((self.Primary.Ammo == "none") || (self:Ammo1() >= self.AmmoCost))
end

function SWEP:IsCooledDown()
	return self.LastFired+self.Cooldown < CurTime()
end

function SWEP:SetNextFire()
	self:SetNextPrimaryFire(CurTime()+self.Cooldown)
	self.LastFired = CurTime()
end

function SWEP:PrimaryAttack()
	if !self:CanFire() then
		return
	end
	if (self.HoldType == "slam") || (self.HoldType == "rpg") || (self.HoldType == "shotgun") then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	self:Shoot()
	self:TakePrimaryAmmo(self.AmmoCost)
	self:SetNextFire()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {} 
	self.AmmoDisplay.Draw = false
	return self.AmmoDisplay
end

function SWEP:DrawWeaponSelection(x,y,wide,tall,alpha)
	surface.SetDrawColor(255,255,255,255)
	if self.Color then
		surface.SetDrawColor(self.Color.r,self.Color.g,self.Color.b,self.Color.a)
	end
	surface.SetTexture(self.tex)
	surface.DrawTexturedRect(x+(wide-tall)/2,y,tall,tall)
end
	


--[[
function SWEP:DrawHUD()
	local x = ScrW()-40
	local y = ScrH()-56
	local w = 200*5
	local scale = 1
	surface.SetDrawColor(255,255,255,255)
	if self.AmmoCost != 0 then
	/*
		local startx = x-self.Weapon:Ammo1()*scale+2
		local units = math.floor(self.Weapon:Ammo1()/self.AmmoCost)
		if self.Weapon:Ammo1()/self.AmmoCost != units then
			surface.DrawRect(startx,y-16,(self.Weapon:Ammo1()-units*self.AmmoCost)*scale,16) --draw first bar
		end
		startx = x+units*self.AmmoCost*scale
		local unitw = self.AmmoCost*scale
		for i=0,units-1 do
			surface.DrawRect(startx+i*unitw+2,y-16,startx+i*unitw,16)
		end
		*/
		local unitw = self.AmmoCost*scale*2+(self.AmmoCost-1)*2
		for i=0,(self.Weapon:Ammo1()/self.AmmoCost)-1 do
			
			if i*self.AmmoCost < 100 then
				surface.DrawRect(x-(i+1)*(unitw+2),y,unitw,16)
				--surface.DrawRect(x-(i-1)*((4*scale*self.AmmoCost)+2),y-16,4*scale*self.AmmoCost,16)
			else
				surface.DrawRect(x-(i+1)*(unitw+2)+400,y-18,unitw,16)
				//surface.DrawRect(x-(i-99)*(unitw+2),y-18,unitw,16)
				--surface.DrawRect(x-((i-1)*self.AmmoCost-100)*((4*scale*self.AmmoCost)+2),y-34,4*scale*self.AmmoCost,16)
			end
		end
	end
end
]]

function ENT:DrawWorldModel()
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
end

usermessage.Hook("ent_emitsound",function(um)
									local ent = um:ReadEntity()
									if !ent:IsValid() then
										return
									end
									local sound = um:ReadString()
									local vol = um:ReadChar()+127
									local pitch = um:ReadChar()+127
									if vol == 0 then
										vol = nil
									end
									if pitch == 0 then
										pitch = nil
									end
									ent:EmitSound(sound,vol,pitch)
								end)
								
--CreateClientConVar("~l2",tostring(CurTime()),true,true)

--hook.Add("Tick","updatetime",function() RunConsoleCommand("~l2",tostring(CurTime())) end)