FadeStart = 99999;
FadeColor = nil;
FadeTime = 0;
FadeDir = 1;
GameOver = false;
BootCount = 2;

function GM:HUDShouldDraw( name )
	
	local nodraw = {
		
		"CHudHealth",
		"CHudSecondaryAmmo",
		"CHudAmmo",
		"CHudBattery",
		"CHudWeaponSelection"
		
	}
	
	for _, v in pairs( nodraw ) do
	
		if( v == name ) then 
		
			return false;
			
		end
	
	end
	
	return true;

end

function GM:HUDWeaponPickedUp() end -- for when you pickup suicide gun

local function UpBootCounter()
	
	BootCount = BootCount + 1;
	
end
usermessage.Hook( "UpBootCounter", UpBootCounter );

local function DownBootCounter()
	
	BootCount = BootCount - 1;
	
end
usermessage.Hook( "DownBootCounter", DownBootCounter );

local function ResetBootCounter()
	
	BootCount = 2;
	
end
usermessage.Hook( "ResetBootCounter", ResetBootCounter );

local function CubeHUD()
	
	DrawFade();
	DrawStandings();
	DrawMyTime();
	DrawEndgame();
	DrawVoiceChat();
	DrawChatRemain();
	DrawBoots();
	
end
hook.Add( "HUDPaint", "CubeHUD", CubeHUD );

function DrawStandings()
	
	if( GameOver ) then return end
	
	surface.SetFont( "FRETTA_NOTIFY" );
	
	local tab = player.GetAll();
	table.sort( tab, function( a, b )
		
		return a:GetNWInt( "BestTime" ) < b:GetNWInt( "BestTime" );
		
	end );
	
	
	if( tab[1]:GetNWInt( "BestTime" ) >= 900 ) then return end
	
	local tex1 = string.ToMinutesSecondsMilliseconds( tab[1]:GetNWInt( "BestTime" ) ) .. "   " .. tab[1]:Nick();
	local x1, _ = surface.GetTextSize( tex1 );
	draw.RoundedBox( 4, 25, 25, x1 + 10, 40, Color( 20, 20, 20, 200 ) );
	draw.DrawText( tex1, "FRETTA_NOTIFY", 30, 30, Color( 235, 225, 46, 255 ), 0 );
	
	
	if( !tab[2] or tab[2]:GetNWInt( "BestTime" ) >= 900 ) then return end
	
	local tex2 = string.ToMinutesSecondsMilliseconds( tab[2]:GetNWInt( "BestTime" ) ) .. "   " .. tab[2]:Nick();
	local x2, _ = surface.GetTextSize( tex2 );
	draw.RoundedBox( 4, 25, 75, x2 + 10, 40, Color( 20, 20, 20, 190 ) );
	draw.DrawText( tex2, "FRETTA_NOTIFY", 30, 80, Color( 180, 180, 180, 255 ), 0 );
	
	
	if( !tab[3] or tab[3]:GetNWInt( "BestTime" ) >= 900 ) then return end
	
	local tex3 = string.ToMinutesSecondsMilliseconds( tab[3]:GetNWInt( "BestTime" ) ) .. "   " .. tab[3]:Nick();
	local x3, _ = surface.GetTextSize( tex3 );
	draw.RoundedBox( 4, 25, 125, x3 + 10, 40, Color( 20, 20, 20, 190 ) );
	draw.DrawText( tex3, "FRETTA_NOTIFY", 30, 130, Color( 170, 119, 0, 255 ), 0 );
	
end

function DrawFade()
	
	if( CurTime() - FadeStart > 0 and CurTime() - FadeStart <= FadeTime ) then
		
		local mul = ( CurTime() - FadeStart ) / FadeTime;
		local col = FadeColor;
		
		if( FadeDir == 1 ) then -- in
			
			surface.SetDrawColor( Color( col.r, col.g, col.b, 255 * mul ) );
			
		else -- out
			
			surface.SetDrawColor( Color( col.r, col.g, col.b, 255 * ( -mul + 1 ) ) );
			
		end
		
		surface.DrawRect( 0, 0, ScrW(), ScrH() );
		
	end
	
end

function DrawMyTime()
	
	if( LocalPlayer():Alive() and not GameOver and LocalPlayer():Team() != TEAM_SPECTATOR ) then
		
		surface.SetFont( "FRETTA_LARGE" );
		local t = CurTime() - StartTime;
		
		local tex1 = string.ToMinutesSecondsMilliseconds( t );
		local x1, _ = surface.GetTextSize( tex1 );
		
		draw.RoundedBox( 4, ScrW() / 2 - ( x1 / 2 ) - 5, ScrH() - 60, x1 + 10, 50, Color( 20, 20, 20, 200 ) );
		draw.DrawText( tex1, "FRETTA_LARGE", ScrW() / 2 - ( x1 / 2 ), ScrH() - 55, Color( 255, 255, 255, 255 ), 0 );
		
	end
	
end

function DrawChatRemain()
	
	local t = math.floor( CurTime() - LocalPlayer():GetNWInt( "NextSpeech" ) );
	
	if( LocalPlayer():Alive() and not GameOver and LocalPlayer():Team() != TEAM_SPECTATOR ) then
		
		if( t < 0 and t >= -5 ) then
			
			surface.SetFont( "FRETTA_LARGE" );
			local tex1 = tostring( t * -1 );
			
			local x1, _ = surface.GetTextSize( tex1 );
			
			draw.RoundedBox( 4, ScrW() - x1 - 15, ScrH() - 60, x1 + 10, 50, Color( 20, 20, 20, 200 ) );
			draw.DrawText( tex1, "FRETTA_LARGE", ScrW() - x1 - 10, ScrH() - 55, Color( 0, 200, 0, 255 ), 0 );
			
		end
		
	end
	
end

function DrawBoots()
	
	local t = BootCount;
	
	if( LocalPlayer():Alive() and not GameOver and LocalPlayer():Team() != TEAM_SPECTATOR ) then
		
		if( t > 0 ) then
			
			surface.SetFont( "FRETTA_LARGE" );
			local tex1 = tostring( t );
			
			local x1, _ = surface.GetTextSize( tex1 );
			
			draw.RoundedBox( 4, 15, ScrH() - 60, x1 + 10, 50, Color( 20, 20, 20, 200 ) );
			draw.DrawText( tex1, "FRETTA_LARGE", 20, ScrH() - 55, Color( 255, 100, 0, 255 ), 0 );
			
		end
		
	end
	
end

function DrawVoiceChat()
	
	if( LocalPlayer():Alive() and not GameOver and LocalPlayer():Team() != TEAM_SPECTATOR ) then
		
		for _, v in pairs( player.GetAll() ) do
			
			if( v != LocalPlayer() ) then
				
				local t = ( CurTime() - v:GetNWInt( "NextSpeech" ) ) / 5 * -1;
				
				if( t > 0 and t <= 1 ) then
					
					surface.SetFont( "FRETTA_SMALL" );
					local tex1 = v:Nick();
					
					local x1, y1 = surface.GetTextSize( tex1 );
					local pos = ( v:EyePos() + Vector( 0, 0, 12 ) ):ToScreen();
					
					draw.RoundedBox( 4, pos.x - ( x1 / 2 ) - 15, pos.y - 15, x1 + 30, 30, Color( 20, 20, 20, 200 * t ) );
					draw.DrawText( tex1, "FRETTA_SMALL", pos.x, pos.y - ( y1 / 2 ), Color( 0, 200, 0, 255 * t ), 1 );
					
				end
				
			end
			
		end
		
	end
	
end

function DrawEndgame()
	
	if( GameOver ) then
		
		local tab = player.GetAll();
		table.sort( tab, function( a, b )
			
			return a:GetNWInt( "BestTime" ) < b:GetNWInt( "BestTime" );
			
		end );
		
		local gold = tab[1];
		local silv = tab[2];
		local bron = tab[3];
		
		local mul = math.Clamp( ( CurTime() - FadeStart ) / FadeTime, 0, 1 );
		
		draw.DrawText( gold:Nick(), "FRETTA_HUGE", ScrW() / 2, ScrH() / 2, Color( 235, 225, 46, 255 * mul ), 1 );
		if( silv ) then
			draw.DrawText( silv:Nick(), "FRETTA_LARGE", ScrW() / 2, ScrH() / 2 + 80, Color( 180, 180, 180, 255 * mul ), 1 );
		end
		if( bron ) then
			draw.DrawText( bron:Nick(), "FRETTA_MEDIUM", ScrW() / 2, ScrH() / 2 + 140, Color( 170, 119, 0, 255 * mul ), 1 );
		end
		
	end
	
end
