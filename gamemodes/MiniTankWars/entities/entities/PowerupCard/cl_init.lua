  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
PowerUp_Repair cl_init.lua
	-Repair Powerup Entity clientside init
*/

include('shared.lua');
 
function ENT:Draw()
	self.Entity:DrawModel();
end

function ENT:Think()
	self.Entity:SetAngles(Angle(0,0,0))
	self.Entity:NextThink(CurTime())
	return true
end

function ENT:Initialize()
	self.Entity:DestroyShadow()
end