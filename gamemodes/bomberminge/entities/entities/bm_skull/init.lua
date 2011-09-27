
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

NUMSKULLSTATES = 5
--[[
1 : Super slow speed
2 : Can't drop bombs
3 : Force drop bombs
4 : Reverse commands
5 : Super fast speed
]]

function ENT:Initialize()
	if not ValidEntity(self.Owner) or self.Owner:GetNWInt("SkullState")>0 then
		self:Remove()
		return
	end
	
	self:SetPos(self.Owner:GetPos())
	self:SetAngles(self.Owner:GetAngles())
	self:SetModel(self.Owner:GetModel())
	
	local min, max = Vector(-10, -10, -10), Vector(10, 10, 70)
	
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self:SetTrigger(true)
	
	self:SetParent(self.Owner)
	self:SetOwner(self.Owner)
	
	if not self.NextDie then
		self.NextDie = CurTime() + 30
	end
	
	self.State = math.random(1,NUMSKULLSTATES)
	self.Owner:SetNWInt("SkullState", self.State)
	self.Owner.Skull = self
	
	local data = EffectData()
		data:SetEntity(self.Owner)
	util.Effect("effect_skull_smoke_player", data, true, true)
end

function ENT:Think()
	if self.NextDie and CurTime()>self.NextDie then
		self:Remove()
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() and ent~=self:GetParent() then
		if self.NextEndCoolDown and CurTime()<self.NextEndCoolDown then return end
		if ent:GetNWInt("SkullState")>0 then return end -- Don't transmit if the other player is also infected
		
		-- Transmit the infection!
		local e = ents.Create("bm_skull")
			e.Owner = ent
			e.NextEndCoolDown = CurTime() + 2
			e.NextDie = self.NextDie + 2
		e:Spawn()
		
		self:Remove()
	end
end

function ENT:OnRemove()
	self.Owner:SetNWInt("SkullState", 0)
end

hook.Add("DoPlayerDeath", "PlayerDeathRemoveSkull", function(pl)
	if ValidEntity(pl.Skull) then
		pl.Skull:Remove()
	end
end)