// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: RapidFire powerup - Section PRIMARY. PWUP is a temporary object passed to this 

PWUP.Name		= "Proximity"			// Name of the powerup, shown as text underneath the spinning icon in game.
PWUP.Type 		= POWERUP_SECONDARY		// Powerup type, primary, secondary or player.
PWUP.Rarity 	= 9 					// 1 - least rare, 5 - most rare. 5 is an arbitrary number, you can have as high a rarity level as you like.
PWUP.Mat 		= "LaserTag/HUD/powerup_proximity" // Material for spinning icon (quad)
PWUP.Tex 		= "LaserTag/HUD/powerup_proximity" // Texture for HUD

function PWUP:OnPickup(ply,wep)
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate. It is possible to get a player without a weapon in certain conditions.
	
	local punch = Angle(math.Rand(-5,-10),math.Rand(-2,2),math.Rand(-2,2))
	local pitch = 120
	
	util.PrecacheSound("npc/scanner/scanner_siren1.wav") // Rocket fired noise.
	util.PrecacheSound("npc/scanner/combat_scan2.wav") // Rocket active noise.
	wep.Weapon:EmitSound("npc/scanner/combat_scan2.wav",100,pitch) // Emit the noise to begin with.
	wep.Weapon:SetNextSecondaryFire(CurTime()) // Reset NextFire so we can fire the moment we get the powerup.
	
	// Alter the weapon's functionality.
	wep.SecondaryAttack = function(wep)
		// Grab settings (makes sure they're up to date)
		local refire = wep.Settings.Refire*10 // seconds. If you have like rapidfire or something it will affect the rockets but they will cause less damage appropriately.
		local damage = wep.Settings.Damage*11
		local radius = 2*damage
		
		// Delay the next shot (we do this first so if there is an error we don't get continuous fire)
		wep:SetNextSecondaryFire(CurTime() + refire)
		
		// Play 'Fire' sound and set up a timer to fire the 'Ready' noise later.
		timer.Create("NotifyRecharge-"..tostring(ply:SteamID()),refire,1,function(wep)
			if wep and wep.Weapon and wep.Weapon:IsValid() then wep.Weapon:EmitSound("npc/scanner/combat_scan2.wav",100,pitch) end
		end,wep) 
		wep.Weapon:EmitSound("npc/scanner/scanner_siren1.wav",100,pitch) //100,255)
		
		// Fire effects and punch.
		wep:ShootEffects()
		wep.Owner:ViewPunch(punch)
		
		// End of the line for clientside, it's all about the server from here.
		if CLIENT then return end
		
		// Setup shoot position and angle.
		local pos = wep.Owner:GetShootPos()
		local ang = wep.Owner:GetAimVector()
		
		// If we can do it from the weapon do so. This will be from world model muzzlepos, but it doesn't really matter too much.
		local vm = wep.Owner:GetViewModel()
		local att = vm:GetAttachment(vm:LookupAttachment("muzzle"))
		if att then pos,ang = att.Pos,att.Ang end
		
		// Create the rocket entity.
		local ent = ents.Create("lt_rocket")
			if not ent then return end
			
			// Set up it's basic information.
			ent:SetOwner(wep.Owner)
			ent:SetPos(pos)
			ent:SetAngles(ang)
		ent:Spawn()
		
		// Radius and damage.
		ent:SetRadius(radius)
		ent:SetDamage(damage)
	end
	
end

function PWUP:OnDrop(ply,wep)
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate.
	wep.SecondaryAttack = wep.BaseSecondaryAttack
	timer.Destroy("NotifyRecharge-"..tostring(ply:SteamID()))
end