// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Definition and methods for the default player class.

local CLASS = {}

CLASS.DisplayName			= "Player"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.3
CLASS.RunSpeed				= 400
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= false
CLASS.DrawViewModel			= true
CLASS.CanUseFlashlight      = true // I may override this.
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.StartArmor			= 0
CLASS.RespawnTime           = 0 // 0 means use gamemode default.
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= false // Stop collide with teammates?
CLASS.AvoidPlayers			= false // Automatically avoid players that we're no colliding
CLASS.Selectable			= true
CLASS.FullRotation			= false
CLASS.ShieldMax				= 100 // Maximum shield permitted. [LaserTag Specific]
CLASS.ShieldRecharge		= 1 // Recarge this number of shield units per 0.1 sec after being shot. [LaserTag Specific]
CLASS.RechargeDelayAfterHit	= 2	// Delay after being shot that the shields will begin to recharge. (SECONDS) [LaserTag Specific]
CLASS.Defaults 				= table.Copy(CLASS)

function CLASS:Loadout(ply)
	ply:Give("weapon_lt_rifle")
	ply:SetNetworkedInt("Shield",self.ShieldMax)
	
	// Powerups
	ply:SetNWString("pwPrimary",false)
	ply:SetNWString("pwSecondary",false)
	ply:SetNWString("pwPlayer",false)
end

function CLASS:SetShield(ply,num,attacker) ply:SetNetworkedInt("Shield",math.Clamp(num,0,self.ShieldMax)) end

function CLASS:GetShield(ply) return ply:GetNetworkedInt("Shield") end

function CLASS:DamageShield(ply,amount,attacker)
	// Here is the only line we prevent teamdamage with:
	if attacker:Team() == ply:Team() then return end
	
	local dmg = math.Clamp(amount,1,self.ShieldMax)
	local shieldv = math.Clamp(self:GetShield(ply) - dmg,0,self.ShieldMax)
	ply:SetNetworkedInt("Shield",shieldv)
	
	if shieldv == 0 and attacker then // If we lost shield and know who did it, perform BreakShield.
		self:BreakShield(ply,attacker)
	elseif attacker then // Otherwise if we just got damaged a bit, set the timer to recharge the shield.
		timer.Create(ply:SteamID().."_recharge",self.RechargeDelayAfterHit,1, // Timer settings. Name, Time to expire after, Repetitions (0 is continous)
				self.RechargeShield,	// Function
				self,					// Pass CLASS object
				ply,					// Pass player in question.
				self.ShieldRecharge,	// Pass the amount to recharge.
				attacker)				// Pass the player who inflicted the damage.
	
	end
end

function CLASS:RechargeShield(ply,amount,attacker)
	local shieldlevel = self:GetShield(ply)
	
	if shieldlevel == self.ShieldMax then 
		timer.Destroy(ply:SteamID().."_recharge")
		return 
	end
	amount = math.Clamp(amount,1,self.ShieldMax - shieldlevel)
	
	self:SetShield(ply,shieldlevel + amount)
	timer.Adjust(ply:SteamID().."_recharge",0.1,0,
		self.RechargeShield,
		self,
		ply,
		self.ShieldRecharge,
		attacker)
end


function CLASS:Recharge(ply)
	local shieldlevel = self:GetShield(ply)
	if shieldlevel == self.ShieldMax then return end
	
	self:SetShield(ply,shieldlevel + self.ShieldRecharge)
	timer.Create(ply:SteamID().."_recharge",0.1,0,self.Recharge,self,ply)
end

function CLASS:BreakShield(ply,attacker)
	local fx = EffectData()
		fx:SetOrigin(ply:GetPos()+Vector(0,0,32))
		fx:SetMagnitude(ply:Team())
		fx:SetEntity(ply)
	util.Effect("ShieldShatter",fx,true,true)
	ply:EmitSound("physics/glass/glass_sheet_break3.wav",120,100)
	
	if attacker then
		GAMEMODE:AssimilatePlayer(ply,attacker)
	end
end

function CLASS:OnSpawn(ply)
end
 
function CLASS:OnDeath(ply,attacker,dmginfo)
end
 
function CLASS:Think(ply)
end
 
function CLASS:Move(ply,mv)
end
 
function CLASS:OnKeyPress(ply,key)
end
 
function CLASS:OnKeyRelease(ply,key)
end
 
function CLASS:ShouldDrawLocalPlayer(ply)
	return false
end
 
function CLASS:CalcView(ply,origin,angles,fov)
end

player_class.Register("Default", CLASS)