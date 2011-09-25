// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: RapidFire powerup - Section PRIMARY. PWUP is a temporary object passed to this 

PWUP.Name		= "Burst"			// Name of the powerup, shown as text underneath the spinning icon in game.
PWUP.Type 		= POWERUP_SECONDARY	// Powerup type, primary, secondary or player.
PWUP.Rarity 	= 2 				// 1 - least rare, 5 - most rare. 5 is an arbitrary number, you can have as high a rarity level as you like.
PWUP.Mat 		= "LaserTag/HUD/powerup_burst" // Material for spinning icon (quad)
PWUP.Tex 		= "LaserTag/HUD/powerup_burst" // Texture for HUD

function PWUP:OnPickup(ply,wep)
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate. It is possible to get a player without a weapon in certain conditions.
	
	local punch = Angle(math.Rand(-5,-10),math.Rand(-2,2),math.Rand(-2,2))
	
	util.PrecacheSound("weapons/shotgun/shotgun_dbl_fire.wav")
	util.PrecacheSound("weapons/fx/nearmiss/bulletltor12.wav")
	wep.Weapon:SetNextSecondaryFire(CurTime()) // Reset NextFire so we can fire the moment we get the powerup.
	
	// Alter the weapon's functionality.
	wep.SecondaryAttack = function(wep)
		// Grab settings (makes sure they're up to date)
		local spread = wep.Settings.Spread * 4
		local lasers = wep.Settings.LasersPerFire * 10
		local refire = wep.Settings.Refire*4 // seconds.
		local damage = wep.Settings.Damage
		
		// Limit the spreading on the shot. We want Accuracy and RapidFire to affect how the bullets spread, but not too much/little. If we left it, Accuracy would eliminate spread.
		spread.x = math.Clamp(spread.x,0.04,0.1)
		spread.y = math.Clamp(spread.x,0.04,0.1)
		spread.z = math.Clamp(spread.x,0.04,0.1)
		
		// Delay the next shot (we do this first so if there is an error we don't get continuous fire)
		wep:SetNextSecondaryFire(CurTime() + refire)
		
		
		// Play fire sounds.
		wep.Weapon:EmitSound("weapons/shotgun/shotgun_dbl_fire.wav",80,255) //100,255)
		wep.Weapon:EmitSound("weapons/fx/nearmiss/bulletltor12.wav",80,80)
		
		// Setup shoot position and angle.
		local pos = wep.Owner:GetShootPos()
		local ang = wep.Owner:GetAimVector()
		
		// Fire effects and punch.
		wep:ShootBullet(damage, lasers, pos, ang, spread)
		wep.Owner:ViewPunch(punch)
	end
	
end

function PWUP:OnDrop(ply,wep)
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate.
	wep.SecondaryAttack = wep.BaseSecondaryAttack
end