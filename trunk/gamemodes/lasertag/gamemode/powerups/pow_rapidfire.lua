// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: RapidFire powerup - Section PRIMARY. PWUP is a temporary object passed to this 

PWUP.Name		= "Rapid Fire"		// Name of the powerup, shown as text underneath the spinning icon in game.
PWUP.Type 		= POWERUP_PRIMARY	// Powerup type, primary, secondary or player.
PWUP.Rarity 	= 2 				// 1 - least rare, 5 - most rare. 5 is an arbitrary number, you can have as high a rarity level as you like.
PWUP.Mat 		= "LaserTag/HUD/powerup_rapidfire" // Material for spinning icon (quad)
PWUP.Tex 		= "LaserTag/HUD/powerup_rapidfire" // Texture for HUD

function PWUP:OnPickup(ply,wep)
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate. It is possible to get a player without a weapon in certain conditions.
	
	// Alter the weapon settings.
	wep.Settings.Refire = 0.08							// Refire
	wep.Settings.LasersPerFire = 1						// How many lasers to fire.
	wep.Settings.Spread = Vector(0.05,0.05,0.05)		// Spread
	wep.Settings.Punch = Angle(-0.1,0,0)				// View punch
	wep.Settings.Damage = wep.BaseSettings.Damage/2		// Damage
	wep.Settings.LaserSize = 10							// Size of lasers.
	
	wep.Weapon:SetNextPrimaryFire(CurTime())
end

function PWUP:OnDrop(ply,wep)
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate.
	wep.Settings = table.Copy(wep.BaseSettings) // Backup of default settings for the SWEP. Convenience for Powerups.
end