  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
ProtoTank_Tracks cl_init.lua
	-ProtoTank Tracks Entity clientside init
*/

include('shared.lua');
 
//Tracks Materials
local TrackMats = {
[-256]="models/BMCha/MiniTanks/M551_Sheridan/RTracks256",
[-192]="models/BMCha/MiniTanks/M551_Sheridan/RTracks192",
[-128]="models/BMCha/MiniTanks/M551_Sheridan/RTracks128",
[-64]="models/BMCha/MiniTanks/M551_Sheridan/RTracks64",
[0]="models/BMCha/MiniTanks/M551_Sheridan/Tracks0",
[64]="models/BMCha/MiniTanks/M551_Sheridan/Tracks128",
[128]="models/BMCha/MiniTanks/M551_Sheridan/Tracks128",
[192]="models/BMCha/MiniTanks/M551_Sheridan/Tracks256",
[256]="models/BMCha/MiniTanks/M551_Sheridan/Tracks256",
[320]="models/BMCha/MiniTanks/M551_Sheridan/Tracks384",
[384]="models/BMCha/MiniTanks/M551_Sheridan/Tracks384",
[448]="models/BMCha/MiniTanks/M551_Sheridan/Tracks512",
[512]="models/BMCha/MiniTanks/M551_Sheridan/Tracks512",
}

function ENT:Initialize()
	self.Entity.LastPos=self.Entity:GetPos()
	self.Entity.OldMat = self.Entity:GetMaterial()
	self.Entity.LastTime = CurTime()
	self.Entity.BodyEnt = self.Entity:GetNWEntity("TankBody", self.Entity)
	self.Entity.Vel=0
	
	self.Entity.emitter = ParticleEmitter(self.Entity:GetPos())
	self.Entity.LDAt=self.Entity:LookupAttachment("LeftDust")
	self.Entity.RDAt=self.Entity:LookupAttachment("RightDust")
	
	self.Entity.DustTime=CurTime()
	
	self.Entity:SetNotSolid(true)
end
 
function ENT:Draw()
	self.Entity:DrawModel();
end

function ENT:Think()
	local FT=CurTime()-self.Entity.LastTime
	if FT==0 then FT=0.001 end
	self.Entity.LastTime = CurTime()
	if self.Entity.BodyEnt == self.Entity then
		self.Entity.BodyEnt = self.Entity:GetNWEntity("TankBody", self.Entity)
	end
	local Vel=self.Entity.BodyEnt.Vel
	local NewMat=TrackMats[math.Clamp(math.Round((Vel/FT)/64),-4,8)*64]
	if self.Entity.OldMat!=NewMat then
		self.Entity:SetMaterial(NewMat)
		self.Entity.OldMat = NewMat
	end
	//********************tracks dust*************************
	if (Vel/FT > 128)and(CurTime()-self.Entity.DustTime > 0.2) then
		self.Entity.emitter = ParticleEmitter(self.Entity.LastPos)
		
		local vOffset = self.Entity:GetAttachment(self.Entity.LDAt).Pos
		local particle = self.Entity.emitter:Add("particle/particle_smokegrenade", vOffset+Vector(math.random(20)-10, math.random(20)-10, math.random(20)-10))
		if (particle) then
			particle:SetVelocity( Vector(math.random(15),math.random(15),30) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 1.0, 1.5 ) )
			particle:SetStartAlpha( 255)
			particle:SetEndAlpha( 0 )
			particle:SetColor(128, 108, 78, 255)
			particle:SetStartSize( 40 )
			particle:SetEndSize( 50 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( 0.5 )
			particle:SetAirResistance( 5 )
			particle:SetGravity( Vector( 0, 0, 20 ) )
			particle:SetCollide( false )
		end
		vOffset = self.Entity:GetAttachment(self.Entity.RDAt).Pos
		local particle = self.Entity.emitter:Add("particle/particle_smokegrenade", vOffset+Vector(math.random(20)-10, math.random(20)-10, math.random(20)-10))
		if (particle) then
			particle:SetVelocity( Vector(math.random(15),math.random(15),30) )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 1.0, 1.5 ) )
			particle:SetStartAlpha( 255)
			particle:SetEndAlpha( 0 )
			particle:SetColor(128, 108, 78, 255)
			particle:SetStartSize( 40 )
			particle:SetEndSize( 50 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( -0.5 )
			particle:SetAirResistance( 5 )
			particle:SetGravity( Vector( 0, 0, 20 ) )
			particle:SetCollide( false )
		end
		self.Entity.DustTime=CurTime()
	end
	//*********************end tracks dust************************
end
