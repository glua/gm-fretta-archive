AddCSLuaFile("shared.lua")
AddCSLuaFile("shd_playeranim.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_camera.lua")
AddCSLuaFile("cl_scoreboard_override.lua")

AddCSLuaFile("shd_module_multimodel.lua")
AddCSLuaFile("shd_models.lua")

AddCSLuaFile("vgui/vgui_victory_counter.lua")

include("shared.lua")
include("sv_cells.lua")
include("sv_suddendeath.lua")
include("sv_fretta_init.lua")

CrateRatio = 0.7
ItemRatio = 0.6

concommand.Add("setitem",function(pl, _, args)
	if not ItemTypes[args[1]] then return end
	
	local x, y = GAMEMODE:PositionToCell(pl:GetPos())
	
	local vec, max, dx, dy
	vec = pl:GetForward()
	max = math.max(math.abs(vec.x), math.abs(vec.y))
	dx, dy = math.Round(vec.x / max), math.Round(vec.y / max)
	
	x, y = x + dx, y + dy
	if ValidEntity(GAMEMODE.CrateMap[x][y]) and GAMEMODE.CrateMap[x][y]:GetClass()=="prop_dynamic" then
		GAMEMODE.CrateMap[x][y]:SetColor(20,60,255,255)
		GAMEMODE.CrateMap[x][y].Item = args[1]
	end
end)

concommand.Add("toggleviewmode",function(pl)
	pl:SetNWBool("FPSMode",not pl:GetNWBool("FPSMode"))
end)

concommand.Add("skull", function(pl)
	local e = ents.Create("bm_skull")
	e.Owner = pl
	e:Spawn()
end)

concommand.Add("test_effect", function(pl, cmd, args)
	local data = EffectData()
		data:SetEntity(pl)
	util.Effect("effect_skull_smoke_player", data, true, true)
end)

concommand.Add("start_modeledit", function(pl)
	local a = ents.FindByClass("bm_prop_bomb")[1]
	if a then
		a.NextExplode = -1
		_G.BOMB = a
		BroadcastLua('_G.BOMB = ents.GetByIndex('..a:EntIndex()..')')
	end
end)

concommand.Add("update_modeledit", function(pl)
	BroadcastLua('RunString(file.Read("model.txt")) _G.BOMB:SetMultiModel("bombtest")')
end)

function GM:SelectRandomItem()
	if not _G.ItemTable then
		local t = {}
		local sum = 0
		for k,v in pairs(ItemTypes) do
			sum = sum + v[1]
			table.insert(t, {sum, k})
		end
		
		t.max = sum
		_G.ItemTable = t
	end
	
	local r = math.Rand(0, _G.ItemTable.max)
	for _,v in ipairs(_G.ItemTable) do
		if r<=v[1] then return v[2] end
	end
end

function GM:Initialize()
	timer.Simple(5, self.StartRoundBasedGame, self)
end

function GM:InitPostEntity()
	local min, max
	local spawnpoints = ents.FindByClass("info_player_start")
	
	for _,v in pairs(spawnpoints) do
		local pos = v:GetPos()
		if not min then
			min = Vector(pos.x,pos.y,pos.z)
		else
			if pos.x<min.x then min.x = pos.x end
			if pos.y<min.y then min.y = pos.y end
			if pos.z<min.z then min.z = pos.z end
		end
		
		if not max then
			max = Vector(pos.x,pos.y,pos.z)
		else
			if pos.x>max.x then max.x = pos.x end
			if pos.y>max.y then max.y = pos.y end
			if pos.z>max.z then max.z = pos.z end
		end
	end
	
	self.Map = {min = min, max = max, W = math.floor((max.x - min.x)/CELLSIZE)+1,H = math.floor((max.y - min.y)/CELLSIZE)+1,Z = max.z}
	self.NumCells = self.Map.W * self.Map.H
	
	for x=1,self.Map.W do
		self.Map[x] = {}
		for y=1,self.Map.H do
			local pos = self:CellToPosition(x, y, 0)
			if util.PointContents(pos) == CONTENTS_SOLID then
				self.Map[x][y] = 1
			else
				local tr = util.TraceLine{
					start = pos + Vector(0,0,-1),
					endpos = pos + Vector(0, 0, 10),
					mask = CONTENTS_SOLID+CONTENTS_OPAQUE
				}
				if tr.Hit then
					self.Map[x][y] = 0
				else
					self.Map[x][y] = 2
				end
			end
		end
	end
	
	
	for _,v in pairs(ents.FindByClass("info_target")) do
		if v:GetName()=="__NOSPAWN" then
			table.insert(spawnpoints, v)
		end
	end
	for _,v in pairs(spawnpoints) do
		local x, y = self:PositionToCell(v:GetPos())
		if self:ValidCell(x  , y  ) and self.Map[x  ][y  ] ==0 then self.Map[x  ][y  ] = 2 end
		if self:ValidCell(x+1, y  ) and self.Map[x+1][y  ] ==0 then self.Map[x+1][y  ] = 2 end
		if self:ValidCell(x-1, y  ) and self.Map[x-1][y  ] ==0 then self.Map[x-1][y  ] = 2 end
		if self:ValidCell(x  , y+1) and self.Map[x  ][y+1] ==0 then self.Map[x  ][y+1] = 2 end
		if self:ValidCell(x  , y-1) and self.Map[x  ][y-1] ==0 then self.Map[x  ][y-1] = 2 end
	end
	
	
	local str = ""
	for y=1,self.Map.H do
		for x=1,self.Map.W do
			str = str..self.Map[x][y].." "
		end
		str = str.."\n"
	end
	print(str)
	
end

function GM:ResetMap()
	for _,v in pairs(ents.GetAll()) do
		local c = v:GetClass()
		if c=="bm_prop_bomb" or c=="bm_prop_item" or c=="bm_skull" or c=="npc_zombie" then v:Remove() end
	end
	
	if self.CrateMap then
		for x=1,self.Map.W do
			for y=1,self.Map.H do
				if ValidEntity(self.CrateMap[x][y]) then
					self.CrateMap[x][y]:Remove()
				end
			end
		end
	end
	
	local coords = {}
	self.CrateMap = {}
	for x=1,self.Map.W do
		self.CrateMap[x] = {}
		for y=1,self.Map.H do
			if self.Map[x][y]==0 then
				table.insert(coords, {x,y})
			end
		end
	end
	
	local removed = math.ceil((1-CrateRatio)*#coords)
	for i=1,removed do
		table.remove(coords, math.random(1,#coords))
	end
	
	local item = math.ceil(ItemRatio*#coords)
	for i=1,item do
		coords[math.random(1,#coords)][3] = self:SelectRandomItem()
	end
	
	local bmin, bmax = Vector(-CELLSIZE/2,-CELLSIZE/2,-CELLSIZE/2), Vector(CELLSIZE/2,CELLSIZE/2,CELLSIZE/2)
	for _,v in pairs(coords) do
		local x, y = v[1], v[2]
		local e = ents.Create("prop_dynamic")
		e:SetModel("models/props_junk/wood_crate001a.mdl")
		e:SetSolid(SOLID_VPHYSICS)
		e:PhysicsInitBox(bmin, bmax)
		e:SetPos(self:CellToPosition(x, y, 24))
		e:SetColor(255,100,100,255)
		e:Spawn()
		e:DropToFloor()
		e.Cell = {x, y}
		e.Item = v[3]
		self.CrateMap[x][y] = e
	end
end

function GM:PropBreak(att, ent)
	if ent.Item then
		local e = ents.Create("bm_prop_item")
		e:SetPos(ent:GetPos())
		e:SetAngles(ent:GetAngles())
		e.ItemType = ent.Item
		e:Spawn()
	end
end


function GM:PlayerDeathSound()
	return true
end

function GM:OnDamagedByExplosion()
end
