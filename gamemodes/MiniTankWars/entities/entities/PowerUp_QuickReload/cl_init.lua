  /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
PowerUp_QuickReload cl_init.lua
	-QuickReload Powerup Entity clientside init
*/

include('shared.lua');
 
function ENT:Draw()
	self.Entity:DrawModel();
end