FrozenOverlay = false;
StartTime = 0;

local function Fade( um )
	
	local col = um:ReadVector();
	col = Color( col.x, col.y, col.z, 255 );
	local t = um:ReadShort();
	local dir = um:ReadShort();
	
	FadeStart = CurTime();
	FadeColor = col;
	FadeTime = t;
	FadeDir = dir;
	
end
usermessage.Hook( "Fade", Fade );

local function StartFlashFlame()
	
	StartFlashEffect = CurTime();
	
end
usermessage.Hook( "FlashFlame", StartFlashFlame );

local function ImFalling()
	
	ImFalling = true;
	
end
usermessage.Hook( "ImFalling", ImFalling );

local function PlayClSound( um )
	
	surface.PlaySound( Sound( um:ReadString() ) );
	
end
usermessage.Hook( "PlayClSound", PlayClSound );

local function msgGameOver()
	
	surface.PlaySound( Sound( "weapons/mortar/mortar_explode2.wav" ) );
	GameOver = true;
	
end
usermessage.Hook( "msgGameOver", msgGameOver );

local function ResetVars()
	
	StartFlashEffect = 0;
	ImFalling = false;
	
end
usermessage.Hook( "ResetVars", ResetVars );

local function SetViewLocation( um )
	
	local vec = um:ReadVector();
	local ang = um:ReadAngle();
	
	if( vec == Vector( 0, 0, 0 ) ) then
		
		CamOverridePos = nil;
		
	else
		
		CamOverridePos = vec;
		
	end
	
	if( ang == Vector( 0, 0, 0 ) ) then
		
		CamOverrideAng = nil;
		
	else
		
		CamOverrideAng = ang;
		
	end
	
end
usermessage.Hook( "SetViewLocation", SetViewLocation );

local function FrozenOverlayOn()
	
	FrozenOverlay = true;
	
end
usermessage.Hook( "FrozenOverlayOn", FrozenOverlayOn );

local function FrozenOverlayOff()
	
	FrozenOverlay = false;
	
end
usermessage.Hook( "FrozenOverlayOff", FrozenOverlayOff );

local function SetStartTime()
	
	local t = CurTime();
	StartTime = t;
	
end
usermessage.Hook( "SetStartTime", SetStartTime );