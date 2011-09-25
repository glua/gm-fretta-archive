
//Server

//Gets all players on the cactus team
function GM:GetCactusPlayers()
	local cacti = {}
	for k,v in pairs(player.GetAll()) do
		if v:IsCactus() then
			table.insert(cacti,v)
		end
	end
	return cacti
end

//Gets all players on the cactus team who don't have a cactus entity
function GM:GetWaitingCacti()
	local waiting = {}
	for k,v in pairs(GAMEMODE:GetCactusPlayers()) do
		if !ValidEntity(v:GetCactus()) then
			table.insert(waiting,v)
		end
	end
	return waiting
end

//Gets all cactus entities, not including players
function GM:GetCactusEntities()
	local entswithoutplayers = {}
	for k,v in pairs(ents.FindByClass("sent_cactus")) do
		if !ValidEntity(v:GetPlayerObj()) then
			table.insert(entswithoutplayers,v)
		end
	end
	return entswithoutplayers
end

//Returns a table containing all cactus entities and players
function GM:GetAllCacti()
	return table.Add(GAMEMODE:GetCactusEntities(),GAMEMODE:GetCactusPlayers())
end

//Returns a boolean value telling you whether maximum cacti has been reached or not
function GM:MaxCactiReached()
	if #GAMEMODE:GetAllCacti() >= GetConVarNumber("c_maxcacti") then
		return true
	end
	return false
end


//Returns a table containing all cacti that are of a specific type
function GM:GetCactiByType(typ)

	local curTypes = {}
	for _,k in pairs(Cactus.Types) do
		curTypes[k] = {}
	end
	for _,v in pairs(GAMEMODE:GetAllCacti()) do
		if v:GetCactusType() then
			table.insert(curTypes[v:GetCactusType()],v)
		end
	end
	
	return curTypes[typ] or curTypes
	
end

//Gets an available random cactus type
function GM:GetRandomCactusType()

	local allowedTypes = {}
	local rand
	for k,v in pairs(Cactus.Types) do
		local checkType = GAMEMODE:GetCactiByType(v)
		if #checkType < GetConVarNumber("c_max"..v) then
			table.insert(allowedTypes,v)
		end
	end
	if allowedTypes[1] then
		rand = table.Random(allowedTypes)
	else
		rand = "normal"
	end
	return rand
	
end

//Spawns cactus entities
function GM:SpawnCacti()

	local validSpawnEnts = team.GetSpawnPoint( TEAM_CACTUS )
	
	Cactus.Spawns = ents.FindByClass("info_cactus_spawn")
	
	for _, v in pairs( validSpawnEnts ) do
		if ValidEntity(ents.FindByClass(v)[1]) then
			table.Merge(Cactus.Spawns, ents.FindByClass(v))
		end
	end
	
	if GAMEMODE:MaxCactiReached() then return end
	
	MsgN("Spawning Cacti...")
	
	for k,v in pairs(Cactus.Spawns) do
		if GAMEMODE:MaxCactiReached() then
			MsgN("Max Cacti Reached...")
			return
		else
			local cactus = ents.Create("sent_cactus")
			local pos = v:GetPos()
			if v:GetClass() != "info_cactus_spawn" then
				local tr = util.QuickTrace(v:GetPos(),v:GetPos()+vector_up*800,{v})
				pos = tr.HitPos
				if tr.Hit then
					pos = tr.HitNormal*20
				end
			end
			cactus:SetPos(pos)
			cactus:SetAngles(Angle(math.Rand(0,360),math.Rand(0,360),math.Rand(0,360)))
			cactus:Spawn()
			local typ = GAMEMODE:GetRandomCactusType()
			cactus:SetCactusType(typ)
		end
	end
	
end

//Detonate function for cacti
function GM:CactusDetonate(ply,ent)

	if ValidEntity(ply) then
		
		if !ValidEntity(ent) then return end
		if ent.CactusType != "explosive" then return end
		
		ent:EmitSound("5cacti.mp3", 200, 100)
		
		for i=1,5 do
			local cactus = ents.Create("sent_cactus")
			cactus:SetPos(ent:GetPos()+Vector(math.random(-10,10),math.random(-10,10),0))
			cactus:Spawn()
			cactus:SetCactusType(GAMEMODE:GetRandomCactusType())
			cactus:SetVelocity(VectorRand() * math.Rand(-999,999))
			timer.Simple(1, cactus.Spam, cactus)
		end
		
		local position = ent:GetPos()
		local damage = 100
		local radius = math.random(400,600)
		local attacker = ply or ent
		local inflictor = ent
		
		local effect = EffectData()
		effect:SetOrigin(ent:GetPos())
		effect:SetEntity(ent)
		
		util.Effect( "ExplodeCactus",  effect )
		
		util.BlastDamage(inflictor, attacker, position, radius, damage)
		
		ent:EmitSound("weapons/mortar/mortar_explode"..math.random(1,3)..".wav", 100, 100)
		
		if ValidEntity(ply) and ply:IsPlayer() then
			ply:Kill()
		end
		
	end
	
end

function GM:StartWarnings(ent)


end
function GM:EndWarnings(ent)


end

function testeffects(ply,cmd,args)
	local on = args[1]
	local cactus = ply:GetCactus()
	local effect = EffectData()
	effect:SetOrigin(cactus:GetPos()+cactus:OBBCenter())
	effect:SetEntity(cactus)
	util.Effect( "CactusTrail",  effect )
end
concommand.Add("testtrail", testeffects)






