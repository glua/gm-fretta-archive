
AddCSLuaFile( "shared.lua" )

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

if ( CLIENT ) then

SWEP.PrintName			= "Stuff Mover"			// 'Nice' Weapon name (Shown on HUD)
SWEP.Instructions		= "Shoot stuff to move it"
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
SWEP.ViewModel		= "models/weapons/v_357.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
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
	
	self:SetNextPrimaryFire( CurTime() + 0.2 )
	
	if trace.HitWorld then return end
	local ent = trace.Entity
	if ent:IsValid( ) and !ent:IsPlayer( ) then
		local phys = ent:GetPhysicsObject( )
		if !phys then return end
		
		if( SERVER ) then
			phys:SetVelocity( trace.Normal * 5000 )
		
			// Play shoot sound
			self.Weapon:EmitSound("weapons/grenade_launcher1.wav")
			
			local trail = util.SpriteTrail( ent, 0, Color(255,255,255,255), true, 50, 0, 2, 1/(15+0)*0.5, "trails/plasma.vmt")
			local trail2 = util.SpriteTrail( ent, 0, Color(255,255,255,255), true, 50, 0, 2, 1/(15+0)*0.5, "trails/tube.vmt")
			local killtrail = function()
				if trail and trail2 and ent:IsValid() then
					trail:Remove()
					trail2:Remove()
				else
					Msg( "Tried to remove a trail that doesn't exist\n" )
					Msg( "You should ignore this unless you're getting Lua errors before it\n" )
				end
			end
			
			timer.Simple( 5, killtrail )
		
		end
	end

end


/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

end


