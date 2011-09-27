AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:ChangeWeaponHoldType(t)
	if self.LastHoldType == t then return end
	self.LastHoldType = t
	
	self:SetWeaponHoldType(t)
	umsg.Start("ChangeWeaponHoldType")
		umsg.Entity(self)
		umsg.String(t)
	umsg.End()
end

function SWEP:PrimaryAttack()
	if self.Owner.Hidden then return end
	
	local x, y = GAMEMODE:PositionToCell(self.Owner:GetPos())
	local c = GAMEMODE.CrateMap[x][y]
	
	if ValidEntity(c) and not c.Exploded then
		if not c.NotSolid and self.Owner.BombThrow and c:GetPos():Distance(self.Owner:GetPos()+Vector(0,0,24))<18 then
			self:ChangeWeaponHoldType("physgun")
			self:SetColor(255,255,255,255)
			self:SetSkin(1)
			c:Grab(self)
			if SERVER then
				self.GrabLoop:Play()
				self.Owner:SetNWBool("Grabbing", true)
			end
		end
	else
		if self.Owner:GetNWInt("SkullState")==2 then return false end
		if self.Owner.NumBombs and self.Owner.NumBombs>=self.Owner.NumBombsMax then return false end
		
		local e = ents.Create("bm_prop_bomb")
		e:SetCell(x, y)
		--e:SetOwner(self.Owner)
		e.Owner = self.Owner
		e.Power = self.Owner.Power
		e.BombType = self.Owner.BombType
		e:Spawn()
		
		self:EmitSound("Rock.ImpactSoft")
		
		if self.Owner.NumBombs then self.Owner.NumBombs = self.Owner.NumBombs + 1 end
	end
end

function SWEP:SecondaryAttack()
	if self.Owner.RemoteBombs then
		local b
		while #self.Owner.RemoteBombs>0 do
			b = nil
			repeat
				b = table.remove(self.Owner.RemoteBombs)
			until (ValidEntity(b) and not b.Exploded and b.NextExplode and not b.Unlinked) or #self.Owner.RemoteBombs==0
			
			if not ValidEntity(b) or b.Exploded then return end
			
			if b:OnRemoteTrigger(self.Owner) then
				break
			end
		end
	end
end

function SWEP:Think()
	if not self.Owner.Hidden and not self.Owner:KeyDown(IN_ATTACK) and ValidEntity(self.Owner.GrabbedBomb) then
		self.Owner.GrabbedBomb:Throw()
		if SERVER then
			self.GrabLoop:Stop()
			self.Owner:SetNWBool("Grabbing", false)
		end
		self:ChangeWeaponHoldType("normal")
		self:SetColor(0,0,0,0)
		local effect = EffectData()
			effect:SetOrigin(self.Owner:GetShootPos()+self.Owner:GetAimVector()*30)
			effect:SetNormal(self.Owner:GetAimVector())
			effect:SetAttachment(2)
		util.Effect("effect_gravgun_punch", effect, true, true)
		self.Owner:EmitSound("Weapon_MegaPhysCannon.Launch")
	end
	
	if not self.Owner:KeyDown(IN_RELOAD) then 
		self.ReloadPressed = false
	end
	
	if not self.Owner.Hidden and self.Owner:GetNWInt("SkullState")==3 then
		-- spamspamspamspam
		self:PrimaryAttack()
	end
	
	if not self.Owner.Hidden and self.Owner.BombKick then
		if not self.NextKickCheck or CurTime()>self.NextKickCheck then
			local x0, y0 = GAMEMODE:PositionToCell(self.Owner:GetPos() - self.Owner:GetAimVector() * 2)
			local x, y = GAMEMODE:PositionToCell(self.Owner:GetPos() + self.Owner:GetAimVector() * 5)
			if x==x0 and y==y0 then return end
			for _,v in pairs(ents.GetAll()) do
				if v.Kick and v.Explode and not v.Exploded and not v.NotSolid then
					local pX, pY = GAMEMODE:PositionToCell(v:GetPos())
					if pX==x and pY==y then
						v:Kick(x-x0, y-y0)
					end
				end
			end
			self.NextKickCheck = CurTime()+0.05
		end
	end
	
	if self.NextRestoreHoldType and CurTime()>self.NextRestoreHoldType then
		self:ChangeWeaponHoldType("normal")
		self.NextRestoreHoldType = nil
	end
	
	if self.NextHideWorldModel and CurTime()>self.NextHideWorldModel then
		self:SetColor(0,0,0,0)
		self.NextHideWorldModel = nil
	end
	
	if self.NextStartHideOwner and CurTime()>self.NextStartHideOwner then
		self:DoStartHideOwner()
		self.NextStartHideOwner = nil
	end
	
	if self.NextStopHideOwner and CurTime()>self.NextStopHideOwner then
		self:DoStopHideOwner()
		self.NextStopHideOwner = nil
	end
end

function SWEP:Reload()
	if self.ReloadPressed then return end
	
	self.ReloadPressed = true
	if not self.NextUseAbility or CurTime()>self.NextUseAbility then
		if self.Owner.AbilityType==1 then -- bomb punch
			self:ChangeWeaponHoldType("physgun")
			self:SetColor(255,255,255,255)
			self:SetSkin(0)
			self.NextRestoreHoldType = CurTime()+0.3
			self.NextHideWorldModel = CurTime()+0.4
			
			local punt = false
			
			local x0, y0 = GAMEMODE:PositionToCell(self.Owner:GetPos() - self.Owner:GetAimVector() * 2)
			local x, y = GAMEMODE:PositionToCell(self.Owner:GetPos() + self.Owner:GetAimVector() * 12)
			if x~=x0 or y~=y0 then
				for _,v in pairs(ents.GetAll()) do
					if v.Punch and v.Explode and not v.Exploded and not v.NotSolid then
						local pX, pY = GAMEMODE:PositionToCell(v:GetPos())
						if pX==x and pY==y then
							v:Punch(x-x0, y-y0, 2)
							v:StartHoldEffect(1, 2)
							punt = true
						end
					end
				end
			end
			
			if punt then
				local effect = EffectData()
					effect:SetOrigin(self.Owner:GetShootPos()+self.Owner:GetAimVector()*30)
					effect:SetNormal(self.Owner:GetAimVector())
				util.Effect("effect_gravgun_punch", effect, true, true)
				self.Owner:EmitSound("Weapon_PhysCannon.Launch")
			else
				self.Owner:EmitSound("Weapon_PhysCannon.DryFire")
			end
			
			self.NextUseAbility = CurTime() + 0.2
		end
	end
end

function SWEP:DoStartHideOwner()
	if self.Owner.Hidden then return end
	
	local x, y = GAMEMODE:PositionToCell(self.Owner:GetPos())
	local c = GAMEMODE.CrateMap[x][y]
	if ValidEntity(c) and not c.Exploded then return end
	
	local pos = GAMEMODE:CellToPosition(x, y, 0)
	
	local e = ents.Create("prop_dynamic")
	e:SetModel("models/props_junk/wood_crate001a.mdl")
	e:SetSolid(SOLID_VPHYSICS)
	e:SetPos(pos+Vector(0,0,24))
	e:SetColor(255,100,100,255)
	e:SetOwner(self.Owner)
	e:Spawn()
	e:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	e:DropToFloor()
	self.HideCrate = e
	
	local effect = EffectData()
		effect:SetOrigin(pos+Vector(0,0,24))
	util.Effect("effect_player_hide", effect, true, true)
	
	self.Owner.LastSpeed = self.Owner:GetNWInt("Speed")
	self.Owner:SetNWInt("Speed", 0)
	self.Owner:SetMoveType(MOVETYPE_OBSERVER)
	self.Owner:SetPos(pos)
	self.Owner:SetMoveType(MOVETYPE_NONE)
	self.Owner:SetColor(255,255,255,0)
	self.Owner.Hidden = true
end

function SWEP:StartHideOwner()
	self.NextStartHideOwner = CurTime() + 0.4
	self.NextStopHideOwner = nil
end

function SWEP:DoStopHideOwner()
	if not self.Owner.Hidden then return end
	
	self.Owner:SetNWInt("Speed", self.Owner.LastSpeed)
	if ValidEntity(self.HideCrate) then
		self.HideCrate:Remove()
		self.HideCrate = nil
	end
	
	local effect = EffectData()
		effect:SetOrigin(self.Owner:GetPos()+Vector(0,0,24))
	util.Effect("effect_player_hide", effect, true, true)
	
	self.Owner:SetColor(255,255,255,255)
	self.Owner.Hidden = false
end

function SWEP:StopHideOwner()
	self.NextStartHideOwner = nil
	self.NextStopHideOwner = CurTime() + 0.2
	self.Owner:SetMoveType(MOVETYPE_WALK)
end

hook.Add("KeyPress", "CrateHideKeyDown", function(pl, k)
	if pl.CrateHide and not pl.Hidden and k==IN_DUCK then
		local w = pl:GetActiveWeapon()
		if ValidEntity(w) and w.StartHideOwner then
			w:StartHideOwner()
		end
	end
end)

hook.Add("KeyRelease", "CrateHideKeyUp", function(pl, k)
	if pl.Hidden and k==IN_DUCK then
		local w = pl:GetActiveWeapon()
		if ValidEntity(w) and w.StopHideOwner then
			w:StopHideOwner()
		end
	end
end)

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:OnRemove()
	if SERVER and self.Owner.Hidden then
		self:DoStopHideOwner()
	end
	
	if ValidEntity(self.Owner.GrabbedBomb) then
		self.Owner.GrabbedBomb:Throw(true)
		if SERVER then
			self.GrabLoop:Stop()
			self.Owner:SetNWBool("Grabbing", false)
		end
	end
end
