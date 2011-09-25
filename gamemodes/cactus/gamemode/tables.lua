
//Player Levels
levels = {}

levels[1] = {
Name = "Beginner", 
Score = 0, 
Upgrade = "Gravity Gun",
func = function(self)
	if ValidEntity(self) then
		self:Give("weapon_physcannon")
	end
end
}

levels[2] = {
Name = "Collector", 
Score = 5, 
Upgrade = "Chain Link",
func = function(self)
	if ValidEntity(self) then
		self:Give("weapon_chainlink")
	end
end
}

levels[3] = {
Name = "Catcher", 
Score = 15, 
Upgrade = "Enhanced Speed",
func = function(self)
	if ValidEntity(self) then
		self:SetRunSpeed(800)
	end
end
}

levels[4] = {
Name = "MY HANDS FUCKING HURT!", 
Score = 30, 
Upgrade = "Vacuum",
func = function(self)
	if ValidEntity(self) then
		self:Give("weapon_vacuum")
	end
end
}

levels[5] = {
Name = "Needle Feet", 
Score = 50, 
Upgrade = "Super Jump",
func = function(self)
	if ValidEntity(self) then
		self:SetJumpPower(700)
	end
end
}

levels[6] = {
Name = "Cactus Master",
Score = 70,
Upgrade = "Net Nades",
func = function(self)
	if ValidEntity(self) then
		self:Give("weapon_netnades")
	end
end
}

//Cactus Types
types = {
"slow",
"fast",
"normal",
"powerup",
"explosive",
"golden"
}

//Upgrades given by powerup cacti
upgrades = {}

//Speed
upgrades["speed"] = {
name = "crazy speed", 
desc = "You can now run super fast!", 
func = function(self)
	self:SetRunSpeed(1000)
end,
func_undo = function(self)
	if ValidEntity(self) then
		if self:GetRunSpeed() == 1000 then
			self:SetRunSpeed(750)
		else
			return
		end
	end
end
}

//Jump
upgrades["jump"] = {
name = "super jump", 
desc = "You can now jump super high!", 
func = function(self)
	self:SetJumpPower(600)
end,
func_undo = function(self)
	if ValidEntity(self) then
		if self:GetJumpPower() == 600 then
			self:SetJumpPower(400)
		else
			return
		end
	end
end
}

//Health
upgrades["health"] = {
name = "health",
desc = "Your health has been set to 200!",
func = function(self)
	self:SetMaxHealth(200)
	self:SetHealth(200)
end,
func_undo = function(self)
	if ValidEntity(self) then
		if self:GetMaxHealth() == 200 then
			self:SetMaxHealth(100)
		else
			return
		end
	end
end
}

//Grabber
upgrades["grabber"] = {
name = "grabber", 
desc = "For the next 15 seconds, any cactus that flies within a close proximity of you will automatically be captured!", 
func = function(self)
	if self:GetCanAutoGrab() == true then
		self:SetCanAutoGrab(false)
		if ValidEntity(self:GetNWEntity("grabber")) then
			self:GetNWEntity("grabber"):Remove()
		end
	end
	self:SetCanAutoGrab(true)
	local grabber = ents.Create("grabber")
	grabber:SetPos(self:GetPos()+Vector(0,0,32))
	grabber:SetOwner(self)
	grabber:SetParent(self)
	grabber:Spawn()
	print("lolgrabber")
	self:SetNWEntity("grabber", grabber)
	timer.Simple(
	15,
	function()
		self:RemoveUpgrade("grabber")
		--upgrades["grabber"]["func_undo"](self)
	end
	)
end,
func_undo = function(self)
	if ValidEntity(self) then
		if self:GetCanAutoGrab() == true then
			self:SetCanAutoGrab(false)
			if ValidEntity(self:GetNWEntity("grabber")) then
				self:GetNWEntity("grabber"):Remove()
			end
			self:ChatPrint("GRABBER has worn off.")
			--self:RemoveUpgrade("grabber")
		else
			return
		end
	end
end
}

//Invinciblility
upgrades["invincible"] = {
name = "invincibility", 
desc = "For the next 30 seconds, you cannot be damaged!", 
func = function(self)
	if self:GetInvincible() == true then
		self:SetInvincible(false)
	end
	self:SetInvincible(true)
	timer.Simple(
	30,
	function()
		self:RemoveUpgrade("invincibility")
		--upgrades["invincible"]["func_undo"](self)
	end
	)
end,
func_undo = function(self)
	if ValidEntity(self) then
		if ValidEntity(self) then
			if self:GetInvincible() == true then
				self:SetInvincible(false)
				self:ChatPrint("INVINCIBILITY has worn off.")
				--self:RemoveUpgrade("invincibility")
			else
				return
			end
		end
	end
end
}

//Flight
/*upgrades["flight"] = {
name = "flight",
desc = "For the next 15 seconds, you can fly!",
func = function(self)
	if self:GetMoveType() == MOVETYPE_FLY then
		self:SetMoveType(MOVETYPE_WALK)
	end
	self:SetMoveType(MOVETYPE_FLY)
	timer.Simple(
	15, 
	function() 
		self:RemoveUpgrade("flight")
		--upgrades["flight"]["func_undo"](self)
	end
	)
end,
func_undo = function(self)
	if ValidEntity(self) then
		if self:GetMoveType() == MOVETYPE_FLY then
			self:SetMoveType(MOVETYPE_WALK)
			self:ChatPrint("FLIGHT has worn off.")
			--self:RemoveUpgrade("flight")
		else
			return
		end
	end
end
}*/

//Stealth
upgrades["stealth"] = {
name = "stealth", 
desc = "For the next 20 seconds, nobody can see you!", 
func = function(self) 
	if self:GetColor() == Color(0,0,0,0) then
		self:SetColor(255,255,255,255)
	end
	self:SetColor(0,0,0,0)
	self:GetActiveWeapon():SetColor(0,0,0,0)
	timer.Simple(
	20, 
	function()
		self:RemoveUpgrade("stealth")
		--upgrades["stealth"]["func_undo"](self)
	end
	)
end,
func_undo = function(self)
	if ValidEntity(self) then
		if self:GetColor() != Color(255,255,255,255) then
			self:GetActiveWeapon():SetColor(255,255,255,255)
			self:SetColor(255,255,255,255)
			--self:RemoveUpgrade("stealth")
			self:ChatPrint("STEALTH has worn off.")
		else
			return
		end
	end
end
}

--upgrades["????"] = {desc = "LALLALALALALA!"}

//All sounds
CactusSounds = {
"5cacti.mp3",
"andcactus.mp3",
"cactus_4.mp3",
"uhcactus.mp3",
"cactuscactus.mp3",
"cactuscactus_2.mp3",
"cactuscactus_3.mp3",
"cactuspie.mp3",
"Buttons.snd14"
}

//Cactus Taunts
taunts = {}
taunts.normal ={
"5cacti.mp3",
"andcactus.mp3",
"cactus_4.mp3",
"uhcactus.mp3",
"cactuscactus.mp3",
"cactuscactus_2.mp3",
"cactuscactus_3.mp3",
"cactuspie.mp3"
}
taunts.fast = {
"uhcactus.mp3",
"cactuscactus.mp3",
"cactuscactus_2.mp3",
"cactuscactus_3.mp3",
"andcactus.mp3"
}
taunts.slow = {
"5cacti.mp3",
"cactus_4.mp3",
"cactuspie.mp3"
}

GM.WinSound = "cactuscactus_2.mp3"
GM.LoseSound = "cactuspie.mp3"

for k,v in pairs(CactusSounds) do
	resource.AddFile("sound/"..v)
end

