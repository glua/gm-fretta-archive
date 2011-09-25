  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
PowerUp_SpeedBoost cl_init.lua
	-Powerup Chute Entity clientside init
*/

include('shared.lua');
 
function ENT:Draw()
	self.Entity:DrawModel();
end