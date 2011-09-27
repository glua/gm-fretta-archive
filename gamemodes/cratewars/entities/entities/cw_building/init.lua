AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
self.Entity:SetModel("models/props_buildings/project_building01_skybox.mdl")
end