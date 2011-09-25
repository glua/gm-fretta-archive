 /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
PowerUp_Repair init.lua
	-Repair Powerup Entity serverside init
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()	
	self.Entity:SetModel( "models/BMCha/MiniTanks/Powerups/Card.mdl" )
	self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:DrawShadow(false)
end