include( 'shared.lua' )

ColorModify = {}
ColorModify[ "$pp_colour_addr" ] = 0
ColorModify[ "$pp_colour_addg" ] = 0
ColorModify[ "$pp_colour_addb" ] = 0
ColorModify[ "$pp_colour_brightness" ] = 0
ColorModify[ "$pp_colour_contrast" ] = 1
ColorModify[ "$pp_colour_colour" ] = 1
ColorModify[ "$pp_colour_mulr" ] = 0
ColorModify[ "$pp_colour_mulg" ] = 0
ColorModify[ "$pp_colour_mulb" ] = 0

local function WeirdEffects()

	local approach = FrameTime() * 2
	if LocalPlayer():GetNWBool("BlackAndWhite",false) then
		ColorModify[ "$pp_colour_colour" ] = math.Approach( ColorModify[ "$pp_colour_colour" ], 0, approach )
	else
		ColorModify[ "$pp_colour_colour" ] = math.Approach( ColorModify[ "$pp_colour_colour" ], 1, approach )
	end
	
	DrawColorModify( ColorModify )
end
hook.Add( "RenderScreenspaceEffects", "CoolShit", WeirdEffects )

local function PlayerFallNoKiller( message )

	local player = message:ReadEntity();
	
	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	pnl:AddText( player )
	pnl:AddText( "fell to his or her death" )
	g_DeathNotify:AddItem( pnl )
	
end
usermessage.Hook( "PlayerFallNoKiller", PlayerFallNoKiller )

local function PlayerFallKiller( message )

	local killer = message:ReadEntity()
	local action = message:ReadString()
	local player = message:ReadEntity()
	
	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	pnl:AddText( killer )
	pnl:AddText( action )
	pnl:AddText( player )
	g_DeathNotify:AddItem( pnl )
	
end
usermessage.Hook( "PlayerFallKiller", PlayerFallKiller )

function GM:AddScoreboardKills( ScoreBoard )

	local f = function( ply ) return tonumber(ply:GetNWInt("Wins",0)) end
	ScoreBoard:AddColumn( "Wins", 50, f, 0.5, nil, 6, 6 )

end

function GM:AddScoreboardDeaths( ScoreBoard )

	local f = function( ply ) return ply:Deaths() end
	ScoreBoard:AddColumn( "Falls", 50, f, 0.5, nil, 6, 6 )

end
