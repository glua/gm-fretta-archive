
include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_scores.lua" )

language.Add( "fw_flag", "The flag" )
killicon.Add( "fw_flag", "fw/flag", color_white )
language.Add( "fw_c4", "C4 explosive" )
killicon.Add( "fw_c4", "fw/explode", color_white )
language.Add( "fw_prop", "Prop" )

function GM:HUDDrawTargetID()
     return false //Don't draw the default Gmod info thingy if you look at someone
end

local Spawnmenu = nil
local ghostS = NULL //Spawnpoint ghost
local c4 = nil //C4 warning
local c4warnalpha = 0

function Init()

	Spawnmenu = vgui.Create( "DFrame" ) //Create the spawnmenu
	
	local modelH = 68
	Spawnmenu:SetSize( 256 + 10 + 64, 300 + 117 + modelH ) //TODO: What the hell? Hardcoded values?
	Spawnmenu:Center()
	Spawnmenu:SetDraggable( false )
	Spawnmenu:ShowCloseButton( false )
	Spawnmenu:SetTitle( "Prop Chooser - Click a prop to spawn it" )
	Spawnmenu:SetVisible( false )
	
	local spawniconM = vgui.Create( "DPanelList", Spawnmenu )
	local dist = 5
	spawniconM:StretchToParent( dist, 23 + dist, dist, dist + modelH )
	spawniconM:EnableVerticalScrollbar( false )
	spawniconM:EnableHorizontal( true ) //We don't need vertical spawnlists, allow them to be next to eachother too!
	spawniconM:SetSpacing( 0 ) //Tight!
	
	infopanelM = vgui.Create( "DPanel", Spawnmenu ) //Information panel
	infopanelM:SetSize( 256 + 64, modelH - 5 )
	infopanelM:SetPos( 5, 417  )
	
	infolabel = vgui.Create( "DLabel", infopanelM ) //Name & health label
	infolabel:SetPos( 5, 5 )
	infolabel:SetText( "...\n..." )
	infolabel:SetTextColor( color_black )
	infolabel:SizeToContents()
	
	infolabelPL = vgui.Create( "DLabel", infopanelM ) //Prop limit label
	infolabelPL:SetPos( 5, 5 )
	infolabelPL:SetText( "...\n..." )
	infolabelPL:SizeToContents()
	
	infolabelPL.Think = function( label )
		local fraction = LocalPlayer():GetNWInt( "Props", 0 ) / PropLimit - 0.5
		label:SetTextColor( Color( math.max( 0, fraction ) * 255, 0, 0 ) )
		//Fade the text red if the player is nearing the prop limit
	end
	
	infoRemovebutton = vgui.Create( "DButton", infopanelM ) //Remove button
	infoRemovebutton:SetText( "Remove all props" )
	infoRemovebutton:SizeToContents()
	local W, H = infoRemovebutton:GetSize()
	infoRemovebutton:SetSize( W + 12, infopanelM:GetTall() - 10 )
	infoRemovebutton:SetPos( infopanelM:GetWide() - infoRemovebutton:GetWide() - 5, 0 )
	infoRemovebutton:CenterVertical()
	infoRemovebutton:SetConsoleCommand( "fwx_removeprops" )
	
	local button = {}
	
	for i = 1, #PropList do

		button[i] = vgui.Create( "SpawnIcon" )
		
		local model2 = PropList[i][1]
		button[i]:SetModel( model2 )
		
		button[i].DoClick = function( button )
			surface.PlaySound( "ui/buttonclickrelease.wav" ) //Blip!
			RunConsoleCommand( "fwx_spawn", model2 ) //Spawn the prop
		end
		
		button[i].Think = function( button )
			button.animPress:Run()
			infolabelPL:SetText( Format( "\n\nProps used: %i/%i", LocalPlayer():GetNWInt( "Props", 0 ), PropLimit ) )
			infolabelPL:SizeToContents()
		end
		
		button[i].OnCursorEntered = function( button )
			button.PaintOverOld = button.PaintOver
			button.PaintOver = button.PaintOverHovered
			infolabel:SetText( InfoString( i ) )
			infolabel:SizeToContents() 
		end
		
		spawniconM:AddItem( button[i] ) //Add it to the list
		
	end
	
end
	
hook.Add( "Initialize", "FWInit", Init )

function CreateSGhost() //Create spawnpoint ghost
	
	ghostS = ClientsideModel( "models/player.mdl", RENDERGROUP_TRANSLUCENT )
	ghostS:SetPos( vector_origin )
	ghostS:SetMaterial( "models/debug/debugwhite" )
	ghostS:Spawn()
	ghostS:Activate()
	
end

hook.Add( "InitPostEntity", "SpawnGhostCreator", CreateSGhost )

function InfoString( n )
	local mdl = PropList[n][1]
	return Format( "Name: %s\nHealth: %i", TranslateMDL( mdl ), PropList[n][2] )
	//The TranslateMDL function translates an internal modelname to a nice name. It's defined in prop_list.lua
end

function GM:OnSpawnMenuOpen()
	if ( LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():Team() == TEAM_UNASSIGNED ) then return end //No spawnmenu if you're a spectator!
	if ( GetGlobalInt( "RoundNumber" ) != 1 ) then RunConsoleCommand( "lastinv" ) return end //If in fight phase, switch to last used weapon
	Spawnmenu:SetVisible( true ) //Show the spawnmenu
	Spawnmenu:MakePopup() //Dunno if this is needed, but just to be sure ;)
	Spawnmenu:SetKeyBoardInputEnabled( false ) //Can still walk around with Q held down
	RestoreCursorPosition()
end

function GM:OnSpawnMenuClose()
	RememberCursorPosition()
	Spawnmenu:SetVisible( false ) //Hide the spawnmenu
end
 
function HUDPaint()

	local font = "DefaultBold"
	
	for _, v in pairs ( player.GetAll() ) do //Draw info thingy above all player's heads
		if ( LocalPlayer() != v and v:Alive() and v:Team() != TEAM_UNASSIGNED and v:Team() != TEAM_SPECTATOR and v:Team() == LocalPlayer():Team() ) then 
			DrawInfo( v, font )
		end
	end
	
	local flag = ents.FindByClass( "fw_flag" )[1]
	if ( ValidEntity( flag ) ) then //Draw flag indicator
		DrawFlag( flag, font )
	end
	
	local pos, ang = LocalPlayer():GetNWVector( "Spawnpoint", false ), LocalPlayer():GetNWAngle( "Spawnang", false )
	if ( LocalPlayer():Team() != TEAM_SPECTATOR and LocalPlayer():Team() != TEAM_UNASSIGNED and pos and ang ) then //Draw spawnpoint indicator
		DrawSpawnPoint( pos, ang )
	end

	local ent = LocalPlayer():GetEyeTrace().Entity 
	if ( ValidEntity( ent ) and ent:GetClass() == "fw_prop" ) then //Draw prop info thingy
		DrawPropInfo( ent, font )
	end
	
	if ( ValidEntity( c4 ) ) then
		DrawC4Warn( font )
	end
	
	c4warnalpha = math.max( c4warnalpha - 2, 0 )
	
end

hook.Add( "HUDPaint", "DrawHud", HUDPaint )

function DrawInfo( v, font )
	
	surface.SetFont( font )
	local BoneIndx = v:LookupBone( "ValveBiped.Bip01_Head1" ) 
	local BonePos, BoneAng = v:GetBonePosition( BoneIndx )
	BonePos.z = BonePos.z + 10
	local pos = BonePos:ToScreen()
	local text = v:Nick() .. " - " .. v:Health() .. "%"
	
	local txtw, txth = surface.GetTextSize( text )
	
	local alp = 1000 - ( LocalPlayer():GetPos() - BonePos ):Length() //Fade it according to the distance to it
	alp = math.Clamp( alp, 0, 1000 )
	alp = alp / 1000
	
	local teamcol = team.GetColor( v:Team() )
	teamcol.a = 127 * alp
	
	local tcol = Color( 255, 255, 255, alp * 255 )
	local ucol = Color( 0, 0, 0, alp * 255 )

	//Incoming sophisticated math bomb!!!
	draw.RoundedBox( 4, pos.x - ( txtw + 8 ) / 2, pos.y - ( txth + 4 ) / 2, txtw + 8, txth + 4, teamcol )
	draw.SimpleTextOutlined( text, font, pos.x, pos.y, tcol, 1, 1, 1, ucol )
	//BEWM!!!!!
	
end

function DrawFlag( flag, font )
	
	surface.SetFont( font )
	local wpos = flag:GetPos()
	local pos = wpos:ToScreen()
	local txt = "- FLAG -"
	local txtw, txth = surface.GetTextSize( txt )
		
	local alp = 4000 - ( LocalPlayer():GetPos() - wpos ):Length() //Fade it according to the distance to it
	alp = math.Clamp( alp, 0, 4000 )
	alp = alp / 4000
	
	local holder = flag:GetNWEntity( "CheckHolder", NULL )
	local teamcol = team.GetColor( TEAM_UNASSIGNED ) //TODO: Wasted processing power of getting a yellow-ish color!
	local teamcol2 = teamcol
	teamcol2.a = 127 * alp
	
	if ( ValidEntity( holder ) ) then
		teamcol = team.GetColor( holder:Team() )
	end
	
	if ( !flag:GetNWBool( "Check", false ) ) then
		teamcol = team.GetColor( TEAM_UNASSIGNED )
	end
	
	teamcol.a = 127 * alp
	local tcol = Color( 255, 255, 255, alp * 255 )
	local ucol = Color( 0, 0, 0, alp * 255 )
	
	//Incoming sophisticated math bomb!!!
	draw.RoundedBox( 4, pos.x - ( txtw + 8 ) / 2, pos.y - ( txth + 4 ) / 2, txtw + 8, txth + 4, teamcol2 )
	draw.SimpleTextOutlined( txt, font, pos.x, pos.y, tcol, 1, 1, 1, ucol )
	//BEWM!!!!!
	
	local QuadTable = {} 
		
		local deficon = surface.GetTextureID( "gui/silkicons/world" )
		QuadTable.texture = deficon
		
		if ( ValidEntity( holder ) ) then
			if ( holder:Team() == LocalPlayer():Team() ) then //Check icon if held by local player's team, exclamation icon otherwise
				QuadTable.texture = surface.GetTextureID( "gui/silkicons/check_on" )
			else
				QuadTable.texture = surface.GetTextureID( "gui/silkicons/exclamation" )
			end
		end
		
		if ( !flag:GetNWBool( "Check" ) or !flag:GetNWBool( "Check", false ) ) then
			QuadTable.texture = deficon //If it's not being held, default icon.
		end
		
		QuadTable.color	= Color( 255, 255, 255, alp * 255 )

		QuadTable.x = pos.x - ( txtw / 2 ) - 16 - 8
		QuadTable.y = pos.y - ( txth / 2 ) - 2
		QuadTable.w = 16 
		QuadTable.h = 16 
	
	draw.RoundedBox( 4, QuadTable.x - 2, QuadTable.y - 2, 16 + 4, 16 + 4, teamcol )
	draw.TexturedQuad( QuadTable )

end

function DrawSpawnPoint( pos, ang )
	
	if ( pos == vector_origin ) then ghostS:SetColor( 0, 0, 0, 0 ) return end
	local teamcol = team.GetColor( LocalPlayer():Team() )
	
	ghostS:SetPos( pos )
	ghostS:SetAngles( Angle( 0, ang.y, 0 ) )
	ghostS:SetColor( teamcol.r, teamcol.g, teamcol.b, 127 )

end

function DrawPropInfo( ent, font )
	
	surface.SetFont( font )
	local owner = ent:GetNWEntity( "Owner" )
	if ( !owner or !owner:IsValid() ) then return end
	
	local ownerN = owner:Nick()
	local hp = ent:GetNWInt( "HP", 0 )
	local col = team.GetColor( owner:Team() )
	
	local str = "Owner: " .. ownerN
	local str2 = "Health: " .. math.floor( hp )
	local txtw, txth = surface.GetTextSize( str )
	txth = math.Round( txth )
	
	draw.SimpleTextOutlined( str, font, ScrW()/2, ScrH()/2 - txth, col, 1, 1, 1, color_black ) //Owner
	draw.SimpleTextOutlined( str2, font, ScrW()/2, ScrH()/2 + txth, col, 1, 1, 1, color_black ) //HP
	
end

function DumpPropList( ply, command, args )
	PrintTable( PropList ) //Prop list debug function, can be used in conjuntion with fwx_spawn to spawn props via the console
end

concommand.Add( "fwx_proplist", DumpPropList )

local warnsnd = { "ambient/alarms/klaxon1.wav",
	"buttons/button5.wav",
	"buttons/button3.wav",
	"npc/roller/code2.wav" }

function FlagWarn( ply, command, args ) //My clever flag warning system

	local msg, Team = args[1], args[2]
	if ( !msg or !Team ) then return end
	
	local playsnd = 0 //I would do this bitwise if I knew how to do it
	local txt = ""
	
	if ( msg == "TAKE" ) then
		txt = "has taken"--the flag!"
		playsnd = 1
	elseif ( msg == "DROP" ) then
		txt = "has dropped"--the flag!"
		playsnd = 3
	else return end
	
	Team = tonumber( Team )
	
	local tm = ( Team == ply:Team() ) and "Your team" or "The enemy" //If...then..else in one line! How handy!
	if ( Team == ply:Team() ) then
		playsnd = playsnd + 1
	end
	
	------------------------------
	if ( !IsValid( g_DeathNotify ) ) then return end
	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	
	pnl:AddText( tm, team.GetColor( Team ) )
	pnl:AddText( txt )
	pnl:AddIcon( "fw_flag" )
	
	g_DeathNotify:AddItem( pnl )
	------------------------------
	
	surface.PlaySound( warnsnd[playsnd] ) //HUMM, T T T BLIP, BLIP or UUMMMM
	
end

concommand.Add( "fwx_flagwarn", FlagWarn ) //Well... maybe I should be doing this with user messages. Now noobs will type this in and brag to everyone they haxed my gamemode...

function C4Warn( um ) //If there's a C4 explosive nearby, warn the local player!
	
	local c4ent = um:ReadEntity()
	if ( !ValidEntity( c4ent ) ) then return end
	
	c4 = c4ent
	timer.Create( "stopc4warn", 0.9, 1, function() c4 = nil end )
	
	c4:EmitSound( "hl1/fvox/warning.wav", 0.27, 76 + ( c4:GetBlip() * 4 ) )
	c4warnalpha = 127

end

usermessage.Hook( "c4warn", C4Warn )

function DrawC4Warn( font )

	surface.SetFont( font )
	local pos = c4:GetPos():ToScreen()
	local text = "Warning! C4 explosive!"
	
	local txtw, txth = surface.GetTextSize( text )
	
	local teamcol = team.GetColor( c4:GetNWEntity( "Owner" ):Team() )
	teamcol.a = c4warnalpha 
	
	local tcol = Color( 255, 255, 255, c4warnalpha * 2 )
	local ucol = Color( 0, 0, 0, c4warnalpha * 2 )
	
	pos.x = math.Clamp( pos.x, txtw/2, ScrW() - (txtw/2) )
	pos.y = math.Clamp( pos.y, txth/2, ScrH() - (txth/2) )
	
	local box_x = pos.x - ( txtw + 8 ) / 2
	local box_y = pos.y - ( txth + 4 ) / 2

	//Incoming sophisticated math bomb!!!
	draw.RoundedBox( 4, box_x, box_y, txtw + 8, txth + 4, teamcol )
	draw.SimpleTextOutlined( text, font, pos.x, pos.y, tcol, 1, 1, 1, ucol )
	//BEWM!!!!!
	
end

local camprogress = 0

function GM:CalcView( ply, origin, angles, fov ) 
	
	local view = {}
	
	local wep = ply:GetActiveWeapon() //This fixes GetViewModelPosition being overridden by this function
	if ( ValidEntity( wep ) ) then
	
		origin = view.origin or origin
		angles = view.angles or angles
		fov = view.fov or fov
	
		local func = wep.GetViewModelPosition
		if ( func ) then view.vm_origin,  view.vm_angles = func( wep, origin*1, angles*1 ) end
		
		local func = wep.CalcView
		if ( func ) then view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov ) end
		
		return view
	
	end
	
	if ( TehEnd ) then //Awesomely smooth camera movement effect at the end of the game! WOHOO!
	
		camprogress = math.min( camprogress + 0.004, 1 )
		local smooth = math.EaseInOut( camprogress, 0.5, 0.5 )
		
		local flag = ents.FindByClass( "fw_flag" )[1]
		if ( !ValidEntity( flag ) ) then return end
		
		local posangles = Angle( 0, math.fmod( CurTime() * 20, 360 ), 0 )
		
		local flagpos = flag:GetPos() + ( posangles:Forward() * -70 )
		local flagangles = posangles
		
		view.origin = origin + ( ( flagpos - origin ) * smooth )
		view.angles = angles + ( ( flagangles - angles ) * smooth )
		view.fov = fov + ( ( 45 - fov ) * smooth )
		
		// Smooth stuff works in this format: var = var + ( ( goal - var ) * progress ): var is your variable, goal is the goal to reach, and progress is a variable between 0 and 1 to describe how far the progress is
	
	end
	
	return view
	
end

function ColorModify()
	
	if ( TehEnd ) then // Black and white at the end of the game
	
		local tab = {}
		//tab[ "$pp_colour_brightness" ] = 0
		tab[ "$pp_colour_contrast" ] = 1.3
		tab[ "$pp_colour_colour" ] = 0
	 
		DrawColorModify( tab )
	
	end

end

hook.Add( "RenderScreenspaceEffects", "RenderColorModifi0R", ColorModify )
