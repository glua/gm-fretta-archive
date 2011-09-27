include("shared.lua")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

local Directions = {
{0,1},
{1,0},
{0,-1},
{-1,0}
}


-- Single time bombs are bombs that can have only one instance on the map
-- this means you will drop regular bombs as long as your special bomb hasn't exploded yet
local SingleTimeBombs = {
[4]=true,
[5]=true,
[6]=true,
[7]=true,
}

-- A quick way to turn cell coordinates into a string (this works only with integers between 1 and 255, but that should be far enough, right?)
local function cellToString(x,y)
	return string.char(x)..string.char(y)
end

local function stringToCell(s)
	return string.byte(s,1), string.byte(s,2)
end

function ENT:Initialize()
	self:SetModel("models/props_junk/PropaneCanister001a.mdl")
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	
	if SingleTimeBombs[self.BombType] then
		if not self.Owner.SingleTimeBombs then
			self.Owner.SingleTimeBombs = {}
		end
		
		local b = self.Owner.SingleTimeBombs[self.BombType]
		if ValidEntity(b) and not b.Exploded then
			self.BombType = 0
		else
			self.Owner.SingleTimeBombs[self.BombType] = self
		end
	end
	
	self:SetNWEntity("BombOwner", self.Owner)
	
	self.Power = self.Power or 1
	
	if self.BombType == 9 then
		self:SetMultiModel("bomb_physics")
		self:SetModel("models/props_c17/oildrum001_explosive.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysWake()
		self.NextExplode = CurTime() + 3
		self.ExplosionSound = "BaseExplosionEffect.Sound"
	elseif self.BombType == 7 then
		self:SetMultiModel("bomb_danger")
		self.NextExplode = CurTime() + 3
		self.ExplosionSound = "explode_1"
		if self.Power<4 then
			self.Power = 1
			self.Falloff = 1
		elseif self.Power<8 then
			self.Power = 2
			self.Falloff = 1
		else
			self.Power = 2
			self.Falloff = 0
		end
	elseif self.BombType == 6 then
		self:SetMultiModel("bomb_invis")
		self.NextExplode = CurTime() + 3
		self.NextAppear = CurTime() + 2
		self.ExplosionSound = "BaseExplosionEffect.Sound"
	elseif self.BombType == 5 then
		self:SetMultiModel("bomb_mine")
		self.NextExplode = -1
		self.NextReady = CurTime() + 1.5
		self:SetNotSolid(true)
		self:SetTrigger(true)
		self.ExplosionSound = "BaseExplosionEffect.Sound"
		self.NoCollisionDetector = true
		self.NotSolid = true
	elseif self.BombType == 4 then
		self:SetMultiModel("bomb_rocket")
		self.NextExplode = CurTime() + 3
		self.ExplosionSound = "BaseExplosionEffect.Sound"
		self.RefPower = self.Power
		self.Power = 1
	elseif self.BombType == 3 then
		self:SetMultiModel("bomb_random")
		self.NextExplode = CurTime() + 3
		self:SetNWInt("ScreenCounter", 3)
		self:SetNWBool("Scrambled", false)
		self:AddRemoteBomb()
		self.ExplosionSound = "BaseExplosionEffect.Sound"
	elseif self.BombType == 2 then
		self:SetMultiModel("bomb_plasma")
		self.IsPlasma = true
		self.NextExplode = CurTime() + 3
		self.ExplosionSound = "Weapon_Mortar.Impact"
		self.ExplosionColor = 2
	elseif self.BombType == 1 then
		self:SetMultiModel("bomb_remote")
		self.NextExplode = -1
		self:AddRemoteBomb()
		self.ExplosionSound = "BaseExplosionEffect.Sound"
	
	-- Reserved bombs go here
	elseif self.BombType == -1 then
		self:SetMultiModel("bomb_rocket_sub")
		self.NextExplode = -1
		self.ExplosionSound = "PropaneTank.Burst"
		self.Unlinked = true
		self.Directional = true
		self.NoCollisionDetector = true
		self.ExplosionColor = 3
	-- Default bomb
	else
		self:SetMultiModel("bomb")
		self.NextExplode = CurTime() + 3
		self.ExplosionSound = "BaseExplosionEffect.Sound"
	end
	
	if not self.NoCollisionDetector then
		-- This entity disables collisions for players who were already colliding with the bomb at the moment it was created
		-- and then enables it again when they stop colliding with it
		-- This makes sure nobody gets stuck inside a bomb, while still allowing players to get trapped by their own bomb
		local e = ents.Create("bm_collision_detector")
		e:SetPos(self:GetPos())
		e:SetAngles(self:GetAngles())
		e:SetParent(self)
		e:Spawn()
		self.Detector = e
	end
	
	-- Disable collision and then enable it when the entity start thinking
	-- This prevents the player from getting stuck for a short instant when dropping a bomb (see bm_collision_detector)
	self:SetNotSolid(true)
end

function ENT:AddRemoteBomb()
	if ValidEntity(self.Owner) then
		local pl = self.Owner
		if not pl.RemoteBombs then pl.RemoteBombs = {} end
		table.insert(pl.RemoteBombs, self)
	end
end

function ENT:OnRemoteTrigger(owner)
	if self.BombType==1 then
		self.NextExplode = 0
		return true
	elseif self.BombType==3 then
		self:SetNWBool("Scrambled", true)
		self.Randomized = true
		
		local r = math.random(0,100)
		local t
		if r<15 then -- Super short delay
			t = math.Rand(0,1.5)
		elseif r<40 then -- Super long delay
			t =  math.Rand(10,30)
		else -- Moderate delay
			t = math.Rand(2,6)
		end
		self:SetNWInt("ScreenCounter", math.ceil(t))
		self.NextExplode = CurTime() + t
	end
end

function ENT:Touch(ent)
	if self.NextReady and CurTime()>self.NextReady and (ent:IsPlayer() and ent:Alive()) or (ent:IsNPC() and ent:Health()>0) then
		self.Touch = nil
		self:Explode()
	end
end

function ENT:Think()
	local result
	if self.BombType==3 and (not self.NextScreenUpdate or CurTime()>self.NextScreenUpdate) then
		local d = math.ceil(self.NextExplode - CurTime())
		if d>=0 and d<self:GetNWInt("ScreenCounter") then
			self:SetNWInt("ScreenCounter", d)
		end
		self.NextScreenUpdate = CurTime()+0.1
	end
	
	if self.BombType==6 and self.NextAppear and CurTime()>self.NextAppear then
		self:RestartAnimation(1)
		self.NextAppear = nil
	end
	
	result = self:ExplosionThink()
	if result~=nil then return result end
	
	if self.NextExplode and self.NextExplode>=0 and CurTime()>self.NextExplode then
		self:Explode()
	end
	
	if self.Grabber then
		local TargetGrabPos = self.Grabber.Owner:GetPos() + 30 * self.Grabber.Owner:GetForward() + 80 * self.Grabber.Owner:GetUp()
		self.CurrentGrabPos = LerpVector(0.2, self.CurrentGrabPos, TargetGrabPos)
		self:SetPos(self.CurrentGrabPos)
		self:NextThink(CurTime())
		return true
	elseif self.Bounce then
		self.Bounce = nil
		self:Punch(self.PunchDirection.x, self.PunchDirection.y, self.PunchDistance)
		self:NextThink(CurTime())
		return true
	elseif self.Kicked then
		local pos = self:GetPos()
		local dist = self.KickDirection.x * (self.KickNextCellPos.x - pos.x) + self.KickDirection.y * (self.KickNextCellPos.y - pos.y)
		if dist<10 then
			self:SetCell(self.KickNextCell[1],self.KickNextCell[2],true)
			--MsgN(Format("Reached node %d,%d", self.Cell[1], self.Cell[2]))
			if not self:Kick(self.KickDirection.x, self.KickDirection.y) then
				self:StopKick()
				self:OnMovementBlocked()
				--MsgN(Format("Blocked at %d,%d", self.Cell[1], self.Cell[2]))
			end
		end
		self:NextThink(CurTime())
		return true
	elseif self.Punched then
		local pos = self:GetPos()
		local dist = self.PunchDirection.x * (self.PunchNextCellPos.x - pos.x) + self.PunchDirection.y * (self.PunchNextCellPos.y - pos.y)
		if dist<10 then
			if not GAMEMODE:ValidCell(self.PunchNextCell[1],self.PunchNextCell[2]) then
				self:Explode(nil, true) -- Remove the bomb
			elseif not GAMEMODE:IsFreeCell(self.PunchNextCell[1],self.PunchNextCell[2], true, {[self]=true}) then
				self:SetCell(self.PunchNextCell[1],self.PunchNextCell[2],true,true)
				self:StopPunch(true) -- Can't land there, bounce off
				self.Bounce = true
			else
				self:SetCell(self.PunchNextCell[1],self.PunchNextCell[2],true)
				self:StopPunch() -- It's a valid position, leave it there
				self:OnMovementBlocked()
			end
		end
		self:NextThink(CurTime())
		return true
	elseif not self.NotSolid then
		-- Restore collisions
		self:SetNotSolid(false)
	end
	
	if self.NextStopHoldEffect and CurTime()>self.NextStopHoldEffect then
		self:StopHoldEffect()
	end
end

function ENT:CanExplode()
	return not(self.Exploded or self.Grabber or self.Kicked or self.Punched or self.Bounce)
end

function ENT:SetCell(x, y, dontsnap, dontstore)
	if self.Cell and GAMEMODE.CrateMap[self.Cell[1]][self.Cell[2]] == self then
		GAMEMODE.CrateMap[self.Cell[1]][self.Cell[2]] = nil
	end
	if x and y then
		self.Cell = {x, y}
		if not dontsnap then
			self:SetPos(GAMEMODE:CellToPosition(x, y, 24))
		end
		if not dontstore then
			GAMEMODE.CrateMap[x][y] = self
		end
	end
end

function ENT:StartHoldEffect(gravtype, time)
	self.NextStopHoldEffect = time
	self:SetNWInt("GravHoldType", gravtype)
end

function ENT:StopHoldEffect()
	self.NextStopHoldEffect = nil
	self:SetNWInt("GravHoldType", 0)
end

----------------------------------------------------------------------

local function signum(x)
	if x>0 then return 1
	elseif x<0 then return -1
	else return 0
	end
end

KICKFORCE=240

-- Sends the bomb gliding in a given direction
function ENT:Kick(x, y)
	if self.Punched or self.Bounce then return end
	x, y = signum(x), signum(y)
	if math.abs(x)==math.abs(y) then
		ErrorNoHalt(Format("ERROR: Invalid kick direction [%d,%d] for %s\n", x, y, tostring(self)))
		return false
	end
	
	--MsgN(Format("Kicking from %d,%d", self.Cell[1], self.Cell[2]))
	local a, b = self.Cell[1]+x, self.Cell[2]+y
	if not GAMEMODE:IsFreeCell(a, b, true, {[self]=true}) then
		return false
	end
	
	self.Kicked = true
	self.KickDirection = Vector(x, y, 0)
	if self.Directional then self:SetAngles(self.KickDirection:Angle()) end
	
	self:SetMoveType(MOVETYPE_FLY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetLocalVelocity(Vector(x*KICKFORCE, y*KICKFORCE, 0))
	
	self.KickNextCell = {a, b}
	self.KickNextCellPos = GAMEMODE:CellToPosition(a,b,0)
	
	self:SetNotSolid(true)
	
	return true
end

function ENT:StopKick()
	self:SetNotSolid(false)
	self.Kicked = false
	
	-- Snap to nearest cell
	self:SetCell(self.Cell[1], self.Cell[2])
	self:SetMoveType(MOVETYPE_NONE)
	self:SetMoveCollide(MOVECOLLIDE_DEFAULT)
end

PUNCHFORCE=360
PUNCHGRAVITY=4
PUNCHANGLE=60
-- Throw the bomb up a given number of cells
function ENT:Punch(x, y, n, mul)
	if self.Kicked or self.Bounce then return end
	x, y = signum(x), signum(y)
	if math.abs(x)==math.abs(y) then
		ErrorNoHalt(Format("ERROR: Invalid punch direction [%d,%d] for %s\n", x, y, tostring(self)))
		return false
	end
	
	local a, b = self.Cell[1]+x*n, self.Cell[2]+y*n
	self.Punched = true
	self.PunchDirection = Vector(x, y, 0)
	self.PunchDistance = n
	if self.Directional then self:SetAngles(self.PunchDirection:Angle()) end
	local dir = Vector(x, y, 0):Angle()
	dir.p = -PUNCHANGLE
	dir = dir:Forward() * PUNCHFORCE * math.sqrt(n) * (mul or 1)
	
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetLocalVelocity(Vector(0,0,0))
	self:SetVelocity(dir)
	self:SetGravity(PUNCHGRAVITY)
	
	self.PunchNextCell = {a, b}
	self.PunchNextCellPos = GAMEMODE:CellToPosition(a,b,0)
	
	self:SetNotSolid(true)
	if self.NextExplode==-1 then self.OldDelay = -1
	else self.OldDelay = self.NextExplode - CurTime() end
	self.NextExplode = -1
	
	return true
end

function ENT:StopPunch(dontstore)
	self:SetNotSolid(false)
	self.Punched = false
	
	-- Snap to nearest cell
	self:SetCell(self.Cell[1], self.Cell[2], nil, dontstore)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetMoveCollide(MOVECOLLIDE_DEFAULT)
	
	if self.OldDelay==-1 then self.NextExplode=-1
	else self.NextExplode = CurTime() + self.OldDelay end
end

THROWMULTIPLIER=0.68
function ENT:Grab(wep)
	self.Grabber = wep
	self.CurrentGrabPos = self:GetPos()
	wep.Owner.GrabbedBomb = self
	self:SetCell()
	self:SetNotSolid(true)
	
	if self.NextExplode==-1 then self.OldDelay = -1
	else self.OldDelay = self.NextExplode - CurTime() end
	self.NextExplode = -1
	
	self:StartHoldEffect(2)
	
	return true
end

function ENT:Throw(drop)
	local x, y = GAMEMODE:PositionToCell(self.Grabber.Owner:GetPos())
	
	local vec, max, dx, dy
	local TargetGrabPos
	if not drop then
		TargetGrabPos = self.Grabber.Owner:GetPos() + 30 * self.Grabber.Owner:GetForward() + 80 * self.Grabber.Owner:GetUp()
		vec = self.Grabber.Owner:GetForward()
		max = math.max(math.abs(vec.x), math.abs(vec.y))
		dx, dy = math.Round(vec.x / max), math.Round(vec.y / max)
	end
	
	self.Grabber.Owner.GrabbedBomb = nil
	self.Grabber = nil
	self:SetParent()
	
	if drop then
		self:SetCell(x, y)
		if self.OldDelay==-1 then self.NextExplode=-1
		else self.NextExplode = CurTime() + self.OldDelay end
		self:SetNotSolid(false)
		self:StopHoldEffect()
	else
		self:SetCell(x, y, true, true)
		self:SetPos(TargetGrabPos)
		
		if self.OldDelay==-1 then self.NextExplode=-1
		else self.NextExplode = CurTime() + self.OldDelay end
		self:SetNotSolid(false)
		self:Punch(dx, dy, 2, THROWMULTIPLIER)
		self:StartHoldEffect(2, 2)
	end
end


function ENT:OnMovementBlocked()
	if self.BombType==-1 then
		self:Explode()
	end
end

----------------------------------------------------------------------

function ENT:DoExplosionEffectEx(x, y, directions, dist)
	local pos = GAMEMODE:CellToPosition(x, y)
	
	for k,v in ipairs(directions) do
		if dist[k]>0 then
			local data = EffectData()
				data:SetOrigin(pos)
				data:SetStart(Vector(dist[k] * CELLSIZE * v[1], dist[k] * CELLSIZE * v[2],0))
				data:SetAttachment(self.ExplosionColor or 1)
			util.Effect("effect_explosion_directional", data, true, true)
		end
	end
	
	local data = EffectData()
		data:SetOrigin(pos)
		data:SetAttachment(self.ExplosionColor or 1)
	util.Effect("effect_explosion_core", data, true, true)
end

function ENT:DoExplosionEffect(x, y, dist)
	self:DoExplosionEffectEx(x, y, Directions, dist)
end

function ENT:DoSingleExplosion(x, y, inflictor, hittable)
	for _,v in pairs(ents.GetAll()) do
		if v:IsPlayer() or v:IsNPC() or v:GetClass()=="bm_prop_item" then
			local pX, pY = GAMEMODE:PositionToCell(v:GetPos())
			if pX==x and pY==y then
				hittable[v] = inflictor
			end
		elseif v~=self and v.Explode and v:CanExplode() and (not v.BombFilter or not v.BombFilter[self]) then
			local pX, pY = GAMEMODE:PositionToCell(v:GetPos())
			if pX==x and pY==y then
				v:Explode(self)
			end
		end
	end
	
	if ValidEntity(GAMEMODE.CrateMap[x][y]) then
		hittable[GAMEMODE.CrateMap[x][y]] = inflictor
	end
end

function ENT:RegisterSingleExplosion(x, y, expltable)
	if GAMEMODE:ValidCell(x, y) and GAMEMODE.Map[x][y]~=1 then
		if ValidEntity(GAMEMODE.CrateMap[x][y]) and GAMEMODE.CrateMap[x][y]:GetClass()=="prop_dynamic" then
			if GAMEMODE.CrateMap[x][y].Unbreakable then return -1 end
			expltable[cellToString(x,y)] = {self, 0} -- No persistent explosion on broken crates
			if not self.IsPlasma then
				return 0
			end
		else
			expltable[cellToString(x,y)] = {self, CurTime()+0.5}
		end
		
		return 1
	else
		return -1
	end
end

function ENT:Explode(master, dummy)
	if self.BombType==5 then
		if not self.Triggered then
			self.Triggered = true
			self.NextExplode = CurTime()+1.5
			self:RestartAnimation(1)
			return
		elseif CurTime()<self.NextExplode then
			return
		end
	end
	
	if self.Exploded then return end
	
	self:StopHoldEffect()
	
	if self.Owner.NumBombs and not self.Unlinked then
		self.Owner.NumBombs = self.Owner.NumBombs - 1
	end
	
	if dummy then
		self:Remove()
		return
	end
	
	local isMainExplosion = false
	
	self.Exploded = true
	
	local expltable
	if ValidEntity(master) and master.ExplosionTable then
		expltable = master.ExplosionTable
	else
		isMainExplosion = true
		expltable = {}
	end
	
	local x, y = self.Cell[1], self.Cell[2]
	local distances = {0, 0, 0, 0}
	
	self:EmitSound(self.ExplosionSound)
	self:RegisterSingleExplosion(x, y, expltable)
	
	for k,v in ipairs(Directions) do
		for d=1,self.Power do
			local px, py = x+d*v[1], y+d*v[2]
			local r = self:RegisterSingleExplosion(px, py, expltable)
			if r>=0 then
				distances[k] = distances[k] + 1
			end
			
			if r<1 then break end
		end
	end
	
	self:DoExplosionEffect(x, y, distances)
	
	if self.BombType==7 then
		for k,v in ipairs(Directions) do
			local p = self.Power
			local Directions2 = {{v[2], v[1]},{-v[2], -v[1]}}
			for d=1,self.Power do
				local distances2 = {0, 0}
				local x2, y2 = x+d*v[1], y+d*v[2]
				for l,w in ipairs(Directions2) do
					for d2=1,p do
						local px, py = x2+d2*w[1], y2+d2*w[2]
						local r = self:RegisterSingleExplosion(px, py, expltable)
						if r>=0 then
							distances2[l] = distances2[l] + 1
						end
				
						if r<1 then break end
					end
				end
				self:DoExplosionEffectEx(x2, y2, Directions2, distances2)
				p = p - self.Falloff
			end
		end
	end
	
	---------------------------
	if self.BombType==4 then
		local t = {}
		local e
		for k,v in ipairs(Directions) do
			if GAMEMODE:IsFreeCell(x+v[1], y+v[2], true) then
				e = ents.Create("bm_prop_bomb")
				e:SetCell(x, y)
				e.Owner = self.Owner
				e.Power = math.ceil(self.RefPower/3)
				e.BombType = -1
				e.BombFilter = {[self]=true}
				e:Spawn()
				e.dir = v
				t[k] = e
			end
		end
		for k,v in pairs(t) do
			for _,w in pairs(t) do
				v.BombFilter[w] = true
			end
			v:Kick(v.dir[1],v.dir[2])
		end
	end
	---------------------------
	
	self:SetNoDraw(true)
	self:SetNotSolid(true)

	if isMainExplosion then
		self.NextExplosionDie = CurTime() + 0.4
		self.ExplosionTable = expltable
		self.Children = {}
		self:Think()
	else
		if ValidEntity(master) then
			master.Children[self] = true
		end
		self.Think = nil
	end
	
	if GAMEMODE.CrateMap[x][y] == self then 
		GAMEMODE.CrateMap[x][y] = nil
	end
end

function ENT:ExplosionThink()
	if self.ExplosionTable then
		local hittable = {}
		local die = true
		for k,v in pairs(self.ExplosionTable) do
			die = false
			local x, y = stringToCell(k)
			self:DoSingleExplosion(x, y, v[1], hittable)
			if CurTime()>v[2] then self.ExplosionTable[k] = nil end
		end
		
		if die then
			-- No more explosions to process, kill every bomb involved
			self.Think = nil
			SafeRemoveEntityDelayed(self, 0.2)
			for k,_ in pairs(self.Children) do
				if ValidEntity(k) then
					SafeRemoveEntityDelayed(k, 0.2)
				end
			end
			return false
		else
			for k,v in pairs(hittable) do
				if ValidEntity(k) then
					if k:Health()>0 and (k:IsPlayer() or k:IsNPC()) then
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker(v.Owner)
						dmginfo:SetInflictor(v)
						dmginfo:SetDamage(1000)
						if v.IsPlasma then
							dmginfo:SetDamageType(DMG_SHOCK|DMG_DISSOLVE)
						else
							dmginfo:SetDamageType(DMG_BLAST)
						end
						dmginfo:SetDamagePosition(self:GetPos())
						k:TakeDamageInfo(dmginfo)
					elseif k:GetClass()=="bm_prop_item" and not k.Exploded then
						k:Explode()
					elseif k:GetClass()=="prop_dynamic" then
						k:TakeDamage(1000)
					end
				end
			end
			self:NextThink(CurTime() + 0.06)
			return true
		end
	end
end

-- Unlink all bombs that belong to dead players, so they can't have any control over them anymore, but yet still get kill credit from them
hook.Add("DoPlayerDeath", "UnlinkDeadPlayerBombs", function(pl)
	for _,v in pairs(ents.FindByClass("bm_prop_bomb")) do
		if v.Owner==pl then
			v.Unlinked = true
		end
	end
end)