include( 'skin.lua' )
include( 'shared.lua' )
include( 'cl_postprocess.lua' );
include( 'cl_scores.lua' );
include( 'cl_deathnotice.lua' );

-- used for screenscaling
screenScale = ( ScrW() / 1280 )

GM.HudSkin = "CTFSkin";

-- fonts
surface.CreateFont( "csd", 40 * screenScale, 500, true, false, "CS_HUDIcons" )
surface.CreateFont( "Trebuchet MS", 19 * screenScale, 700, true, false, "TrebBoldKillMsg", true, false )
surface.CreateFont( "Trebuchet MS", 24 * screenScale, 700, true, false, "TrebBold" )
surface.CreateFont( "Trebuchet MS", 32 * screenScale, 700, true, false, "TrebBoldLarge" )

-- pre def colours
colour_orangehud = Color( 255, 128, 0 );

-- custom print center stuff reused from gmdm
local iKeepTime = 3;
local fLastMessage = 0;
local fAlpha = 0;
local szMessage = "";

GM.DeathMessagePanel = nil;
function GM:InitializeClient()

end

function GM:PrintCenterMessage( )
	if( fLastMessage + iKeepTime < CurTime() and fAlpha > 0) then
		fAlpha = fAlpha - (FrameTime()*200)
	end
	
	if( fAlpha > 0 ) then
		GAMEMODE:SimpleTextShadow( szMessage, "TrebBoldLarge", ScrW()/2, ScrH()/4, Color( 255, 255, 255, math.Clamp( fAlpha, 0, 255 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
	end
end

function GM:AddCenterMessage( message )
	Msg( "Got message: " .. message .. "\n" );
	fLastMessage = CurTime();
	szMessage = message;
	fAlpha = 255;
end

function ReceiveCenterMessage( usrmsg )
	local message = usrmsg:ReadString();
	
	GAMEMODE:AddCenterMessage( message );	
end
usermessage.Hook( "gmdm_printcenter", ReceiveCenterMessage );

function GM:DrawHUDScores()

	local sc = screenScale;
	draw.RoundedBox( 4, ScrW()/2 - ( 150 * sc ), 20, 300 * sc, 50 * sc, Color( 0, 0, 0, 150 ) )
	
	local tr_col = team.GetColor( TEAM_RED );
	surface.SetDrawColor( tr_col.r, tr_col.g, tr_col.b, 100 );
	surface.DrawRect( ( ScrW()/2 ) - ( 66 * sc ), 20 + ( 2.5 * sc ), 65 * sc, 45 * sc );
	
	draw.SimpleText( tostring( team.GetScore( TEAM_RED ) ), "TrebBoldLarge", ( ScrW()/2 ) - ( 76 * sc ), 20 + ( 25 * sc ), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

	local tb_col = team.GetColor( TEAM_BLUE );
	surface.SetDrawColor( tb_col.r, tb_col.g, tb_col.b, 100 );
	surface.DrawRect( ( ScrW()/2 ) + ( 2 * sc ), 20 + ( 2.5 * sc ), 65 * sc, 45 * sc );	
	
	draw.SimpleText( tostring( team.GetScore( TEAM_BLUE ) ), "TrebBoldLarge", ( ScrW()/2 ) + ( 77 * sc ), 20 + ( 25 * sc ), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

end

function GM:GetHealthColor( health, armor )

	if( !armor ) then
		armor = false
	end
	
	local sine_curtime = math.sin( CurTime() * 3 );
	
	if( health > 75 ) then
		return Color( 150, 255, 150 );
	elseif( health < 25 and !armor ) then
		return Color( ( sine_curtime + 1  ) * 75 + 50, 0, 0 );
	else
		return colour_white
	end
end

GM.LastTimeLeft = 0;
function GM:GetTimeColor( timeleft )

	local return_col = Color( 255, 255, 255 );
	local sine_curtime = math.sin( CurTime() * 3 );
	
	if( math.Round( timeleft ) != math.Round( GAMEMODE.LastTimeLeft ) ) then
		GAMEMODE:DoTimeSound( math.Round( timeleft ) );
	end
	
	if( timeleft < 60 ) then
		return_col = Color( ( sine_curtime + 1  ) * 75 + 50, 0, 0 );
	end

	GAMEMODE.LastTimeLeft = timeleft;
	return return_col;
end

function GM:DoTimeSound( timeleft )

	local doSound = false;
	
	if( timeleft < 21 ) then -- this looks a bit shitty because i might expand on it to be slower at greater times etc
		doSound = true;
	end
	
	if( doSound ) then
		LocalPlayer():EmitSound( "Buttons.snd15" );
	end
end

function GM:SimpleTextShadow( text, font, x, y, color, al, aly )
	draw.SimpleText( text, font, x + 1, y+1, Color(0,0,0), al, aly )
	draw.SimpleText( text, font, x, y, color, al, aly )
end

function GM:GetReserveAmmo( weap )

	local atype = weap:GetPrimaryAmmoType();
	return LocalPlayer():GetAmmoCount( atype );
	
end

function GM:DrawHUDElements()

	if( LocalPlayer() ) then
	
		local offset = 0; -- offset for time left
		local colour_orangehud = team.GetColor( LocalPlayer():Team() );
		local localplayer = LocalPlayer()
		
		if( LocalPlayer():IsObserver() and IsValid( LocalPlayer():GetObserverTarget() ) and LocalPlayer():GetObserverTarget():IsPlayer() and LocalPlayer():GetObserverTarget() != LocalPlayer() ) then
			colour_orangehud = team.GetColor( LocalPlayer():GetObserverTarget():Team() );
			localplayer = LocalPlayer():GetObserverTarget()
		end
	
		if( localplayer:Alive() and GetGlobalBool( "interval", false ) == false and localplayer:Team() != TEAM_SPECTATOR and localplayer:Team() != TEAM_UNASSIGNED ) then -- vitals
			offset = 280;
			
			GAMEMODE:SimpleTextShadow( "F", "CS_HUDIcons", 20, ScrH()-45, colour_orangehud, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			GAMEMODE:SimpleTextShadow( tostring( LocalPlayer():Health() ), "TrebBoldLarge", 20 + 40 * screenScale, ScrH()-45 - (5+screenScale), GAMEMODE:GetHealthColor( LocalPlayer():Health() ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

			GAMEMODE:SimpleTextShadow( "E", "CS_HUDIcons", 20 + 140 * screenScale, ScrH()-45, colour_orangehud, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			GAMEMODE:SimpleTextShadow( tostring( LocalPlayer():Armor() ), "TrebBoldLarge", 20 + 180 * screenScale, ScrH()-45 - (5+screenScale), GAMEMODE:GetHealthColor( LocalPlayer():Armor(), true ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		end
		
		local timeleft = ( GAMEMODE.GameLength * 60 ) - CurTime();
		
		if( timeleft < 0 ) then
			timeleft = 0;
		end
		
		GAMEMODE:SimpleTextShadow( "G", "CS_HUDIcons", 20 + offset * screenScale, ScrH()-45, colour_orangehud, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		GAMEMODE:SimpleTextShadow( string.ToMinutesSeconds( timeleft ), "TrebBoldLarge", 20 + ( offset + 40 ) * screenScale, ScrH()-45 - (5+screenScale), GAMEMODE:GetTimeColor( timeleft ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
		
		local Weapon = localplayer:GetActiveWeapon()
		
		if( Weapon and Weapon:IsValid() and GetGlobalBool( "interval", false ) == false ) then
			if( Weapon:Clip1() > -1 ) then
				GAMEMODE:SimpleTextShadow( Weapon:Clip1(), "TrebBoldLarge", ScrW() - 20, ScrH()-45 - (5+screenScale), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			elseif( Weapon.CustomSecondaryAmmo ) then
				GAMEMODE:SimpleTextShadow( Weapon:CustomAmmoCount(), "TrebBoldLarge", ScrW() - 20, ScrH()-45 - (5+screenScale), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			end
			
			if( Weapon.MultipleFiremodes and Weapon.Primary.FireModeName ) then
				GAMEMODE:SimpleTextShadow( Weapon.Primary.FireModeName, "TrebBold", ScrW() - 20, ScrH()-45 - (30+screenScale), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			end
		end
	end
	
end

function GM:DrawFlagLocations()

	if( LocalPlayer() ) then
	
		for k, v in pairs( ents.FindByClass( "ctf_teamflag" ) ) do
			if( v:IsValid() ) then
				v:DrawHUD();
			end
		end

	end
end

function GM:DrawSpawnProtection()
	if( LocalPlayer() and LocalPlayer():IsValid() and LocalPlayer():GetNetworkedBool( "protected", false ) == true ) then
		GAMEMODE:SimpleTextShadow( "Spawn protection is active.", "TrebBoldLarge", ScrW()/2, ScrH()*0.75, Color( 0, 176, 176, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
	end
end

function GM:DrawRespawnTime()
	if( LocalPlayer() and LocalPlayer():IsValid() and !LocalPlayer():Alive() ) then
		local respawnTime = LocalPlayer():GetNetworkedFloat( "respawnTime" );
		local timeLeft = respawnTime - CurTime();
		
		if( respawnTime == 0 ) then
			GAMEMODE:SimpleTextShadow( "Get ready to spawn...", "TrebBoldLarge", ScrW()/2, ScrH()/2, Color( 176, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );					
		elseif( timeLeft > 0 ) then
			GAMEMODE:SimpleTextShadow( "Respawn in " .. math.Round( timeLeft ), "TrebBoldLarge", ScrW()/2, ScrH()/2, Color( 176, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );			
		else
			GAMEMODE:SimpleTextShadow( "Press PRIMARY ATTACK to respawn", "TrebBoldLarge", ScrW()/2, ScrH()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );	
		end
	end
end

function GM:HUDPaint()

	GAMEMODE:DrawHUDScores()
	GAMEMODE:DrawHUDElements()
	GAMEMODE:DrawFlagLocations()
	GAMEMODE:PrintCenterMessage();
	GAMEMODE:DrawSpawnProtection();
	GAMEMODE:DrawRespawnTime()
	
	self.BaseClass:HUDPaint()
end

function GM:HUDShouldDraw( name )

	if( name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" ) then
		return false
	end
	
	return true
end