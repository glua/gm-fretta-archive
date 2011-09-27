include("shared.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

ItemTypes = {
	item_bombup 		= {20,	function(pl) pl.NumBombsMax = math.Clamp(pl.NumBombsMax+1, 1, 12) end},
	item_bombdown 		= {12, 	function(pl) pl.NumBombsMax = math.Clamp(pl.NumBombsMax-1, 1, 12) end, true},
	item_fireup   		= {20, 	function(pl) pl.Power = math.Clamp(pl.Power+1, 1, 12) end},
	item_superfireup   	= {1.5, function(pl) pl.Power = 12 end},
	item_firedown 		= {12, 	function(pl) pl.Power = math.Clamp(pl.Power-1, 1, 12) end, true},
	item_speedup 		= {20, 	function(pl) pl:SetNWInt("Speed", math.Clamp(pl:GetNWInt("Speed")+15, 85, 350)) end},
	item_speeddown		= {12, 	function(pl) pl:SetNWInt("Speed", math.Clamp(pl:GetNWInt("Speed")-15, 85, 350)) end},
	item_remotebomb 	= {1, 	function(pl) pl.BombType = 1 end},
	item_plasmabomb 	= {2, 	function(pl) pl.BombType = 2 end},
	item_randombomb 	= {2, 	function(pl) pl.BombType = 3 end},
	item_rocketbomb 	= {1.2, function(pl) pl.BombType = 4 end},
	item_minebomb 		= {2, 	function(pl) pl.BombType = 5 end},
	item_invisbomb 		= {1.2,	function(pl) pl.BombType = 6 end},
	item_dangerbomb		= {1.6,	function(pl) pl.BombType = 7 end},
	
	--item_radiobomb		= {1.6,	function(pl) pl.BombType = 8 end},
	--item_physicsbomb	= {1.6,	function(pl) pl.BombType = 9 end},
	--item_nukebomb		= {1.6,	function(pl) pl.BombType = 10 end},
	
	item_skull			= {2,	function(pl)
									local e = ents.Create("bm_skull")
									e.Owner = pl
									e:Spawn()
								end, true, true},
	item_bombkick	 	= {1.5, function(pl) pl.BombKick = true end},
	item_bombpunch	 	= {1.5, function(pl) pl.AbilityType = 1 end},
	item_bombthrow	 	= {1.5, function(pl) pl.BombThrow = true end},
	item_cratehide	 	= {1.5, function(pl) pl.CrateHide = true end},
}

BombTypeIDs = {"item_remotebomb","item_plasmabomb","item_randombomb","item_rocketbomb","item_minebomb","item_invisbomb","item_dangerbomb"}
AbilityTypeIDs = {"item_bombpunch"}

function ENT:Initialize()
	if not self.ItemType or not ItemTypes[self.ItemType] then
		ErrorNoHalt("Error : Could not create item '"..tostring(self.ItemType).."'\n")
		self:Remove()
		return
	end
	
	self:SetSolid(SOLID_BBOX)
	self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(true)
	self:SetMoveType(MOVETYPE_NONE)
	
	self:SetMultiModel(self.ItemType)
	self.ItemData = ItemTypes[self.ItemType]
end

function ENT:SetCell(x, y)
	self.Cell = {x, y}
	self:SetPos(GAMEMODE:CellToPosition(x, y, 24))
end

function ENT:Think()
	if self.NextDie and CurTime()>self.NextDie then
		local data = EffectData()
			data:SetOrigin(self:GetPos()+Vector(0,0,-18))
		util.Effect("effect_item_destroyed", data, true, true)
		self:Remove()
	end
end

function ENT:Explode()
	if not self.ItemData[4] and self.Touch then
		self.Touch = nil
		self.NextDie = CurTime()+0.7
		self:SetNoDraw(true)
		self:SetTrigger(false)
	end
end

function ENT:Pickup(pl)
	local data = EffectData()
	data:SetOrigin(self:GetPos()+Vector(0,0,-18))
	if self.ItemData[3] then
		data:SetAttachment(2)
	else
		data:SetAttachment(1)
	end
	util.Effect("effect_item_pickup", data, true, true)
	
	self.ItemData[2](pl)
	
	self.Touch = nil
	self:SetNoDraw(true)
	self:SetTrigger(false)
	SafeRemoveEntityDelayed(self, 0.5)
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		self:Pickup(ent)
	end
end
