// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: RapidFire powerup - Section PRIMARY. PWUP is a temporary object passed to this 

PWUP.Name		= "Vampire"			// Name of the powerup, shown as text underneath the spinning icon in game.
PWUP.Type 		= POWERUP_PRIMARY	// Powerup type, primary, secondary or player.
PWUP.Rarity 	= 1 				// 1 - least rare, 5 - most rare. 5 is an arbitrary number, you can have as high a rarity level as you like.
PWUP.Mat 		= "LaserTag/HUD/powerup_vampire" // Material for spinning icon (quad)
PWUP.Tex 		= "LaserTag/HUD/powerup_vampire" // Texture for HUD

function PWUP:OnPickup(ply,wep)
	//if not SERVER then return end // We don't need the client to know we exist.
	
	self.VampMulti = 0.5 // 50% of the damage we deal comes back to us.
	self.VampSplashMulti = 0.5 // 50% of the splash damage we deal comes back to us.
	//self.PwupSteal = 0.1 // 10% chance of taking a powerup from the target player.
	self.Active = true
	
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate. It is possible to get a player without a weapon in certain conditions.
	
	// Alter the weapon's functionality.
	self.Bak = wep.OnHitPlayer
	wep.OnHitPlayer = function(wep,trace,dmg)
		// Check if we got a headshot.
		if trace.HitGroup == HITGROUP_HEAD then dmg = dmg * wep.Settings.HSMulti end
		
		// Apply damage
		local cl = trace.Entity:GetPlayerClass()
		cl:DamageShield(trace.Entity,dmg,wep.Owner)
		
		local ownercl = wep.Owner:GetPlayerClass()
		
		if ownercl then
			local shield = ownercl:GetShield(wep.Owner)
			ownercl:SetShield(wep.Owner,shield + (dmg*self.VampMulti))
			
			local fx = EffectData()
				fx:SetOrigin(trace.Entity:GetPos())
				fx:SetEntity(wep.Owner)
				fx:SetMagnitude(1)
			util.Effect("VampEffect",fx,true,true)
		end
	end
	
	wep.OnSplashPlayer = function(wep,ply,dmg)
		// Apply damage
		local cl = ply:GetPlayerClass()
		cl:DamageShield(ply,dmg,wep.Owner)
		
		// Do the vamp.
		local ownercl = wep.Owner:GetPlayerClass()
		
		if ownercl then
			local shield = ownercl:GetShield(wep.Owner)
			ownercl:SetShield(wep.Owner,shield + (dmg*self.VampSplashMulti))
			
			local fx = EffectData()
				fx:SetOrigin(ply:GetPos())
				fx:SetEntity(wep.Owner)
				fx:SetMagnitude(1)
			util.Effect("VampEffect",fx,true,true)
		end
	end
end

function PWUP:OnDrop(ply,wep)
	if not ply or not wep or not ply:IsValid() or not wep:IsValid() then return end // Validate.
	wep.OnHitPlayer = self.Bak
end