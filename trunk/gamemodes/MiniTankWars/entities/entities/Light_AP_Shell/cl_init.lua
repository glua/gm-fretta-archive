  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
Light_AP_Shell cl_init.lua
	-AP Tank Round Entity clientside init
*/

include('shared.lua');
 
 
function ENT:Initialize()
	self.Entity:SetModelScale(Vector(1,0.5,0.5))
end
 
function ENT:Draw()
	self.Entity:DrawModel();
end