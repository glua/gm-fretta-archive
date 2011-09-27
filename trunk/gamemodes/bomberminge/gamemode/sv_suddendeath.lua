
function GM:StartSuddenDeath()
	self.CurrentSuddenPos = nil
	self.SuddenStart = CurTime()
	self.SuddenNum = 0
	self.RiseCrates = {}
	self.SinkCrates = {}
	self.SuddenDeath = true
end

function GM:SuddenDeathThink()
	for k,_ in pairs(self.RiseCrates or {}) do
		if ValidEntity(k) then
			local pos = k:GetPos() + Vector(0,0,2)
			if pos.z>self.Map.Z+24 then
				pos.z = self.Map.Z+24
				self.RiseCrates.k = nil
			end
			k:SetPos(pos)
		else
			self.RiseCrates.k = nil
		end
	end
	
	for k,_ in pairs(self.SinkCrates or {}) do
		if ValidEntity(k) then
			local pos = k:GetPos() - Vector(0,0,2)
			if pos.z<self.Map.Z-24 then
				self.SinkCrates.k = nil
				k:Remove()
			end
			k:SetPos(pos)
		else
			self.SinkCrates.k = nil
		end
	end
	
	if self.SuddenDeath then
		if not self.CurrentSuddenPos then
			self.CurrentSuddenPos = {1, self.Map.H}
			self.SuddenNum = 1
		end
		
		if not self.NextSuddenSpawn or CurTime()>self.NextSuddenSpawn then
			local x, y = self.CurrentSuddenPos[1], self.CurrentSuddenPos[2]
			if x>1 and ValidEntity(self.CrateMap[x-1][y]) then
				self.SinkCrates[self.CrateMap[x-1][y]] = true
				self.CrateMap[x-1][y]:SetSolid(SOLID_NONE)
			end
			
			if self.Map[x][y]~=1 then
				local e = ents.Create("prop_dynamic")
				e:SetModel("models/props_junk/wood_crate001a.mdl")
				e:SetSolid(SOLID_VPHYSICS)
				e:SetPos(self:CellToPosition(x, y, -24))
				e:SetColor(120,40,40,255)
				e:Spawn()
				
				if ValidEntity(self.CrateMap[x][y]) then
					self.CrateMap[x][y].Item = nil
					self.CrateMap[x][y]:Fire("Break")
				end
				for _,v in pairs(self:CellContents(x,y)) do
					if v.Explode then
						v:Explode(true)
					else
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker(v)
						dmginfo:SetInflictor(v)
						dmginfo:SetDamage(1000)
						dmginfo:SetDamageType(DMG_GENERIC)
						dmginfo:SetDamagePosition(v:GetPos())
						v:TakeDamageInfo(dmginfo)
					end
				end
				
				e.Unbreakable = true
				e:SetHealth(9999)
				self.CrateMap[x][y] = e
				self.RiseCrates[e] = true
			end
			
			self.SuddenNum = self.SuddenNum + 1
			self.CurrentSuddenPos[2] = self.CurrentSuddenPos[2] - 1
			if self.CurrentSuddenPos[2]<1 then
				self.CurrentSuddenPos[2] = self.Map.H
				self.CurrentSuddenPos[1] = self.CurrentSuddenPos[1] + 1
				if self.CurrentSuddenPos[1]>self.Map.W then
					self.SuddenDeath = false
				end
			end
			
			self.NextSuddenSpawn = self.SuddenStart + 60 * self.SuddenNum / self.NumCells
		end
	end
end

hook.Add("Think", "SuddenDeathThink", function()
	GAMEMODE:SuddenDeathThink()
end)
