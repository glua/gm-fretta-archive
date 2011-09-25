// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Clientside functions and methods for the gamemode.

include("shared.lua")
include("skin.lua")
include("cl_hud.lua")
include("cl_scores.lua")

// VGUI
local strpath = "lasertag/gamemode/vgui"
for k,v in ipairs(file.FindInLua(strpath.."/*.lua")) do
	include(strpath.."/"..v)
end

/*
include("vgui/vgui_hudlayout.lua")
include("vgui/vgui_hudelement.lua")
include("vgui/vgui_hudupelement.lua")
include("vgui/vgui_hudbase.lua")
include("vgui/vgui_hudcommon.lua")
*/

function GM:Initialize()
	self.BaseClass:Initialize()
end

function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

function GM:ShowTeam()
	// TODO: Decent looking notification message.
	if self.NoTeamSwapAfterSpawn and LocalPlayer():Team() >= 1 and LocalPlayer():Team() <= 4 then return false end
	
	return self.BaseClass:ShowTeam()
end


// Shield Effects
local shieldBase = CreateMaterial("shieldMat", "UnlitGeneric", {
		["$basetexture"] = "models/debug/debugwhite",
		["$model"] = 1,
})
local shieldScroll = Material("LaserTag/playershield")
local CanDraw = true


/*-------------------------------------------------------------------
	[ PostPlayerDraw ]
	Draw the shields for each player.
-------------------------------------------------------------------*/
function GM:PostPlayerDraw(v)
	if CanDraw and v ~= LocalPlayer() and ValidEntity(v) and v:Alive() then
		local vcenter = v:LocalToWorld(v:OBBCenter())
		local col = team.GetColor(v:Team()) // Get the team color and use it for the shield.
		local ShStrength = v:GetNetworkedInt("Shield")
		
		// Calculate blend
		local BaseBlend = 0.4
		local MinBlend = 0.1
		local CurBlend = (BaseBlend - MinBlend) * (ShStrength/100) // Gives us a blend that diminishes with shield damage.
		local PulseRate = 5 + (10 * (1 - ShStrength/100)) // How quickly the shield pulses, make it faster as the player takes more damage.
		
		// This is the magic that allows us to draw the shield effect around players. We redraw their model as if we were closer to them, so their model draws larger.
		// The distance is scaled to make the effect appear more natural. Otherwise clipping occurs at too close distances.
		cam.Start3D(EyePos() + ((vcenter-EyePos()):Normalize()*math.Clamp(0.04 * EyePos():Distance(vcenter),0.5,15)),EyeAngles())
			
			/*----------------------------------------------------------------------------
				  Prior to the change from two effects to one.
				----------------------------------------------------------------------
			render.SetColorModulation(col.r/255,col.g/255,col.b/255)
			render.SetBlend(0.2 + (0.1*math.sin(CurTime()*3))) // This is the pulsing shield effect. Base Shield glow (0.5) Plus or Minus 0.2 as it follows a sine wave. Min 0.3, max 0.7
			SetMaterialOverride(shieldBase)
			
			CanDraw = false
			v:DrawModel()
			
			render.SetBlend(0.3) // This is the scrolling shield effect that is additive to the above.
			SetMaterialOverride(shieldScroll)
			----------------------------------------------------------------------------*/
			
			CanDraw = false // CanDraw is protection against this PostPlayerDraw function being run again when we perform v:DrawModel() which would cause a nasty loop.
			render.SetColorModulation(col.r/255,col.g/255,col.b/255)
			render.SetBlend(CurBlend + (0.05*math.sin(CurTime()*PulseRate))) // This is the pulsing shield effect.
			SetMaterialOverride(shieldScroll)
			v:DrawModel()
			CanDraw = true
			
			// Reset values to their defaults.
			render.SetColorModulation(1,1,1)
			render.SetBlend(1)
			SetMaterialOverride(0)
		cam.End3D()
	end
end