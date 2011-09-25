 /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
Tank Wreck init.lua
	-Wreck Entity serverside init
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local ModelsList = {}
ModelsList["T-90"] = "models/BMCha/MiniTanks/T-90/T-90_Body.mdl"
ModelsList["M1A2_Abrams"] = "models/BMCha/MiniTanks/M1A2_Abrams/M1A2_Abrams_Body.mdl"
ModelsList["M551_Sheridan"] = "models/BMCha/MiniTanks/M551_Sheridan/M551_Sheridan_Body.mdl"
ModelsList["BMP-3"] = "models/BMCha/MiniTanks/BMP-3/BMP-3_Body.mdl"

function ENT:Initialize()
	self.Entity.MyPlayer = NULL
	
	self.Entity:SetModel( "models/BMCha/MiniTanks/T-90/T-90_Body.mdl") //will be overridden
	self.Entity:SetMaterial( "models/props_pipes/GutterMetal01a.vmt" )
	self.Entity:SetColor(100,100,100,255)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity.Alpha=255
	timer.Simple(15,function() self.Entity.DecA=true end)
end

function ENT:SetTank(tankName)
	self.Entity:SetModel(ModelsList[tankName])
end

function ENT:Think()
	if self.Entity.DecA == true then
		self.Entity.Alpha=self.Entity.Alpha-((255-self.Entity.Alpha)*0.25+0.5)
		if self.Entity.Alpha < 0 then
			self.Entity:Remove()
			return
		end
		self.Entity:SetColor(50,50,50,self.Entity.Alpha)
	end
end
