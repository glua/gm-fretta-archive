// Includes
include( "shared.lua" );
include( "skin.lua" );
include( "vgui/vgui_loadout.lua" );
include( "vgui/vgui_messagecenter.lua" );

FONT_SCALE = ( ScrH() / 720 );

GM.HudSkin = "KillTehBreen"

// Fonts
surface.CreateFont( "csd", 64 * FONT_SCALE, 500, true, true, "AsCSKillIcons" );
surface.CreateFont( "28 days later", 60 * FONT_SCALE, 500, true, true, "As28Days" );
surface.CreateFont( "28 days later", 40 * FONT_SCALE, 500, true, false, "As28DaysSmall", false, false );

// Weapons
killicon.AddFont( "weapon_as_xm1014", "AsCSKillIcons", "B", Color( 200, 200, 200, 255 )  );
killicon.AddFont( "weapon_as_ak47", "AsCSKillIcons", "b", Color( 200, 200, 200, 255 )  );
killicon.AddFont( "weapon_as_m4carbine", "AsCSKillIcons", "w", Color( 200, 200, 200, 255 )  );
killicon.AddFont( "weapon_as_spas12", "HL2MPTypeDeath", "0", Color( 200, 200, 200, 255 ) );
killicon.AddFont( "weapon_as_revolver", "HL2MPTypeDeath", ".", Color( 200, 200, 200, 255 ) );
killicon.AddFont( "weapon_as_mp7", "HL2MPTypeDeath", "/", Color( 200, 200, 200, 255 ) );
killicon.AddFont( "weapon_as_uspmatch", "HL2MPTypeDeath", "-", Color( 200, 200, 200, 255 ) );

// HUD icons
material_Protect = Material( "HUD/assassination/vip_protect" );
material_Defend = Material( "HUD/assassination/vip_defendextraction" );
material_ExtractionPoint = Material( "HUD/assassination/vip_extractionpoint" );



function GM:InitPostEntity()
	
	// create message center
	GAMEMODE.HudMessagePanel = vgui.Create( "AsMessageCenter" );
	
	self.BaseClass:InitPostEntity();
end

function GM:PrintCenter( text )
	GAMEMODE.HudMessagePanel:ShowBasicMessage( text );
end

function GM:PrintBreen( player )
	GAMEMODE.HudMessagePanel:Clear();
	
	if( LocalPlayer() && LocalPlayer():Team() == TEAM_COMBINE ) then
		if( LocalPlayer() == player ) then
			GAMEMODE.HudMessagePanel:AddText( "Get to safety with your team" );
		else
			GAMEMODE.HudMessagePanel:AddText( "Escort " );
			GAMEMODE.HudMessagePanel:AddPlayer( player );
			GAMEMODE.HudMessagePanel:AddText( " to safety" );
		end
	else
		GAMEMODE.HudMessagePanel:AddText( "Find and kill Dr Breen" );
	end
end
usermessage.Hook( "OurBreen", function( um ) GAMEMODE:PrintBreen( um:ReadEntity() ) end );

// Render sprite above Breen's head.
function GM:RenderScene( ViewOrigin, ViewAngles )

	local lp = LocalPlayer();
	
	if( IsValid( lp ) ) then
				
		local tn = lp:Team();
		local breen = GetGlobalEntity( "Breen" );
		
		if( IsValid( breen ) && lp != breen && ( tn == TEAM_COMBINE || tn == TEAM_SPECTATOR ) ) then // then we can draw breen's sprite
			render.SetMaterial( material_Protect );
			render.DrawSprite( breen:GetPos() + Vector( 0, 0, 85 ), 32, 32, color_white );
		end
		
	end
	
end

// Draw HUD textures
function GM:DrawHUDTextures()

	local lp = LocalPlayer();
	
	if( IsValid( lp ) ) then
		
		local tn = lp:Team();
		
		local pos = GetGlobalVector( "ExPoint_Pos", Vector( 0, 0, 0 ) );
		local lpos = pos:ToScreen();
		
		surface.SetDrawColor( 255, 255, 255, 255 );
			
		if( tn == TEAM_COMBINE || lp:IsObserver() ) then // draw extraction point
			surface.SetMaterial( material_ExtractionPoint );
		else // draw "defend"
			surface.SetMaterial( material_Defend );
		end
			
		surface.DrawTexturedRect( math.Clamp( lpos.x, 0, ScrW()-90 ), math.Clamp( lpos.y, 0, ScrH() - 45 ), 90, 45 );
		
	end
	
end
hook.Add( "HUDPaint", "VIP_DoExtractionHUD", function() if( GAMEMODE ) then GAMEMODE:DrawHUDTextures() end end );


local function PrintDeathLocal( message )

	local victim 	= message:ReadEntity();
	local inflictor	= message:ReadString();
	local attacker 	= message:ReadEntity();
			
	if( attacker && attacker:IsValid() && attacker == LocalPlayer() && victim && victim:IsValid() && !victim:IsBreen() ) then
		GAMEMODE.HudMessagePanel:Clear();
		GAMEMODE.HudMessagePanel:AddText( "You killed " );
		GAMEMODE.HudMessagePanel:AddPlayer( victim );
	elseif( attacker && attacker:IsValid() && victim && victim:IsValid() && victim == LocalPlayer() ) then
		GAMEMODE.HudMessagePanel:Clear();
		GAMEMODE.HudMessagePanel:AddText( "You were killed by " );
		GAMEMODE.HudMessagePanel:AddPlayer( attacker );
	end
	
	GAMEMODE:AddDeathNotice( victim, inflictor, attacker )	

end
	
usermessage.Hook( "PlayerKilledByPlayer", PrintDeathLocal )


