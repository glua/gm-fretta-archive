
AddCSLuaFile( "shared.lua" )

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

if ( CLIENT ) then

SWEP.PrintName			= "The Megaseeker 9000"	// 'Nice' Weapon name (Shown on HUD)
SWEP.Instructions		= "Shoot hiders to find them"	
SWEP.Slot				= 1						// Slot in the weapon selection menu
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
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
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

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local trace = self.Owner:GetEyeTrace( )

	// Play shoot sound
	self.Weapon:EmitSound("Weapon_AR2.Single")
	
	self:SetNextPrimaryFire( CurTime() + 0.4 )
	self:ShootEffects( )
	
	if trace.HitWorld then return end
	local ent = trace.Entity
	if ent:IsValid( ) and ent:IsPlayer( ) then
		if ent:Team() == TEAM_HIDERS then
			--ent:CreateRagdoll( )
			if ( SERVER ) then
				ent:KillSilent( )
				
				self.Owner:AddFrags( 1 )
				gamemode.Call( "PlayerDeath", ent, self, self.Owner )
			end
		end
	end

end


/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

end

/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

end


