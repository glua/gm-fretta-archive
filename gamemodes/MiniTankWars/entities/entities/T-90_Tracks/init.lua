 /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
ProtoTank_Tracks init.lua
	-ProtoTank Tracks Entity serverside init
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity.MyPlayer = NULL
	
	self.Entity:SetModel( "models/BMCha/MiniTanks/T-90/T-90_Tracks.mdl")
	/*self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )*/
	self.Entity:SetNotSolid(true)
end