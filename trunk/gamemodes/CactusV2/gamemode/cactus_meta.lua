
//Shared

//I've removed the powerup cactus for gameplay and deadline purposes.

Cactus.CactusTypes = {}
Cactus.Types = {}

function Cactus.GetType(typ) --Returns the meta data of a specific cactus type
	if type(typ) != "string" then
		return "nil"
	else
		for k,v in ipairs(Cactus.GetTypes()) do
			if v:GetType() == typ then
				return v
			end
		end
	end
end
function Cactus.GetTypes() --Returns the metatable containing all of the cactus types and their functions
    return Cactus.CactusTypes
end

local CactusObject = {} --starting to define metatable

CactusObject.__index = CactusObject --marks it as a metatable that is self referencing

AccessorFunc(CactusObject,"c_gName","Name", FORCE_STRING )
AccessorFunc(CactusObject,"c_gType","Type", FORCE_STRING )
AccessorFunc(CactusObject,"c_gMaxType","MaxType", FORCE_NUMBER )
AccessorFunc(CactusObject,"c_gIndex","Index")

function RegisterCactusType(name,ctype,maxtype,color,randspam,sounds,dif,pitch,score,len,select,onspawn,onspam,oncapture,onhit,onprimary,onsecondary,info)

    local tmp = {} 							--table to be turned into out object
    setmetatable(tmp,CactusObject) 			-- it's now our object. woo.
	
    tmp.CColor = color						--This determines the color of the cactus and its trail
    tmp.Difficulty = dif					--Difficulty multiplier
	tmp.RandSpam = randspam					--Table that gives bounds for the spam randomizer
	tmp.Sounds = sounds						--Table containing possible sounds for the cactus
	tmp.Pitch = pitch						--Pitch of the soundsn emited
	tmp.Score = score						--Score when caught
	tmp.CLength = len						--Trail length
	tmp.CanSelect = select					--Can be used by players
	tmp.OnSpawn = onspawn					--Called when the cactus is spawned
	tmp.OnSpam = onspam						--Called whenever the cactus spams
	tmp.OnCapture = oncapture				--Called in the GM:CaughtCactus function
	tmp.OnHit = onhit						--Called in the cactus's Touch function
	tmp.OnPrimary = onprimary				--Called in the cactus players primary fire function
	tmp.OnSecondary = onsecondary			--Called in the cactus players secondary fire function
	tmp.SpawnInfo = info					--Info to show player when they spawn as this cactus type
	
    tmp:SetName(name) 						--setting its nice name
    tmp:SetType(string.lower(ctype)) 			--setting its reference name
	tmp:SetMaxType(maxtype)
    tmp:SetIndex(#Cactus.CactusTypes+1) 	--setting its index
	
    table.insert(Cactus.CactusTypes,tmp) 	--inserting it to the table
	table.insert(Cactus.Types,string.lower(ctype)) --Add this new type to our cactus types table so it can spawn properly
	
	
    _G["CACTUS_"..string.upper(string.gsub(ctype," ","_"))] = tmp:GetIndex() --defining the global enumeration
	
    return tmp 								--returning the object
	
end

-- Normal Cactus
local Normal = RegisterCactusType(
"Normal",					--Nice name(used for notifications)
"normal", 					--Reference name (used for code references)
12,							--Maximum cacti of this type to be active
Color(30, 200, 30, 255), 	--Cactus color
{lower=1,upper=3}, 			--Randomize table
Cactus.Taunts.normal, 		--Sounds table
3, 							--Difficulty multiplier
100, 						--Sound pitch
2, 							--Score
3, 							--Trail length
true, 						--Can Select bool
function(self,ply,cactus)	--Called when the cactus is spawned
	return nil				--return nil to not use this function
end,		
function(self,ply,cactus)	--Called whenever the cactus spams
	return nil				--return nil to not use this function
end, 
function(self,ply,cactus) 	--Called in the GM:CaughtCactus() function
	return true				--Always return true at the end of your function unless you don't want anything to happen when you catch your cactus
end,
function(self,ply,cactus)	--Called in the cactus's Touch function
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your primary fire
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your secondary fire
	return nil				--return nil to not use this function
end,
"The normal cactus is a well balanced type.")


-- Slow Cactus
local Slow = RegisterCactusType("Slow", "slow", 12, Color(80, 80, 255, 255), --Nice name, ref name, maximum, color
{lower=2,upper=5}, Cactus.Taunts.slow, --randspam and taunts
2, 95, 1, 1, --difficulty, pitch, score, and length
false, --we don't want players selecting this one
function(self,ply,cactus)	--Called when the cactus is spawned
	return nil				--return nil to not use this function
end,		
function(self,ply,cactus)	--Called whenever the cactus spams
	return nil				--return nil to not use this function
end, 
function(self,ply,cactus) 	--Called in the GM:CaughtCactus() function
	return true
end,
function(self,ply,cactus)	--Called in the cactus's Touch function
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your primary fire
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your secondary fire
	return nil				--return nil to not use this function
end,
"") 						--No info since players wont play as this type


-- Fast Cactus
local Fast = RegisterCactusType("Fast", "fast", 12, Color(200, 30, 30, 255), --Nice name, ref name, maximum, color
{lower=0,upper=0.5}, Cactus.Taunts.fast, --randspam and taunts
5, 120, 3, 3, --difficulty, pitch, score, and length
true, --select
function(self,ply,cactus)	--Called when the cactus is spawned
	return nil				--return nil to not use this function
end,		
function(self,ply,cactus)	--Called whenever the cactus spams
	return nil				--return nil to not use this function
end, 
function(self,ply,cactus) 	--Called in the GM:CaughtCactus() function
	return true
end,
function(self,ply,cactus)	--Called in the cactus's Touch function
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your primary fire
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your secondary fire
	return nil				--return nil to not use this function
end,
"The fast cactus is hard to catch!")

/*
-- Power-up Cactus
local Powerup = RegisterCactusType("Power-Up", "powerup", 12, Color(200, 30, 200, 255), --Nice name, ref name, maximum, color
{lower=1,upper=2}, Cactus.Taunts.normal, --randspam and taunts
4, 100, 1, 2, --difficulty, pitch, score, and length
true, --can select
function(self,ply,cactus)	--Called when the cactus is spawned
	return nil				--return nil to not use this function
end,		
function(self,ply,cactus)	--Called whenever the cactus spams
	return nil				--return nil to not use this function
end, 
function(self,ply,cactus) 	--Called in the GM:CaughtCactus() function
	if SERVER then
		if ValidEntity(ply) and ply:IsPlayer() then
			local randpowerup = table.Random(Cactus.GetPowerups()):GetName()
			ply:AddPowerup(randpowerup)
		end
	end
	return true
end,
function(self,ply,cactus)	--Called in the cactus's Touch function
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your primary fire
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your secondary fire
	return nil				--return nil to not use this function
end,
"")
*/

-- Explosive Cactus
local Explosive = RegisterCactusType("Explosive", "explosive", 12, Color(0, 0, 0, 255), --Nice name, ref name, maximum, color
{lower=0,upper=1}, Cactus.Taunts.normal, --randspam and taunts
3, 100, 0, 3, --difficulty, pitch, score, and length
true, --select
function(self,ply,cactus)	--Called when the cactus is spawned
	return nil				--return nil to not use this function
end,		
function(self,ply,cactus)	--Called whenever the cactus spams
	return nil				--return nil to not use this function
end, 
function(self,ply,cactus) 	--When caught
	--do something...
	return false 			--We return false because we don't wan't these cacti to be caught
end,
function(self,ply,cactus)	--Called in the cactus's Touch function
	return nil				--return nil to not use this function
end,
function(self,ply,cactus) 	--OnPrimary
	--print(ply,cactus)
	if SERVER then
		if cactus.CountingDown then return true end
		timer.Simple(3,
		function()
			GAMEMODE:CactusDetonate(ply,cactus)
		end)
		cactus.CountingDown = true
	end
	return true
end,
function(self,ply,cactus)	--Called when you press your secondary fire
	return nil				--return nil to not use this function
end,
"Use your primary fire to start your detonation timer!")

-- Golden Cactus
local Golden = RegisterCactusType("Golden", "golden", 1, Color(255, 255, 30, 255), --Nice name, ref name, maximum, color
{lower=0,upper=0.1}, Cactus.Taunts.normal, --randspam and taunts
5, 130, 5, 5, --difficulty, pitch, score, and length
true, --canselect
function(self,ply,cactus)	--Called when the cactus is spawned
	return nil				--return nil to not use this function
end,		
function(self,ply,cactus)	--Called whenever the cactus spams
	return nil				--return nil to not use this function
end, 
function(self,ply,cactus) 	--Called in the GM:CaughtCactus() function
	return true
end,
function(self,ply,cactus)	--Called in the cactus's Touch function
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your primary fire
	return nil				--return nil to not use this function
end,
function(self,ply,cactus)	--Called when you press your secondary fire
	return nil				--return nil to not use this function
end,
"The Golden Cactus is the fastest, and most valuable cactus of all. Don't get caught!")

// Include and AddCSLuaFile it!
for k,v in ipairs(file.FindInLua("cacti/*")) do
	if SERVER then AddCSLuaFile(v) end
	include(v)
end


