AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/props_c17/GasPipes006a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetNotSolid(true)
	self.Entity:SetTrigger(true)
	
	local phys = self.Entity:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
		phys:SetMass(1)
	end
	phys:AddVelocity(Vector(0,0,-45))
	
	if(self.Entity:GetteamNum() == 1) then
		self.Entity:SetColor(Color(255,0,0))
	else
		self.Entity:SetColor(Color(0,0,255))
	end
	
	self.Entity.oFlagSp = self.Entity:GetPos()
end

function ENT:Think()
	local pos = self.Entity:GetPos()
	local tracedata = {}
	local speed = 45
	tracedata.start = pos
	tracedata.endpos = pos - Vector(0,0,10000)
	tracedata.filter = self.Entity
	
	local phys = self.Entity:GetPhysicsObject()
	phys:AddAngleVelocity(Vector(0,0,150)-phys:GetAngleVelocity())
	local trace = util.TraceLine(tracedata)
	if (trace.Hit) then
		if (pos:Distance(trace.HitPos) > 74) then
			self.Entity.oFlagSp = trace.HitPos + Vector(0,0,65)
		elseif (pos:Distance(trace.HitPos) < 56) then
			self.Entity.oFlagSp = trace.HitPos + Vector(0,0,65)
		end
	end
	
	if(self.Entity:GetPos().z > self.Entity.oFlagSp.z+10) then
		phys:AddVelocity(Vector(0,0,-speed)-phys:GetVelocity())
	elseif(self.Entity:GetPos().z < self.Entity.oFlagSp.z-10) then
		phys:AddVelocity(Vector(0,0,speed)-phys:GetVelocity())
	end
end