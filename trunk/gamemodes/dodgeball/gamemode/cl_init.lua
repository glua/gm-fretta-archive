include('shared.lua')
include('player.lua')
include('gravgun.lua')
include('cl_postprocess.lua')

surface.CreateFont( "Trebuchet MS", 35, 600, true, false, "DBAlert" )

-- custom print center stuff reused from gmdm/again reused from ctf
local iKeepTime = 5;
local iShowTime = 1;
local iFadeTime = iKeepTime - iShowTime;
local deathTime = 0;
local fLastMessage = 0;
local fAlpha = 0;
local szMessage = nil;

function GM:HUDShouldDraw( name )

	if( name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" ) then
		return false
	end
	
	return true
end

function GM:DrawAlerts()
	if szMessage then
		if deathTime > CurTime() then
			local secondsPast = CurTime() - fLastMessage  //How many seconds since it started
			if secondsPast > iFadeTime then //were into fading out stage
				local secondsIn = secondsPast - iFadeTime //How many seconds were into fading in
				fAlpha = math.min( 255 - ( secondsIn / iShowTime * 255 ) , 255 )
			else
				fAlpha = 255
			end
			local x, y = ( ScrW() / 2), ( ScrH() / 4 )
			local alert = {}
			alert.font = "DBAlert"
			alert.pos = { x, y }
			alert.xalign = TEXT_ALIGN_CENTER
			alert.yalign = TEXT_ALIGN_TOP
			alert.color = Color( 255, 255, 255, fAlpha )
			alert.text = szMessage
			draw.TextShadow( alert, 3 )
		else
			szMessage = nil;
		end
	end
end

function GM:DrawFreeze()
	if (self.frozen) then
		surface.SetTexture(surface.GetTextureID("freezescreen"))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
end

function GM:RenderScreenspaceEffects()

	self.BaseClass:RenderScreenspaceEffects()
	
	if (self.frozen) then
		ColorModify[ "$pp_colour_addb" ]		= .10
		ColorModify[ "$pp_colour_mulb" ] 		= .50
	end
	
end

function GM:OnHUDPaint()
	GAMEMODE:DrawAlerts()
	GAMEMODE:DrawFreeze()
	
	GAMEMODE:DrawDeathNotice( 0.85, 0.04 )
	GAMEMODE:HUDDrawTargetID() 
end

function GM:Alert( str )
	szMessage = str;
	fAlpha = 255;
	fLastMessage = CurTime();
	deathTime = fLastMessage + iKeepTime;
end

usermessage.Hook("DBAlert", function( dmsg ) GAMEMODE:Alert( dmsg:ReadString() ) end)

function GM:FreezeUp( dbool )
	self.frozen = dbool;
end

usermessage.Hook("DBFreeze", function( dmsg ) GAMEMODE:FreezeUp( dmsg:ReadBool() ) end)

function GM:DBOut( dmsg )
	local victim = dmsg:ReadEntity()
	local killer = dmsg:ReadEntity()
	
	self:AddDeathNotice( victim, "prop_combine_ball", killer )
end
	
usermessage.Hook("DBOut", function( dmsg ) GAMEMODE:DBOut( dmsg ) end)  

//From GMDM

local WalkTimer = 0
local VelSmooth = 0

function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	VelSmooth = VelSmooth * 0.9 + vel:Length() * 0.1
	
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05
	
	// Roll on strafe
	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.005
	

	// Roll on steps
	if ( ply:GetGroundEntity() != NULL ) then	
	
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.0005
		angle.pitch = angle.pitch + math.sin( WalkTimer * 0.5 ) * VelSmooth * 0.001
		
	end
		
	return self.BaseClass:CalcView( ply, origin, angle, fov )

end
