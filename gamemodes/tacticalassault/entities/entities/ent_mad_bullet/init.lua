-- Physically simulated bullet
-- SENT by Teta_Bonita


AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()

	self.Position = self.Entity:GetPos()
	self.Velocity = self.Entity:GetVar("Velocity",false)
	self.Acceleration = self.Entity:GetVar("Acceleration",false)
	self.Bullet = self.Entity:GetVar("Bullet",false)
	self.Trace = self.Entity:GetVar("Trace",false)
	
	if not (self.Position and self.Velocity and self.Acceleration and self.Bullet and self.Trace) then 
		Msg("sent_bullt: Error! Insufficient data to spawn.\n")
		self:Remove() 
		return 
	end
	
	self.Owner = self.Owner or self.Entity
	self.LastThink = CurTime()
	self.Trace.endpos = self.Position
	
	self.Bullet.Spread = Vector(0,0,0)
	self.Bullet.Num = 1
	self.Bullet.Tracer = 0
	
	self.Entity:Fire("kill","",7) -- Kill this entity after awhile
	
end


function ENT:Think() -- Do prediction serverside

	local fTime = CurTime()
	local DeltaTime = fTime - self.LastThink
	self.LastThink = fTime

	self.Position = self.Position + self.Velocity*DeltaTime
	self.Velocity = self.Velocity + self.Acceleration*DeltaTime
	
	self.Trace.start = self.Trace.endpos
	self.Trace.endpos = self.Position
	
	local TraceRes = util.TraceLine(self.Trace)
	
	if TraceRes.Hit then
		self.Bullet.Src = self.Trace.start
		self.Bullet.Dir = (TraceRes.HitPos - self.Trace.start)
		self.Owner:FireBullets(self.Bullet)
		
		self:Remove()
		return false
	end


end


