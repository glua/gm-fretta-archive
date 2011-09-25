if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	AddCSLuaFile( "cl_init.lua" );
	
	SWEP.HoldType				= "ar2";
end

SWEP.Base						= "as_swep_base";

SWEP.CrosshairUnscoped			= false;
SWEP.CrosshairInScope			= false;
SWEP.IronsightAccuracy			= 100.0;
SWEP.IronsightDelayFOV			= true;
SWEP.IronsightTime				= 0.5;