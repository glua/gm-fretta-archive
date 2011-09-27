
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:EnableMotion(false)
	end
	
	self:TemporarilyDisable()
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON) -- to replace ShouldCollide
	
end

function ENT:Think()
	if self.Active then
		local tr = {}
		local numtra = 6
		local dist = self:BoundingRadius()*2
		local DistInc = dist/numtra
		local addr = (self:GetAngles():Right()*(self:OBBMins()/numtra):Distance(self:OBBMaxs()/numtra))
		for i=math.floor(numtra/-2)+2,math.floor(numtra/2)+2 do
			local start = self:GetPos()+(self:GetAngles():Up()*i*DistInc)+addr
			tr[i] = util.QuickTraceHull(start,self:GetAngles():Right()*1500,self:OBBMins()/numtra,self:OBBMaxs()/numtra,self) --convoluted shit here. All for the sake of resolution.
			if tr[i].Entity and tr[i].Entity:IsValid() and tr[i].Entity:IsPlayer() and tr[i].Entity ~= GAMEMODE.Curator then
				tr[i].Entity:SetNWInt("Detection",math.Clamp(tr[i].Entity:GetNWInt("Detection")+100,0,1000))
				debugoverlay.Line( self:GetPos(), tr[i].HitPos)
			end
		end
	end
	self:NextThink(CurTime() + 0.2)
	return true
end

function ENT:OnRemove()
	if self.Item and self.Item.OnRemove then self.Item:OnRemove() end
end
 
function ENT:ReActivate()
	self.Active = true
	self:EmitSound("HL1/fvox/activated.wav",SNDLVL_VOICE,100)
	self:SetNWBool("Active",true)
end

function ENT:DeActivate()
	self.Active = false
	self:SetNWBool("Active",false)
end 

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
function ENT:TemporarilyDisable(num)
	self:DeActivate()
	self.timer = timer.Create(self:EntIndex().."Reenable",num or 5,1,function() self:ReActivate() end)
end 