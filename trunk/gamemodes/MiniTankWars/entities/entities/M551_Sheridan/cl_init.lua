 /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
ProtoTank cl_init.lua
	-ProtoTank Entity clientside init
*/

include('shared.lua');
 
function ENT:Draw()
	self.Entity:DrawModel();
end

function ENT:Initialize()
	self.Entity.WheelsRot=0
	self.Entity.LastPos=self.Entity:GetPos()
	
	self.Entity.emitter = ParticleEmitter(self.Entity.LastPos)
	self.Entity.EngineAttachment=self.Entity:LookupAttachment("Engine")
	self.Entity.LastTime=CurTime()
	self.Entity.SmokeTime=CurTime()
end

function ENT:Think()
	local dt = CurTime()-self.Entity.LastTime
	if (self.Entity.WheelsRot > 360) then self.Entity.WheelsRot = self.Entity.WheelsRot-360 end
	if (self.Entity.WheelsRot < 0) then self.Entity.WheelsRot = self.Entity.WheelsRot+360 end
	local MovVec = self.Entity:GetPos()-self.Entity.LastPos
	local Vel = (MovVec-Vector(0,0,MovVec.z)):Length()
	Vel = Vel*MovVec:Normalize():Dot(self.Entity:GetForward())
	self.Entity.Vel=Vel
	self.Entity.WheelsRot=self.Entity.WheelsRot+(Vel*6.565)  //360/57.18=6.295
	self.Entity:SetPoseParameter("Wheels_Rot", self.Entity.WheelsRot)
	self.Entity.LastPos=self.Entity:GetPos()
	//engine smooke
	if (CurTime()-self.Entity.SmokeTime > 0.1) then
		self.Entity.emitter = ParticleEmitter(self.Entity.LastPos)
		local AttachmentData = self.Entity:GetAttachment(self.Entity.EngineAttachment)
			local particle = self.Entity.emitter:Add("particle/particle_smokegrenade", AttachmentData.Pos+Vector(math.random(40)-20, math.random(40)-20, math.random(10)))
			if (particle) then
				particle:SetVelocity( Vector(math.random(30)/10,math.random(30)/10,30) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1.0, 1.5 ) )
				particle:SetStartAlpha( 255)
				particle:SetEndAlpha( 0 )
				particle:SetColor(50, 50, 50, 255)
				particle:SetStartSize( 20 )
				particle:SetEndSize( 30 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( 0.5 )
				particle:SetAirResistance( 10 )
				particle:SetGravity( Vector( 0, 0, 50 ) )
				particle:SetCollide( false )
			end
		self.Entity.SmokeTime=CurTime()
	end
	self.Entity.LastTime=CurTime()
end

function ENT:Remove()
	self.Entity.emitter:Finish()
end
