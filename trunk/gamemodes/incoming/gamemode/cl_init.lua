INC = {}
INC.Maps = {}

include( "cl_deathnotice.lua" )
include( "vgui/progressbar.lua" )
include( "maps.lua" )
include( "shared.lua" )

local ProgressHud = surface.GetTextureID( "models/clannv/nvincoming/hud/progress_bar" )

function GM:HUDPaint()
	self.BaseClass:HUDPaint()
	
	if ( INC.Maps[ game.GetMap() ] and LocalPlayer():Alive() ) then
		local Dist = math.floor( LocalPlayer():GetPos():Distance( INC.Maps[ game.GetMap() ].Spot ) )
		
		-- This is used to get the distance of the winning spot.
		--draw.DrawText( Dist, "TargetID", ScrW()/2,ScrH()/2, Color( 255, 255, 255, 255 ) )
		local w = math.Clamp( 245 * math.abs( ( Dist / INC.Maps[ game.GetMap() ].Distance ) - 1 ), 15, 242 )
		if w < 0 then w = 0 end
		local center =
		
		draw.RoundedBoxEx( 8, ScrW() - 272, ScrH() - 45, 262, 35, Color( 140, 140, 140, 255 ), true, false, false, true )
		draw.RoundedBoxEx( 8, ScrW() - 257, ScrH() - 40, 242, 25, Color( 100, 100, 100, 140 ), true, false, false, true )
		draw.RoundedBoxEx( 8, ScrW() - 267, ScrH() - 40, w, 25, Color( 0, 200, 0, 240 ), true, false, false, true )
		
		surface.CreateFont ("coolvetica", ScreenScale(12), 240, true, false, "CV20Scaled")
		
		local struc = {}
		struc.pos = { ScrW() - 140, ScrH() - 25 }
		struc.color = Color(255,255,255,155)
		struc.text = "Get to the top!"
		struc.font = "CV20Scaled"
		struc.xalign = TEXT_ALIGN_CENTER
		struc.yalign = TEXT_ALIGN_CENTER
		draw.Text( struc )

		//surface.DrawRect( 40, ScrH() - 35, math.Clamp( 245 * math.abs( ( Dist / INC.Maps[ game.GetMap() ].Distance ) - 1 ), 0, 245 ), 25 )
	end
end

function GM:HUDDrawTargetID()	
	return
end

local Hide = { "CHudHealth", "CHudBattery" }
function GM:HUDShouldDraw( a )
	for k, v in pairs( Hide ) do
		if ( a == v ) then	
			return false
		end
	end
	
	return true
end
