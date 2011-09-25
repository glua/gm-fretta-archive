
//Client

include( 'shared.lua' )
include( 'cl_hints.lua' )
include( 'cl_hud.lua' )
include( 'vgui/vgui_hudcactusicon.lua' )


local cactus_thirdperson = CreateClientConVar( "cl_cactus_thirdperson", "0", false, false )
local cactus_thirdperson_dist = CreateClientConVar( "cl_cactus_thirdperson_offset", "100", false, false )
	
function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

function GM:AddScoreboardKills( ScoreBoard )

	local f = function( ply ) return ply:Frags() end
	ScoreBoard:AddColumn( "Points", 60, f, 0.5, nil, 6, 6 )

end
function GM:AddScoreboardDeaths( ScoreBoard )
	return false
end

function GM:ScreenScaleSize( size )  --Scales clientside objects by screen res
	//Commenting out for testing purposes...
    return size --* ( ScrH() / 480.0 )  
end

function SpecCalcView(ply, origin, angles, fov)
	if ply:Alive() or !ply:IsObserver() then return end
	local view = {}
	if ply:GetInfoNum( "cl_spec_mode" ) == OBS_MODE_CHASE then
		view.angles = Angle(angles.pitch, angles.yaw, 0) --This fixes that buggy spectator angle change that happens when you try to spectate a rotated entity.
	end
	return view
end
hook.Add("CalcView","specview",SpecCalcView)





