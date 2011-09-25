

function CactusPostEntity()
	
	local placeholder = {}
	local weapons = ents.FindByClass("weapon_*")
	for k,v in pairs(weapons) do
		/*local numweps = table.Count(weapons)
		if numweps >= 100 then
			for i=100,numweps do
				v[i]:Remove()
			end
			for i=1,50 do
				if not table.HasValue(v[i]) then
					local rand = math.random(1,100)
					table.insert(placeholder, v[rand])
					local cspawn = ents.Create("info_cactus_spawn")
					cspawn:SetPos(v[rand]:GetPos())
					cspawn:Spawn()
				end
			end
		end*/
		v:Remove()
	end
	
	local cspawns = ents.FindByClass("info_cactus_spawn")
	local cduration = 18
	for k,v in pairs(cspawns) do
		timer.Create("cspawntimer_"..v:EntIndex(), cduration, 0, gamemode.Call, gamemode, "SpawnCacti")
		timer.Stop("cspawntimer_"..v:EntIndex())
	end
	
end
hook.Add("InitPostEntity", "CactusPostEnt", CactusPostEntity)

function GM:SpawnCacti()
	
	if UTIL_GetTotalCacti() >= GetGlobalInt("maxcacti") then return end
	
	local spawns = ents.FindByClass("info_cactus_spawn")
	
	for k,v in pairs(spawns) do
		
		local cactus = ents.Create("cactus")
		cactus:SetPos(v:GetPos())
		cactus:Spawn()
		cactus:SetCactusType(UTIL_GetValidCactus())
		
	end
	
end

function GravPickup( ply, ent )
	
	if ent:GetClass() != "cactus" then return false end
	
	if ply:GetCanAutoGrab() == false then
		if ValidEntity(ent) then
			timer.Simple(0.5, function() ply:CaughtCactus(ent) end)
		end
	elseif ply:GetCanAutoGrab() == true then
		return false
	end
	
	return true
	
end
hook.Add("GravGunOnPickedUp", "GravPickup", GravPickup)

function GravPunt( ply, ent )
	
	if ent:GetClass() != "cactus" then return end
	
	if ent:GetCactusType() != "explosive" then
		if ply:GetCanAutoGrab() == false then
			if SERVER then DropEntityIfHeld( ent ) ent:SetColor(0,0,0,0) SafeRemoveEntity(ent.Trail) end
			return false
		end
	end
	return true
	
end
hook.Add( "GravGunPunt", "GravPunt", GravPunt )




