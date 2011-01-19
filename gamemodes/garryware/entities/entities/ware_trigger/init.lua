
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetNotSolid(true)
	self.Enabled = true
end

function ENT:Enable() self.Enabled = true end
function ENT:Disable() self.Enabled = false end

function ENT:Setup(mins, maxs, callback, filter, iswhitelist)
	self:SetNetworkedVector("mins", mins)
	self:SetNetworkedVector("maxs", maxs)
	self.mins = mins
	self.maxs = maxs
	
	self.vmax = math.max(maxs:Length(), mins:Length())
	self.vmax = Vector(self.vmax,self.vmax,self.vmax)
	
	self:SetNetworkedVector("vmax", self.vmax)
	
	self.TouchCallback = callback
	
	self.IsWhiteList = iswhitelist
	self.Filter = {}
	for _,v in pairs(filter or {}) do
		self.Filter[v] = 1
	end
end

function ENT:IsInBox(pos)
	local diff = pos - self:GetPos()
	
	local proj_length = diff:DotProduct(self.F)
	local proj_width  = diff:DotProduct(self.R)
	local proj_height = diff:DotProduct(self.U)
	
	return proj_length>=self.mins.x and proj_length<=self.maxs.x and
		   proj_width >=self.mins.y and proj_width <=self.maxs.y and
		   proj_height>=self.mins.z and proj_height<=self.maxs.z
end

function ENT:Think(ent)
	if not self.Enabled then return end
	if not self.TouchCallback then return end
	local pos = self:GetPos()
	
	self.F = self:GetForward()
	self.R = self:GetRight()
	self.U = self:GetUp()
	
	for _,v in pairs(ents.FindInBox(pos-self.vmax, pos+self.vmax)) do
		local cond = not self.Filter[v] and not self.Filter[v:GetClass()] and not self.Filter[v:GetModel()]
		if self.IsWhiteList then
			cond = not cond
		end
		if cond and v~=self and v~=self:GetParent() then
			if self:IsInBox(v:GetPos()) then
				self:TouchCallback(v)
			end
		end
	end
	
	self:NextThink(CurTime()+0.2)
	return true
end
