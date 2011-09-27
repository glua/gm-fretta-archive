if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	AddCSLuaFile( "cl_init.lua" );
end

SWEP.Base						= "as_swep_base";
	
SWEP.HoldType				= "ar2";

SWEP.CrosshairUnscoped			= false;
SWEP.CrosshairInScope			= false;
SWEP.IronsightAccuracy			= 100.0;
SWEP.IronsightDelayFOV			= true;
SWEP.IronsightTime				= 0.5;

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end