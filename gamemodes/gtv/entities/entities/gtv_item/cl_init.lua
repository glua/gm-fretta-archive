include("shared.lua")
ENT.Author = "Ghor"
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Created = 0
ENT.Model = "models/Items/grenadeAmmo.mdl"
ENT.Particles = {}
	ENT.Particles["models/items/item_item_crate.mdl"] = "gtv_ammoring_large"
	ENT.Particles["models/items/boxmrounds.mdl"] = "gtv_ammoring_medium"
	ENT.Particles["models/items/boxbuckshot.mdl"] = "gtv_ammoring_small"
	ENT.Particles["models/weapons/w_irifle.mdl"] = "gtv_weaponring"
	ENT.Particles["models/weapons/w_rocket_launcher.mdl"] = "gtv_weaponring"
	ENT.Particles["models/weapons/w_shotgun.mdl"] = "gtv_weaponring"
	ENT.Particles["models/weapons/w_smg1.mdl"] = "gtv_weaponring"
	
function ENT:Initialize()
	self:SetModel(gtv_itemtable[self.dt.ItemType].Model)
	self.Created = CurTime()
	self:SetMoveType(MOVETYPE_NONE)
	if gtv_itemtable[self.dt.ItemType].ParticleEffect then
		self.ParticleEffect = gtv_itemtable[self.dt.ItemType].ParticleEffect
	end
	//self.dlight = DynamicLight(0)
end

function ENT:Think()
/*
	if self.dlight then
		local r,g,b,a = 255,255,255,255
		self.dlight.r = 255
		self.dlight.g = 255
		self.dlight.b = 255
		self.dlight.Pos = self:GetPos()
		self.dlight.Brightness = 1
		self.dlight.Size = 256
		self.dlight.Decay = 32
		self.dlight.DieTime = CurTime()+2
	end
	*/
	if self.ParticleEffect then
		ParticleEffectAttach(self.ParticleEffect,PATTACH_ABSORIGIN_FOLLOW,self,0)
		self.ParticleEffect = nil
	end
end

function ENT:Draw()
	render.SuppressEngineLighting(true)
	self:DrawModel()
	render.SuppressEngineLighting(false)
end