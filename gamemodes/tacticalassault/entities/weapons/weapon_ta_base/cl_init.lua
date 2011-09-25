include('shared.lua')

SWEP.PrintName			= "Tactical Assault Weapon Base"	
SWEP.Slot				= 0							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot
SWEP.DrawAmmo			= true						// Should draw the default HL2 ammo counter?
SWEP.DrawCrosshair		= false 						// Should draw the default crosshair?
SWEP.DrawWeaponInfoBox	= true						// Should draw the weapon info box?
SWEP.BounceWeaponIcon   	= false						// Should the weapon icon bounce?
SWEP.SwayScale			= 1.2							// The scale of the viewmodel sway
SWEP.BobScale			= 1.2							// The scale of the viewmodel bob

SWEP.RenderGroup 			= RENDERGROUP_OPAQUE

local curpos = Vector(0,0,0)
local curang = Angle(0,0,0)
local iron_lerp = 0

local mul = 1.6

function SWEP:GetViewModelPosition(pos, ang)
	
	if (self.Owner:KeyDown(IN_SPEED)) then
		curpos.z = math.Approach( curpos.z, self.RunPos.z, mul / ( self.RunAng.p / self.RunPos.z) )
		curang.p= math.Approach( curang.p, self.RunAng.p, mul )
	else
		curpos.z = math.Approach( curpos.z, 0, mul / ( self.RunAng.p / self.RunPos.z) )
		curang.p = math.Approach( curang.p, 0, mul)
	end
	
	pos = pos + curpos
	ang = ang + curang
	
	if self.Weapon:GetNWBool("Ironsights") then
		iron_lerp = math.Approach(iron_lerp,100,4)		
	else		
		iron_lerp = math.Approach(iron_lerp,0,4)
	end
	
	pos = LerpVector(iron_lerp / 100,pos,pos + self.IronSightsPos) 
	ang = LerpAngle(iron_lerp / 100,ang,ang + self.IronSightsAng)
	
	return pos, ang
end
