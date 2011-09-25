
include( 'shared.lua' )
include( 'tables.lua' )
include( 'cl_hud.lua' )
include( 'cl_selectscreen.lua' )
include( 'cl_postprocess.lua' )
include( 'powerups.lua' )

function IncludePowerups()

	local Folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.FindInLua( Folder.."/gamemode/powerups/*.lua" ) ) do
	
		include( Folder.."/gamemode/powerups/"..d )
		
	end

end

IncludePowerups()

function GM:Initialize()

	self.BaseClass:Initialize()
	
	WindVector = Vector( math.random(-10,1), math.random(-10,10), 0 )
	ScreenPos = { x = ScrW()/2, y = ScrH()/2 }
	
	surface.CreateFont( "Graffiare", 50, 450, true, false, "JJNotice" )
	surface.CreateFont( "Graffiare", 22, 450, true, false, "JJPlayer" )

end

function GM:OnHUDPaint()

	if LocalPlayer():Alive() then
	
		local pos = ( LocalPlayer():GetPos() + Vector( 0, 0, 85 + math.sin( CurTime() * 5 ) * 5 ) ):ToScreen()
	
		draw.SimpleTextOutlined( "v", "JJPlayer", pos.x, pos.y, 
			Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10) ) 
	
	end
	
	if GAMEMODE.Notice then
	
		draw.SimpleTextOutlined( GAMEMODE.Notice.Text, "JJNotice", ScrW() * 0.50, GAMEMODE.Notice.Pos, 
			GAMEMODE.Notice.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 10, 10, 10, GAMEMODE.Notice.Alpha ) ) 
	
		if GAMEMODE.Notice.Duration < CurTime() then
			
			if GAMEMODE.Notice.Alpha < 2 then
				
				if GAMEMODE.Notice.Color.a < 2 then
					GAMEMODE.Notice = nil
				else
					GAMEMODE.Notice.Color.a = GAMEMODE.Notice.Color.a - 2
				end
				
			else
			
				GAMEMODE.Notice.Alpha = GAMEMODE.Notice.Alpha - 2
				
			end
			
			return
			
		elseif GAMEMODE.Notice.Alpha < 255 then
		
			GAMEMODE.Notice.Alpha = math.Clamp( GAMEMODE.Notice.Alpha + 2, 2, 255 ) 
			GAMEMODE.Notice.Color.a = math.Clamp( GAMEMODE.Notice.Color.a + 2, 2, 255 )
				
		end
		
	end
	
end

function SetHUDNotice( msg )

	if GAMEMODE.Notice then return end

	GAMEMODE.Notice = {}
	
	GAMEMODE.Notice.Text = msg:ReadString()
	GAMEMODE.Notice.Duration = CurTime() + msg:ReadShort()
	GAMEMODE.Notice.Color = Color( msg:ReadShort(), msg:ReadShort(), msg:ReadShort(), 0 )
	GAMEMODE.Notice.Alpha = 0
	GAMEMODE.Notice.Pos = ScrH() * 0.88
	
end
usermessage.Hook( "Notice", SetHUDNotice )

function GM:HUDShouldDraw( name )

	if GAMEMODE.ScoreboardVisible then return false end
	
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end 
  	end 
	
	if name == "CHudDamageIndicator" and not LocalPlayer():Alive() then
		return false
	end
	
	return true
	
end

function GM:CreateMove( cmd )

	if LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():Team() == TEAM_UNASSIGNED then return end

	ScreenPos.x = math.Clamp( ScreenPos.x + cmd:GetMouseX() / 5, 0, ScrW() )
	ScreenPos.y = math.Clamp( ScreenPos.y + cmd:GetMouseY() / 5, 0, ScrH() )

	local mpos = Vector( ScreenPos.x, ScreenPos.y, 0 )
	local ppos = Vector( ScrW() / 2, ScrH() / 2, 0 )
	
	local aimpos = gui.ScreenToVector( ScreenPos.x, ScreenPos.y )
	local plypos = LocalPlayer():GetShootPos():ToScreen()
	local centerpos = gui.ScreenToVector( plypos.x, plypos.y ) // this is slightly off....
	local aim = ( aimpos - centerpos ):Normalize():Angle()
	
	if ( mpos.x < ppos.x ) then	
	
		aim.yaw = -90
		cmd:SetForwardMove( cmd:GetSideMove() * -1 )
	
	else		
	
		aim.yaw = 90
		cmd:SetForwardMove( cmd:GetSideMove() )
	
	end
	
	cmd:SetViewAngles( aim )
	cmd:SetSideMove( 0 )
	
end

function GM:HUDWeaponPickedUp()

end

function GM:HUDDrawPickupHistory()

end

local function TeamColorString( t )

	if t == TEAM_RED then
		return "Red"
	else
		return "Blue"
	end

end

local function RecvFlagAction( message )

	local pl = message:ReadEntity()
	local ateam = message:ReadShort()
	local vteam = message:ReadShort()
	local action = message:ReadString()
	
	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	
	pnl:AddText( pl )
	pnl:AddText( action .. " the" )
	pnl:AddText( TeamColorString( vteam )  .. " Flag", team.GetColor( vteam ) );
	
	g_DeathNotify:AddItem( pnl )
	
end

usermessage.Hook( "PlayerFlagAction", RecvFlagAction )

local function RecvFlagScoreReturn( message )

	local ateam = message:ReadShort()
	local action = message:ReadString()

	local pnl = vgui.Create( "GameNotice", g_DeathNotify )
	
	pnl:AddText( "The" )
	pnl:AddText( TeamColorString( ateam )  .. " Flag", team.GetColor( ateam ) )
	pnl:AddText( "was " .. action )
	
	g_DeathNotify:AddItem( pnl )
	
end

usermessage.Hook( "PlayerFlagScoreReturn", RecvFlagScoreReturn )

function GM:HUDDrawTargetID()

end
