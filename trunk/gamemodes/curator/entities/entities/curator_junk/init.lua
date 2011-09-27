
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(true)
		phys:Wake()
	end
end

function ENT:Think()
	if self.Fading then
		if CurTime() <= self.FadeEndTime then
			local frac = 150*(1-((CurTime()-self.FadeStartTime)/(self.FadeEndTime-self.FadeStartTime)))
			self:SetColor(255,255,255,105+frac)
		end
	end
end

function ENT:OnRemove()

end

function ENT:Use(ply,callr)
	if ply ~= GAMEMODE.Curator then
		if not self.Fading then
			GAMEMODE:StealArt(ply,self,self.Item)
		else
			ply:ChatPrint("Someone's already in the process of taking this!")
		end
	end
end 

function ENT:Fade(dur)
	self.FadeStartTime = CurTime()
	self.FadeEndTime = CurTime() + dur
	self.Fading = true
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON) -- to replace ShouldCollide
end 

function ENT:StopFade()
	self.Fading = false
	self.FadeStartTime = nil
	self.FadeEndTime = nil
	self:SetColor(255,255,255,255)
	self:SetCollisionGroup(COLLISION_GROUP_COLLISION_GROUP_INTERACTIVE) -- to replace ShouldCollide
end 