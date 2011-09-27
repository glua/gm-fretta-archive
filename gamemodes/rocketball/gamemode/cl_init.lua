-- CLIENT --

-- Load lua files.
include("shared.lua")
include("cl_hud.lua")

------------------------------------
-- Create variables and Initialize.
------------------------------------
function GM:Initialize()
	self.BaseClass:Initialize()
end

function GM:Think()
	self.BaseClass:Think()
end

------------------------------------
-- Render Functions.
------------------------------------
function GM:PaintSplashScreen( width, height )
	self.BaseClass:PaintSplashScreen( width, height )
end

function GM:RenderScreenspaceEffects()
	self.BaseClass:RenderScreenspaceEffects()
end