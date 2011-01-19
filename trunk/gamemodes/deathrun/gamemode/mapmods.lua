GM.Weapons = {}
GM.TouchEvents = {}
GM.RemoveWeapons = {}
GM.RestartRemoves = {
	"weapon_*",
	"ss_weapon",
	"prop_ragdoll"
}

// Deathrun modifications
function GM:AddWeapon(Position, WepType)
	if WepType then
		self.Weapons[Position] = {
			ent = false,
			Type = tostring(WepType)
		}
	else
		self.Weapons[Position] = {
			ent = false,
			Type = "weapon_smg1"
		}
	end
end

function GM:RemoveWeapon(Position)
	table.insert(self.RemoveWeapons, Position)
end

function GM:AddTouchEvents(Position, Radius, Function)
	self.TouchEvents[Position] = {Radius = Radius, Function = Function, Ent = false}
end

function GM:SpawnWeapons()
	for k,v in pairs(self.Weapons) do
		if(!IsValid(v.ent)) then //if(!IsValid(v)) then
			local Weapon = ents.Create("ss_weapon")
			Weapon.Type = v.Type
			Weapon:SetPos(k)
			Weapon:Spawn()
			Weapon:Activate()
			//self.Weapons[k] = Weapon
			//Msg("Spawning "..v.Type.." at "..k..".")
		end
	end
end

function GM:RemoveAllWeapons()
	for k,v in pairs(self.RemoveWeapons) do
		for k2,v2 in pairs(ents.FindInSphere(v, 50)) do
			if(v2:IsWeapon() or v2:GetClass() == "ss_weapon") then
				v2:Remove()
			end
		end
	end
end

function GM:SpawnTouchEvents()
	for k,v in pairs(self.TouchEvents) do
		if(!IsValid(v.Ent)) then
			local TouchEvent = ents.Create("gmt_touchevent")
			TouchEvent:SetPos(k)
			TouchEvent:Setup(v.Radius, v.Function)
			TouchEvent:Spawn()
			TouchEvent:Activate()
			self.TouchEvents[k].Ent = TouchEvent
		end
	end
end

function GM:RemoveMapStuff()
	for k,v in pairs(ents.FindByClass("player_speedmod")) do
		v:Remove()
	end
	for k,v in pairs(ents.FindByClass("game_player_equip")) do
		v:Remove()
	end
end