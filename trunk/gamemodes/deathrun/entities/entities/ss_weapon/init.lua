AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Entity = {}

function ENT:Initialize()
	self.Entity:DrawShadow(false)
	
	self.Entity:SetCollisionBounds(Vector(-30, -30, -30), Vector(30, 30, 0))
	
	self.Entity:SetSolid(SOLID_BBOX)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	self.Entity:SetTrigger(true)
	self.Entity:SetNotSolid(true)
	
	if self.Entity.Type == "weapon_smg1" then
		self.Entity:SetModel("models/weapons/w_smg1.mdl")
	elseif self.Entity.Type == "weapon_crowbar" then
		self.Entity:SetModel("models/weapons/w_crowbar.mdl")
	else
		self.Entity.Type = "weapon_smg1"
		self.Entity:SetModel("models/weapons/w_smg1.mdl")
		//Msg("ss_weapon: No 'Type' exists, using weapon_smg1\n")
	end
	
	timer.Simple(0.1, function()
		if(IsValid(self.Entity)) then
			self.Entity:SetPos(self.Entity:GetPos() + Vector(0, 0, 30))
		end
	end)
	
	if(self:IsNearSpawn()) then
		self.Entity:Remove()
	end
end

function ENT:StartTouch(Ent)
	if(self:IsNearSpawn()) then
		self.Entity:Remove()
		return
	end
	if(Ent:IsPlayer() and Ent:Alive()) then
		if(gamemode.Call("PlayerCanPickupWeapon", Ent)) then
			local Weapon = Ent:GetActiveWeapon()
			if self.Entity.Type == "weapon_smg1" then
				if(IsValid(Weapon)) then
					if(Weapon:GetClass() == "weapon_smg1" and Weapon:Clip1() < 45 or Weapon:Clip1() <= 0) then
						Ent:StripWeapon("weapon_smg1")
					end
				end
			end
			if(!Ent:HasWeapon(self.Entity.Type)) then
				Ent:Give(self.Entity.Type)
				if self.Entity.Type == "weapon_smg1" then
					Ent:GiveAmmo(100, "SMG1")
				end
				self.Entity:EmitSound(self.OnTouchSound)
			end
		end
	end
end
