 /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
Tank Wreck cl_init.lua
	-Tank Wreck Entity clientside init
*/

include('shared.lua');
 
function ENT:Draw()
	self.Entity:DrawModel();
end

function ENT:Initialize()
	self.Entity.emitter = ParticleEmitter(self.Entity:GetPos())
	self.Entity.SmokeTime=CurTime()
end

function ENT:Think()
	if (CurTime()-self.Entity.SmokeTime > 0.1) then
		local vOffset=self.Entity:GetPos()
		self.Entity.emitter = ParticleEmitter(vOffset)
		for i=1,2,3 do
			local particle = self.Entity.emitter:Add("particle/particle_smokegrenade", vOffset+Vector(math.random(80)-40, math.random(150)-75, math.random(80)))
			if (particle) then
				particle:SetVelocity( Vector(math.random(50),math.random(50),150) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1.0, 1.5 ) )
				particle:SetStartAlpha( 255)
				particle:SetEndAlpha( 0 )
				particle:SetColor(25, 25, 25, 255)
				particle:SetStartSize( 80 )
				particle:SetEndSize( 60 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-1,1) )
				particle:SetAirResistance( 7 )
				particle:SetGravity( Vector( 0, 0, 100 ) )
				particle:SetCollide( false )
			end
		end
		self.Entity.SmokeTime=CurTime()
	end
end

function ENT:OnRemove()
	self.Entity.emitter:Finish()
end