
AddCSLuaFile( "shared.lua" )

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

if ( CLIENT ) then

SWEP.PrintName			= "Hidifier mk3"		// 'Nice' Weapon name (Shown on HUD)
SWEP.Instructions		= "Stop moving to begin to cloak."
SWEP.Slot				= 2						// Slot in the weapon selection menu
SWEP.SlotPos			= 10					// Position in the slot
SWEP.DrawAmmo			= false					// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 					// Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= true					// Should draw the weapon info box
SWEP.BounceWeaponIcon   = true  				// Should the weapon icon bounce?
SWEP.SwayScale			= 1.0					// The scale of the viewmodel sway
SWEP.BobScale			= 1.0					// The scale of the viewmodel bob
SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" )

end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.AnimPrefix		= "python"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1				// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1 				// Size of a clip
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"

function SWEP:Think()

	if !self.Owner then return end
	if !self.Owner:Alive() then return end
	
	if self.Owner:GetVelocity() == Vector(0,0,0) then
		local fade = 25
		self.Owner:SetMaterial( "models/debug/debugwhite" )
		self.Owner:SetColor( 0, 0, 0, fade )
	else
		self.Owner:SetMaterial( "models/debug/debugwhite" )
		self.Owner:SetColor( 0, 0, 0, 125 )
	end

end

function SWEP:Holster()

	self.Owner:SetColor( 255, 255, 255, 255 )
	self.Owner:SetMaterial( "" )
	
	local ed = EffectData()
	ed:SetOrigin( self.Owner:GetShootPos() )
	ed:SetScale( 1 )
	util.Effect( "smoke_poof", ed )
	ed:SetOrigin( self.Owner:GetPos() )
	util.Effect( "smoke_poof", ed )
	return true
	
end

function SWEP:Deploy()

	local ed = EffectData()
	ed:SetOrigin( self.Owner:GetShootPos() )
	ed:SetScale( 1 )
	util.Effect( "smoke_poof", ed )
	ed:SetOrigin( self.Owner:GetPos() )
	util.Effect( "smoke_poof", ed )
	
end


