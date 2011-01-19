-- Includes
include( "shared.lua" );
include( "cl_postprocessing.lua" );

// These are our kill icons
local Color_Icon = Color( 200, 200, 200, 255 ) 

killicon.AddFont( "gmdm_pistol", "HL2MPTypeDeath", "-", Color_Icon )
killicon.AddFont( "gmdm_smg", "HL2MPTypeDeath", "/", Color_Icon )
killicon.AddFont( "gmdm_rail", "HL2MPTypeDeath", "2", Color_Icon )
killicon.AddFont( "gmdm_shotgun", "HL2MPTypeDeath", "0", Color_Icon )
killicon.AddFont( "rpg_rocket", "HL2MPTypeDeath", "3", Color_Icon )
killicon.AddFont( "gmdm_crossbow", "HL2MPTypeDeath", "1", Color_Icon )
killicon.AddFont( "flechette_shrapnel", "HL2MPTypeDeath", "1", Color_Icon )
killicon.AddFont( "flechette_bolt", "HL2MPTypeDeath", "1", Color_Icon )
killicon.AddFont( "env_explosion", "HL2MPTypeDeath", "*", Color_Icon )
killicon.AddFont( "item_tripmine", "HL2MPTypeDeath", "*", Color_Icon )
killicon.AddFont( "gmdm_tripmine", "HL2MPTypeDeath", "*", Color_Icon )
killicon.AddFont( "smg_grenade", "HL2MPTypeDeath", "7", Color_Icon )
killicon.AddFont( "grenade_electricity", "HL2MPTypeDeath", "4", Color_Icon )
killicon.AddFont( "gmdm_electricity_nades", "HL2MPTypeDeath", "4", Color_Icon )
killicon.AddFont( "gmdm_crowbar", "HL2MPTypeDeath", "6", Color_Icon )

// Fonts
surface.CreateFont( "DeadPostMan", 19, 700, true, false, "GMDM_DPM_Medium" )
surface.CreateFont( "DeadPostMan", 19, 700, true, false, "GMDM_DPM_Medium_Shadow", true )
surface.CreateFont( "DeadPostMan", 28, 700, true, false, "GMDM_DPM_Center", true )

local iKeepTime = 4;
local fLastMessage = 0;
local fAlpha = 0;
local szMessage = "";

function GM:PrintCenterMessage( )
	if( fLastMessage + iKeepTime < CurTime() and fAlpha > 0) then
		fAlpha = fAlpha - (FrameTime()*200)
	end
	
	local timeDif = CurTime() - fLastMessage;
	
	if( fAlpha > 0 ) then
		local gB = math.Clamp( timeDif * 400, 0, 255 );
		draw.SimpleTextOutlined( szMessage, "GMDM_DPM_Center", ScrW()/2, ScrH()*0.8, Color( 255, gB, gB, math.Clamp( fAlpha, 0, 255 ) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, math.Clamp( fAlpha, 0, 255 ) ) );
	end
end

function GM:AddCenterMessage( message )
	fLastMessage = CurTime();
	szMessage = message;
	fAlpha = 255;
end

function ReceiveCenterMessage( usrmsg )
	fLastMessage = CurTime();
	szMessage = usrmsg:ReadString();	
	fAlpha = 255;
end
usermessage.Hook( "gmdm_printcenter", ReceiveCenterMessage );

function GM:GetMotionBlurValues( x, y, fwd, spin )

	if( ValidEntity( LocalPlayer() ) and ( !LocalPlayer():IsOnGround() or LocalPlayer():KeyDown( IN_SPEED ) )) then
		fwd = fwd * 5
	end
	
	return x, y, fwd, spin
	
end

function GM:HUDPaint()
	self:PrintCenterMessage();
	
	self.BaseClass:HUDPaint();
end