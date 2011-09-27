
CELLSIZE = 48

function GM:SnapToNearestCell(pos)
	local pos2 = self:CellToPosition(self:PositionToCell(pos))
	pos2.z = pos.z
	return pos2
end

function GM:PositionToCell(pos)
	local x, y = pos.x - self.Map.min.x + CELLSIZE/2, pos.y - self.Map.min.y + CELLSIZE/2
	return math.floor(x/CELLSIZE)+1, math.floor(y/CELLSIZE)+1
end

function GM:CellToPosition(x, y, zoffset)
	return Vector(self.Map.min.x + CELLSIZE * (x-1), self.Map.min.y + CELLSIZE * (y-1), self.Map.Z + (zoffset or 5))
end

function GM:ValidCell(x, y)
	return x>0 and y>0 and x<=self.Map.W and y<=self.Map.H
end

function GM:IsFreeCell(x, y, m, filter, includeitems)
	if x<=0 or y<=0 or x>self.Map.W or y>self.Map.H then return false end
	if m then
		if self.Map[x][y]==1 then return false end
	else
		if self.Map[x][y]~=0 then return false end
	end
	if ValidEntity(self.CrateMap[x][y]) then return false end
	
	for _,v in pairs(ents.GetAll()) do
		if (not filter or not filter[v]) and (
			(v:IsPlayer() and v:Alive()) or
			(v:IsNPC() and v:Health()>0) or
			(v:GetClass()=="bm_prop_bomb" and not v.Exploded) or
			(includeitems and v:GetClass()=="bm_prop_item" and v.Touch)) then
			local a, b = self:PositionToCell(v:GetPos())
			if a==x and b==y then return false end
		end
	end
	
	return true
end

function GM:CellContents(x, y)
	local hittable = {}
	for _,v in pairs(ents.GetAll()) do
		if self:IsDestructibleEntity(v) then
			local pX, pY = self:PositionToCell(v:GetPos())
			if pX==x and pY==y then
				table.insert(hittable, v)
			end
		end
	end
	return hittable
end

function GM:IsDestructibleEntity(v)
	return
		(v:IsPlayer() and v:Alive()) or
		(v:IsNPC() and v:Health()>0) or
		(v:GetClass()=="bm_prop_item" and v.Touch) or
		(v:GetClass()=="bm_prop_bomb" and not v.Exploded)
end
