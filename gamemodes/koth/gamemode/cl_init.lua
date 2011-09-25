include( 'shared.lua' )
include( 'cl_postprocess.lua' ) 
include( 'cl_hud.lua' )

function GM:Initialize( )	

	self.BaseClass:Initialize()
	
	HeartBeat = 0
	
	surface.CreateFont( "coolvetica", 24, 600, true, false, "HillText" )	
	surface.CreateFont( "Tahoma", 14, 500, true, false, "HudText" )
	surface.CreateFont( "DeadPostMan", 36, 400, true, false, "KOTHNotice" )

end

function GM:Think()

	self.BaseClass:Think()
	
	if LocalPlayer():Alive() and LocalPlayer():Health() <= 25 and LocalPlayer():Team() != TEAM_SPECTATOR and HeartBeat < CurTime() then
	
		local scale = math.Clamp( LocalPlayer():Health() / 25, 0, 1 )
		HeartBeat = CurTime() + 0.5 + scale * 1.5
		
		LocalPlayer():EmitSound( Sound( "koth/heartbeat.wav" ), 100, 150 - scale * 50 )
		
	end
	
end

function GM:OnHUDPaint()
	
	if not LocalPlayer():Alive() then return end
	
	local pos = LocalPlayer():GetNetworkedVector( "hill", Vector(0,0,0) ) + Vector(0,0,15)
	local dist = LocalPlayer():GetPos():Distance( pos )
	
	if dist < 150 then return end
	
	local hillowner = LocalPlayer():GetNWInt( "hillowner", 0 )
	local sc = pos:ToScreen()
	local add = TimedSin( 1, 0, 18, 0 )
	local teamcol = team.GetColor( hillowner )
	local col = Color( teamcol.r, teamcol.g, teamcol.b, 255 )
	
	if sc.visible then
	
		local crownsize = ScrW() * 0.03
		dist = math.Clamp( dist, 0, 800 )
		col.a = 255 * ( dist / 800 )
		
		surface.SetTexture( surface.GetTextureID( "kothcrown" ) )
		surface.SetDrawColor( col.r, col.g, col.b, col.a )
		surface.DrawTexturedRect( sc.x - crownsize, sc.y - crownsize, crownsize * 2, crownsize * 2 )
	
	end
	
	if GAMEMODE.Notice then
	
		draw.SimpleTextOutlined( GAMEMODE.Notice.Text, "KOTHNotice", ScrW() * 0.50, GAMEMODE.Notice.Pos + math.sin( CurTime() * 3 ) * ( ScrH() * 0.02 ), 
			GAMEMODE.Notice.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color( 10, 10, 10, GAMEMODE.Notice.Alpha ) ) 
	
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
			
		else
			if GAMEMODE.Notice.Alpha < 255 then
				GAMEMODE.Notice.Alpha = math.Clamp( GAMEMODE.Notice.Alpha + 2, 2, 255 ) 
				GAMEMODE.Notice.Color.a = math.Clamp( GAMEMODE.Notice.Color.a + 2, 2, 255 )
			end
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
	GAMEMODE.Notice.Pos = ScrH() * 0.70
	
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

function GM:HUDWeaponPickedUp()

end

function GM:HUDDrawPickupHistory()

end


