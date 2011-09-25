// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Accuracy powerup - Section PRIMARY. PWUP is a temporary object passed to this 

PWUP.Name		= "Accuracy"		// Name of the powerup, shown as text underneath the spinning icon in game.
PWUP.Type 		= POWERUP_PRIMARY	// Powerup type, primary, secondary or player.
PWUP.Rarity 	= 1 				// 1 - least rare, 5 - most rare. 5 is an arbitrary number, you can have as high a rarity level as you like.
PWUP.Mat 		= "LaserTag/HUD/powerup_accuracy" // Material for spinning icon (quad)
PWUP.Tex 		= "LaserTag/HUD/powerup_accuracy" // Texture for HUD

function PWUP:OnPickup(ply,wep)
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate. It is possible to get a player without a weapon in certain conditions.
	
	// Alter the weapon accuracy.
	wep.Settings.Spread = Vector(0,0,0)		// Spread of lasers.
	wep.Settings.Punch = Angle(-0.5,0,0)	// View punch from primary fire. More makes it harder to aim.
	
	wep.Weapon:SetNextPrimaryFire(CurTime())
end

function PWUP:OnDrop(ply,wep)
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate.
	wep.Settings = table.Copy(wep.BaseSettings) // Backup of default settings for the SWEP. Convenience for Powerups.
end