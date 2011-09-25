include( "shared.lua" )
require( "datastream" )

grid_ent = NULL //The grid highligher entity

local grid_tex, grid_tex_err = Material( "models/gmaster/grid_selected" ), Material( "models/gmaster/grid_selected_error" )
local grid_texx, grid_texx_err = nil, nil
local shake, healed = 0, 0 //Shakin'n healin'
local dist = 1024 //Camera distance, REMEMBER TO SELF: IF CHANGING, CHANGE IT IN SERVER TOO!
local too_fast = false
local ptrace = {} //Part trace
local partsize = 128 //In the Gmaster menu
local bottomy = partsize + 67
local stamina_radius = 15
local stamina_x, stamina_y = 113, ScrH() - 113
local sttable2 = {}
local gm_mainmenu, gm_partpanel, gm_partbutton, gm_image_left, gm_image_right, gm_rightbutton, gm_leftbutton, gm_nametext, gm_amounttext, gm_amounttext2

function GM_Init()

	surface.CreateFont( "Trebuchet MS", 24, 800, true, false, "FHUDElement2" )
	grid_texx, grid_texx_err = grid_tex:GetMaterialTexture( "$basetexture" ), grid_tex_err:GetMaterialTexture( "$basetexture" )
	
	local stcount = 0
	
	for i = 0, 360, 2 do
		stcount = stcount + 1
		sttable2[stcount] = {}
		sttable2[stcount]["x"] = stamina_x + math.sin( math.rad( i ) ) * ( stamina_radius + 3 )
		sttable2[stcount]["y"] = stamina_y + math.cos( math.rad( i ) ) * ( stamina_radius + 3 )
		sttable2[stcount]["u"] = 0.5
		sttable2[stcount]["v"] = 0.5
	end

end

hook.Add( "Initialize", "GM_Init", GM_Init ) //Garry is going to hate me for this (hooks in a gamemode? BLASMEPHY!)

function GM_InitPostEntity()
	
	OpenGMasterMenu()
	grid_ent = ClientsideModel( "models/gmaster/select.mdl", RENDERGROUP_TRANSLUCENT ) //Using a model to eliminate depth issues
	grid_ent:SetAngles( Angle( 0, 90, 0 ) )
	grid_ent:SetPos( vector_origin )
	grid_ent:Spawn()
	grid_ent:Activate()
	
end

hook.Add( "InitPostEntity", "GM_InitPostEntity", GM_InitPostEntity )

selected_part = 1
has_part = false

function OpenGMasterMenu() //Incoming cringe-worthy hardcoded values
	
	gm_mainmenu = vgui.Create( "DFrame" )
	gm_mainmenu:SetPos( ScrW() - partsize - 36 - 16, ScrH() - partsize - 120 )
	gm_mainmenu:SetSize( partsize + 20, partsize + 106 )
	gm_mainmenu:SetTitle( "" )
	gm_mainmenu:SetVisible( true )
	gm_mainmenu:SetDraggable( false )
	gm_mainmenu:ShowCloseButton( false )
	gm_mainmenu:MakePopup()
	gm_mainmenu:SetKeyboardInputEnabled( false )
	gm_mainmenu:NoClipping( true )
	gm_mainmenu.Paint = function( pnl ) draw.RoundedBox( 4, 0, 0, pnl:GetWide(), pnl:GetTall(), Color( 0, 0, 0, 127 ) ) end
	
	gm_partpanel = vgui.Create( "DPanelList", gm_mainmenu )
	gm_partpanel:SetPos( 8, 38 )
	gm_partpanel:SetSize( partsize + 4, partsize + 4 )
	gm_partpanel:SetPadding( 2 )
	gm_partpanel:SetSpacing( 2 )
	
	gm_partbutton = vgui.Create( "DImageButton", gm_partpanel )
	gm_partbutton:SetMaterial( partlist[selected_part + 1].tex )
	gm_partbutton:SetSize( partsize, partsize )
	gm_partbutton.DoClick = function() has_part = true end
	gm_partpanel:AddItem( gm_partbutton )
	
	gm_image_left = vgui.Create( "DImage", gm_mainmenu )
	gm_image_left:SetMaterial( partlist[math.abs( math.fmod( selected_part + #partlist, #partlist ) )].tex )
	gm_image_left:SetSize( partsize / 4, partsize / 4 )
	gm_image_left:SetPos( 0, 10 + partsize )
	gm_image_left:MoveLeftOf( gm_partpanel )
	gm_image_left:SetImageColor( Color( 255, 255, 255, 200 ) )
	
	gm_image_right = vgui.Create( "DImage", gm_mainmenu )
	gm_image_right:SetMaterial( partlist[math.abs( math.fmod( selected_part + 1, #partlist ) )].tex )
	gm_image_right:SetSize( partsize / 4, partsize / 4 )
	gm_image_right:SetPos( 0, 10 + partsize )
	gm_image_right:MoveRightOf( gm_partpanel )
	gm_image_right:SetImageColor( Color( 255, 255, 255, 200 ) )
	
	--------------------------------------------------------------------------------------------------
	
	gm_leftbutton = vgui.Create( "DSysButton", gm_mainmenu )
	gm_leftbutton:SetType( "left" )
	gm_leftbutton:SetPos( 8, bottomy - 19 )
	gm_leftbutton:SetSize( 32, 32 + 16 )
	gm_leftbutton.DoClick = function()
		selected_part = math.abs( math.fmod( selected_part + #partlist - 1, #partlist ) ) //WHAT THE ACTUAL FUCK
		surface.PlaySound( "gmaster/change_part.wav" )
	end
	
	gm_rightbutton = vgui.Create( "DSysButton", gm_mainmenu )
	gm_rightbutton:SetType( "right" )
	gm_rightbutton:SetPos( partsize + 20 - 8 - 32, bottomy - 19 )
	gm_rightbutton:SetSize( 32, 32 + 16 )
	gm_rightbutton.DoClick = function()
		selected_part = math.abs( math.fmod( selected_part + 1, #partlist ) )
		surface.PlaySound( "gmaster/change_part.wav" )
	end
	
	gm_nametext = Label( partlist[selected_part + 1].name, gm_mainmenu )
	gm_nametext:SetFont( "FHUDElement2" )
	gm_nametext:SetColor( Color( 255, 255, 255 ) )
	gm_nametext:SizeToContents()
	gm_nametext:SetPos( ( partsize + 20 ) / 2 - ( gm_nametext:GetWide() / 2 ), 7 )
	
	gm_amounttext = Label( "Parts Left:", gm_mainmenu )
	gm_amounttext:SetFont( "HudSelectionText" )
	gm_amounttext:SetColor( Color( 255, 255, 0 ) )
	gm_amounttext:SizeToContents()
	gm_amounttext:SetPos( ( partsize + 20 ) / 2 - ( gm_amounttext:GetWide() / 2 ), bottomy - 8 )
	
	gm_amounttext2 = Label( LocalPlayer():GetNWInt( selected_part + 1 .. "Part", 0 ), gm_mainmenu ) //partlist[selected_part + 1].amount
	gm_amounttext2:SetFont( "HudSelectionText" )
	gm_amounttext2:SetColor( Color( 255, 255, 0 ) )
	gm_amounttext2:SizeToContents()
	gm_amounttext2:SetPos( ( partsize + 20 ) / 2 - ( gm_amounttext2:GetWide() / 2 ), bottomy - 8 + 13 )

end

function GM_RenderScreenspaceEffects()
 
	local tab = {}
	tab[ "$pp_colour_addr" ] = shake //OUCH
	tab[ "$pp_colour_addg" ] = healed //EXHALE
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
	tab[ "$pp_colour_mulb" ] = 0 
 
	DrawColorModify( tab )
end
hook.Add( "RenderScreenspaceEffects", "GM_RenderScreenspaceEffects", GM_RenderScreenspaceEffects )


local viewpos = vector_origin

function GM_Think()

	shake = shake - ( shake * math.Clamp( 10 * FrameTime(), 0, 1 ) )
	healed = healed - ( healed * math.Clamp( 10 * FrameTime(), 0, 1 ) )
	local aimvec = LocalPlayer():GetCursorAimVector()
	
	local tracedata = {}
	tracedata.start = viewpos + Vector( 0, -dist, 0 )
	tracedata.endpos = tracedata.start + ( aimvec * 5000 )
	tracedata.filter = player.GetAll()
	ptrace = util.TraceLine( tracedata )
	
	if ( ValidEntity( grid_ent ) ) then
		local selectpos = ptrace.HitPos + ptrace.HitNormal
		selectpos.x = math.Round( selectpos.x / 128 ) * 128 //Snap to grid
		selectpos.z = math.Round( selectpos.z / 128 ) * 128 //Snap to grid
		grid_ent:SetPos( selectpos )
		grid_ent:SetNoDraw( !CanPlace( LocalPlayer(), ptrace, selected_part ) )
		if ( TooClose( selectpos ) or LocalPlayer():GetNWInt( selected_part + 1 .. "Part", 0 ) < 1 ) then
			grid_tex:SetMaterialTexture( "$basetexture", grid_texx_err )
		else
			grid_tex:SetMaterialTexture( "$basetexture", grid_texx )
		end
	end
	
	gm_mainmenu:SetVisible( LocalPlayer():Team() == TEAM_GAMEMASTER and LocalPlayer():Alive() )
	
	if ( LocalPlayer():Team() == TEAM_GAMEMASTER and gm_partbutton and gm_nametext and gm_amounttext2 ) then
		
		gm_image_left:SetMaterial( partlist[math.abs( math.fmod( selected_part + #partlist - 1, #partlist ) ) + 1].tex )
		gm_image_right:SetMaterial( partlist[math.abs( math.fmod( selected_part + 1, #partlist ) ) + 1].tex )
		
		gm_partbutton:SetMaterial( partlist[selected_part + 1].tex )
		
		gm_nametext:SetText( partlist[selected_part + 1].name )
		gm_nametext:SizeToContents()
		
		gm_amounttext2:SetText( LocalPlayer():GetNWInt( selected_part + 1 .. "Part", 0 ) )
		gm_amounttext2:SizeToContents()
		
		gm_nametext:SetPos( ( partsize + 20 ) / 2 - ( gm_nametext:GetWide() / 2 ), 7 )
		gm_amounttext2:SetPos( ( partsize + 20 ) / 2 - ( gm_amounttext2:GetWide() / 2 ), bottomy - 8 + 13 )
		
	end
	
end

hook.Add( "Think", "GM_Think", GM_Think )

function GM_GUIMousePressed( mc )
		
	//print( mc )
		
	if ( mc == MOUSE_LEFT ) then
	
		if ( CanPlace( LocalPlayer(), ptrace, selected_part ) ) then //IT FINALLY FUCKING WORKS
		
			if ( !TooClose( grid_ent:GetPos() ) ) then
			
				if ( LocalPlayer():GetNWInt( selected_part + 1 .. "Part", 0 ) > 0 ) then
					datastream.StreamToServer( "PlacePart", { selected_part, LocalPlayer():GetCursorAimVector() } ) //GetCursorAimVector seems to be borked on the server
					too_fast = true //Slow down!
					timer.Simple( place_delay, function() too_fast = false end )
				else
					LocalPlayer():PrintMessage( HUD_PRINTTALK, "Ran out of parts!" )
				end
				
			else
				LocalPlayer():PrintMessage( HUD_PRINTTALK, "Cannot place parts that close to the Runners!" )
			end
			
		end
		
		if ( LocalPlayer():Team() != TEAM_GAMEMASTER ) then LocalPlayer():ConCommand( "+attack" ) RunConsoleCommand( "spec_next" ) end
		
	end
	
	if ( mc == MOUSE_RIGHT ) then
	
		has_part = false //Deselect part
		if ( LocalPlayer():Team() != TEAM_GAMEMASTER ) then LocalPlayer():ConCommand( "+attack2" ) RunConsoleCommand( "spec_prev" ) end
		
	end
	
end

hook.Add( "GUIMousePressed", "GM_GUIMousePressed", GM_GUIMousePressed )

function GM_GUIMouseReleased( mc )
		
	if ( mc == MOUSE_LEFT ) then
		if ( LocalPlayer():Team() != TEAM_GAMEMASTER ) then LocalPlayer():ConCommand( "-attack" ) end
	end
	
	if ( mc == MOUSE_RIGHT ) then
		if ( LocalPlayer():Team() != TEAM_GAMEMASTER ) then LocalPlayer():ConCommand( "-attack2" ) end
	end
	
end

hook.Add( "GUIMouseReleased", "GM_GUIMouseReleased", GM_GUIMouseReleased )

function GM:CalcView( ply, origin, angles, fov )
	
	if ( ply:Alive() ) then
		
		viewpos = origin + Vector( 0, 0, 64 ) //If the player is alive, just use the player position
		
	end
	
	if ( ValidEntity( ply:GetRagdollEntity() ) ) then //If the player isn't alive, get the ragdoll position
		viewpos = ply:GetRagdollEntity():GetPos() + Vector( 0, 0, 64 )
		if ( ValidEntity( ply:GetObserverTarget() ) ) then //If the player is spectating, use the spectator target position
			viewpos = ply:GetObserverTarget():GetPos() + Vector( 0, 0, 64 )
		end
	end

	if ( LocalPlayer():Team() == TEAM_GAMEMASTER ) then //Almost the same cam, but this time from straight on instead of slanted
	
		local view = {}
 
		view.origin = viewpos + Vector( 0, -dist, 0 )
		view.angles = ( viewpos - view.origin ):Angle()
 
		return view
		
	end
	
	local view = {}
 
	view.origin = viewpos + Vector( -64, -dist, 0 )
	view.angles = ( viewpos - view.origin ):Angle()
	view.origin = view.origin + ShakeVec() //Shake it baby!
 
	return view
 
end

function ShakeVec()
	return Vector( math.Rand( -shake, shake ), 0, math.Rand( -shake, shake ) )
end

local health_basetex = surface.GetTextureID( "hud/gmaster/health_base" )
local healthtex = surface.GetTextureID( "hud/gmaster/health" )
local helpalp = 0
local helpalpgoal = 0
local helpstring = ""

function GM_Hudpaint()
	
	stamina_x, stamina_y = 113, ScrH() - 113
	
	for _, ply in pairs( player.GetAll() ) do
	
		if ( ply:Alive() and ply:Team() == TEAM_RUNNER ) then
	
			local scrpos = ( ply:GetPos() + Vector( 0, 0, 75 ) ):ToScreen()
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetFont( "ChatFont" )
			
			local ntxtw, ntxth = surface.GetTextSize( ply:Nick() )
			surface.SetTextPos( scrpos.x - ntxtw / 2, scrpos.y - ntxth ) 
			surface.DrawText( ply:Nick() )

		end
		
	end
	
	helpalp = math.Approach( helpalp, helpalpgoal, FrameTime() * 30 )
	if ( !LocalPlayer():Alive() ) then helpalp = 0 end
	
	local helpx, helpy = ScrW() / 2, ScrH() - 170
	local helpw, helph = ScrW() * 0.9, 50
	local alpadd = math.sin( CurTime() * 8 ) * ( helpalp / 15 )
	
	if ( helpalp > 0 ) then
		draw.RoundedBox( 8 , helpx - helpw / 2, helpy - helph / 2, helpw, helph, Color( 0, 0, 0, math.Clamp( helpalp + alpadd, 0, 255 ) ) )
		draw.SimpleText( helpstring, "FRETTA_MEDIUM", helpx, helpy, Color( 255, 255, 255, math.Clamp( helpalp + alpadd, 0, 255 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	if ( !LocalPlayer():Alive() or LocalPlayer():Team() == TEAM_GAMEMASTER ) then return end
	
	local fraction = math.Clamp( 1 - ( LocalPlayer():Health() / 100 ), 0, 1 )
	local hpadd = 5 //All this math around this line will cut the health image at the fraction of the health, like in TF2
	local hptable = {}
	
	hptable[1] = {}
	hptable[1]["x"] = hpadd
	hptable[1]["y"] = ScrH() - 128 + fraction * 128 - hpadd
	hptable[1]["u"] = 0
	hptable[1]["v"] = fraction
		hptable[2] = {}
	hptable[2]["x"] = 128 + hpadd
	hptable[2]["y"] = ScrH() - 128 + fraction * 128 - hpadd
	hptable[2]["u"] = 1
	hptable[2]["v"] = fraction
		hptable[3] = {}
	hptable[3]["x"] = 128 + hpadd
	hptable[3]["y"] = ScrH() - hpadd
	hptable[3]["u"] = 1
	hptable[3]["v"] = 1
		hptable[4] = {}
	hptable[4]["x"] = hpadd
	hptable[4]["y"] = ScrH() - hpadd
	hptable[4]["u"] = 0
	hptable[4]["v"] = 1
	
	surface.SetDrawColor( 255, 255, 255, 200 )
	surface.SetTexture( health_basetex )
	surface.DrawTexturedRect( hpadd, ScrH() - 128 - hpadd, 128, 128 )
	
	surface.SetTexture( healthtex )
	surface.DrawPoly( hptable )
	
	local stamina = LocalPlayer():GetNWInt( "Stamina", 0 )
	local stamina_fraction = stamina / 10
	local stamina_angle = stamina_fraction * 3.6
	
	local sttable = {}
	
	sttable[1] = {}
	sttable[1]["x"] = stamina_x
	sttable[1]["y"] = stamina_y
	sttable[1]["u"] = 0.5
	sttable[1]["v"] = 0.5
	
	local stcount = 1
	
	for i = 0, stamina_angle, 2 do
		stcount = stcount + 1
		sttable[stcount] = {}
		sttable[stcount]["x"] = stamina_x + math.sin( math.rad( i + 180 ) ) * stamina_radius
		sttable[stcount]["y"] = stamina_y + math.cos( math.rad( i + 180 ) ) * stamina_radius
		sttable[stcount]["u"] = 0.5
		sttable[stcount]["v"] = 0.5
	end
	
	surface.SetTexture() //Reset texture
	
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawPoly( sttable2 )
	
	if ( LocalPlayer():GetNWBool( "Exhausted" ) ) then
		surface.SetDrawColor( 255, 0, 0, 200 )
	else
		surface.SetDrawColor( 255, 255, 255, 200 )
	end
	
	surface.DrawPoly( sttable )
	
end

hook.Add( "HUDPaint", "GM_Hudpaint", GM_Hudpaint )

function GM:CreateMove( cmd )
	
	if ( LocalPlayer():Alive() and LocalPlayer():Team() != TEAM_GAMEMASTER ) then
	
		cmd:SetForwardMove( cmd:GetSideMove() )
		
		local ang = 0
		local playerpos = ( LocalPlayer():GetShootPos() ):ToScreen()
		local xdiff = gui.MouseX() - playerpos.x
		local ydiff = gui.MouseY() - playerpos.y
		ang = math.Rad2Deg( math.atan2( ydiff, xdiff ) )

		if ( ang < 90 and ang > -90 ) then
			cmd:SetViewAngles( Angle( ang, 0, 0 ) )
		else
			cmd:SetViewAngles( Angle( 180 - ang, 180, 0 ) )
			cmd:SetForwardMove( -cmd:GetSideMove() )
		end
		
		cmd:SetSideMove( 0 )
		
	end
	
	if ( LocalPlayer():Team() == TEAM_GAMEMASTER ) then
		cmd:SetViewAngles( Angle( 0, 90, 0 ) )
	end
	
end

function Hidehud( name )
	for _, v in pairs{ "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo" } do
		return ( name != v )
	end
end

hook.Add( "HUDShouldDraw", "hidehud", Hidehud )

function GM:ShouldDrawLocalPlayer() 
	return ( LocalPlayer():Team() == TEAM_RUNNER )
end

function GM:HUDDrawTargetID() //Don't draw player info thingy when looking at someone (broken with 2d stuff)
     return false
end

function Help( um )
	
	local h = string.lower( um:ReadString() )
	if ( h == "lava" ) then
		helpstring = "The red stuff below you is so hot that you'll be vaporated instantly, so watch out!"
	elseif ( h == "health" ) then
		helpstring = "These powerups will give you some health, in case you lost some in a fight."
	elseif ( h == "finish" ) then
		helpstring = "This is the end of the level. You might want to go in there in case you want to go to the next level."
	elseif ( h == "launch" ) then
		helpstring = "This green stuff won't harm you: it's very bouncy! Step on it to be launched into the air!"
	elseif ( h == "sprint" ) then
		helpstring = "Press SHIFT to sprint. You should do that here, otherwise you won't make the huge jump!"
	elseif ( h == "gravity" ) then
		helpstring = "Gravity is a bitch, huh?"
	elseif ( h == "_gamemaster_" ) then
		helpstring = "You have been chosen to fill the role of the Gamemaster. Good luck!"
	else
		helpstring = "Something went wrong here. Identifier: " .. h .. ", use this informaton to bitch at Dlaor!"
	end
	
	helpalp = 200
	
	surface.PlaySound( "gmaster/message.wav" )
	
end

usermessage.Hook( "Help", Help )

function Finish( um )

	local ply = um:ReadEntity()
	local place = um:ReadChar()
	
	LocalPlayer():PrintMessage( HUD_PRINTTALK, ply:Nick() .. " made it to the end!" )
	if ( ply == LocalPlayer() ) then surface.PlaySound( "gmaster/finish.mp3" ) end
	
end

usermessage.Hook( "Finish", Finish )

function Shake( um )

	shake = um:ReadFloat()
	
end

usermessage.Hook( "Shake", Shake )

function Healed( um )

	healed = 1
	
end

usermessage.Hook( "Healed", Healed )

/*function Suffix( n ) //Thanks, Deco!
	local last_char = string.sub( tostring( n ), -1 )
	if ( string.sub( tostring( n ), -2, -2 ) == "1" ) then
		return "th"
	elseif last_char == "1" then
		return "st"
	elseif last_char == "2" then
		return "nd"
	elseif last_char == "3" then
		return "rd"
	else
		return "th"
	end
end*/