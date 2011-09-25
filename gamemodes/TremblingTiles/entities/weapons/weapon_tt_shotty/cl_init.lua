
include( "shared.lua" );


SWEP.PrintName			= "Shotgun";
SWEP.Slot				= 0;
SWEP.SlotPos			= 10;
SWEP.DrawAmmo			= false;
SWEP.DrawCrosshair		= true;
SWEP.DrawWeaponInfoBox	= false;
SWEP.BounceWeaponIcon   = false;
SWEP.SwayScale			= 1.0;
SWEP.BobScale			= 1.0;

SWEP.RenderGroup 		= RENDERGROUP_OPAQUE;

SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" );
SWEP.SpeechBubbleLid	= surface.GetTextureID( "gui/speech_lid" );

function SWEP:DrawHUD()
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
end

function SWEP:PrintWeaponInfo( x, y, alpha )
end


function SWEP:FreezeMovement()
	return false
end


function SWEP:ViewModelDrawn()
end
