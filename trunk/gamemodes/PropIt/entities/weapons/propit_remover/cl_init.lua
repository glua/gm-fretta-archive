include('shared.lua')
include('cl_viewscreen.lua')

SWEP.PrintName			= "Remover"			
SWEP.Slot				= 1	
SWEP.SlotPos			= 6	
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.WepSelectIcon		= surface.GetTextureID( "vgui/gmod_tool" )
SWEP.Gradient			= surface.GetTextureID( "gui/gradient" )
SWEP.InfoIcon			= surface.GetTextureID( "gui/info" )

SWEP.ToolNameHeight		= 0
SWEP.InfoBoxHeight		= 0

surface.CreateFont( "coolvetica", 48, 1000, true, false, "GModToolName" )
surface.CreateFont( "coolvetica", 24, 500, true, false, "GModToolSubtitle" )
surface.CreateFont( "coolvetica", 19, 500, true, false, "GModToolHelp" )