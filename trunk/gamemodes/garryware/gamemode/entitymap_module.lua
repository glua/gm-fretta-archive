////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Entity Mapping to Grid Module              //
////////////////////////////////////////////////

module( "entity_map", package.seeall )

local DefaultTolerancy = 10
local ENTMAP = {}

-- Insert an empty row
function ENTMAP:InsertRow(y)
	local t = {[-1]=0, [0]=0}
	for i=1,self.W do t[i]=NULL end
	
	table.insert(self, y, t)
	self.H = self.H + 1
	
	-- Update the position of every prop in the grid
	for i=y+1,self.H do
		for j=1,self.W do
			local p = self:Get(j,i)
			if p:IsValid() and self[p] then
				self[p].y = self[p].y + 1
			end
		end
	end
end

-- Insert an empty column
function ENTMAP:InsertColumn(x)
	table.insert(self[-1], x, 0)
	table.insert(self[0], x, 0)
	for i=1,self.H do
		table.insert(self[i], x, NULL)
	end
	self.W = self.W + 1
	
	-- Update the position of every prop in the grid
	for i=x+1,self.W do
		for j=1,self.H do
			local p = self:Get(i,j)
			if p:IsValid() and self[p] then
				self[p].x = self[p].x + 1
			end
		end
	end
end

-- Add a prop (will recalculate the average X and Y for the matching row and column as well)
function ENTMAP:AddItem(x, y, prop)
	local pos = prop:GetPos()
	
	self[0][x] = (self[-1][x] * self[0][x] + pos.x) / (self[-1][x] + 1)
	self[-1][x] = self[-1][x] + 1
	
	self[y][0] = (self[y][-1] * self[y][0] + pos.y) / (self[y][-1] + 1)
	self[y][-1] = self[y][-1] + 1
	
	self[y][x] = prop
	self[prop] = {x=x,y=y}
end

-- Replace an existing prop in the grid (will not recalculate averages)
function ENTMAP:SetItem(x, y, prop)
	local old = self[y][x]
	self[y][x] = prop
	
	if old:IsValid() and prop:IsValid() then
		self[old] = nil
		self[prop] = {x=x,y=y}
	end
end

-- Remove an item from the grid
function ENTMAP:RemoveItem(x, y)
	self:SetItem(x, y, NULL)
end

-- Get a prop at the given coordinates (returns a null entity if coordinates are out of bounds)
function ENTMAP:Get(x, y)
	if x<1 or y<1 or x>self.W or y>self.H then return NULL end
	return self[y][x] or NULL
end

-- Return the position of the prop in this grid {x=x,y=y}
function ENTMAP:GetPositionInGrid(prop)
	return self[prop]
end

-- Inserting props into the grid with this function will map them so you can know which prop is under which one in the grid, etc...
function ENTMAP:Insert(prop)
	local pos = prop:GetPos()
	local x, y = pos.x, pos.y
	local a, b = 1, 1
	
	-- Finding/inserting row
	
	if self.H==0 then
		self:InsertRow(1)
	else
		for j=1,self.H do
			local cy = self[j][0]
			if y<cy+self.Tolerancy and y>cy-self.Tolerancy then
				b = j
				break
			elseif y<cy-self.Tolerancy then
				b = j
				self:InsertRow(j)
				break
			elseif y>cy+self.Tolerancy and not self[j+1] then
				b = j+1
				self:InsertRow(j+1)
			end
		end
	end
	
	-- Finding/inserting column
	
	if self.W==0 then
		self:InsertColumn(1)
	else
		for i=1,self.W do
			local cx = self[0][i]
			if x<cx+self.Tolerancy and x>cx-self.Tolerancy then
				a = i
				break
			elseif x<cx-self.Tolerancy then
				a = i
				self:InsertColumn(i)
				break
			elseif x>cx+self.Tolerancy and not self[b][i+1] then
				a = i+1
				self:InsertColumn(i+1)
			end
		end
	end
	
	self:AddItem(a, b, prop)
end

-- Accessors
function ENTMAP:Width() return self.W end
function ENTMAP:Height() return self.H end
function ENTMAP:GetTolerancy() return self.Tolerancy end
function ENTMAP:SetTolerancy(t) self.Tolerancy = t end

-- Debugging
local function ent_map_tostring(self)
	local str = "Entity map: "..self.W.." x "..self.H.."\n"
	for j=1,self.H do
		for i=1,self.W do
			if self:Get(i,j):IsValid() then
				str = str.."1 "
			else
				str = str.."0 "
			end
		end
		str = str.."\n"
	end
	
	return str
end

local ent_map_meta = {__index=ENTMAP, __tostring=ent_map_tostring}

function Create()
	local grid = {[-1]={}, [0]={}, W=0,H=0,Tolerancy=DefaultTolerancy}
	setmetatable(grid, ent_map_meta)
	
	return grid
end
