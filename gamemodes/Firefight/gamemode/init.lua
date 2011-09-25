AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua")
include( "shared.lua" )

local maxnpcs = CreateConVar( "firefight_maxnpcs", "35", { FCVAR_NOTIFY, FCVAR_ARCHIVE } )

local meta = FindMetaTable("Player")

local models = {}
models[1] = "models/Combine_Super_Soldier.mdl"
models[2] = "models/Combine_Soldier.mdl"
models[3] = "models/Combine_Soldier_PrisonGuard.mdl"
models[4] = "models/Police.mdl"

for k,v in pairs(file.Find("../sound/killstreaks/*.mp3")) do
	resource.AddFile(v .. ".mp3")
end

function GM:CreateNPC(strType, vecPos) 

	-- if no type given default to combine
	local npc = ents.Create( strType or "npc_combine" );
			npc:SetPos( vecPos )
			if strType == "npc_combine" or strType == nil then 
				npc:SetModel(models[math.random(1,4)])
			end
			npc:SetKeyValue( "additionalequipment", "weapon_ar2" );  
			npc:SetKeyValue( "NumGrenades", "4" );  
			npc:SetKeyValue( "tacticalvariant", "true" );  
		if math.random(1,2) == 1 then
			npc:SetKeyValue( "spawnflags", "256" );
		end
			npc:SetKeyValue( "spawnflags", "512" );												
			npc:SetKeyValue( "squadname", "npc's" );  
		if math.random(1,2) == 1 then
			npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_PERFECT );
		else
			npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD ); 
		end
		npc:Fire( "StartPatrolling", "", 0.5 );
		npc:SetKeyValue( "startburrowed", "1" );  
		npc:Fire( "unburrow")
		npc:SetKeyValue( "crabcount", "2")
		npc:Activate()
		npc:Spawn()

	npc:AddRelationship("npc_combine_s D_LI 99")
	npc:AddRelationship("npc_antlion D_LI 99")-- info_npc_start, info_headcrab_spawn, info_antlion_spawn, info_zombie_spawn, info_manhack_spawn, info_large_spawn (this 1 is for antguards,striders,hunters)
	npc:AddRelationship("npc_antlionguard D_LI 99")
	npc:AddRelationship("npc_zombie D_LI 99")
	npc:AddRelationship("npc_fastzombie D_LI 99")
	npc:AddRelationship("npc_poisonzombie D_LI 99")
	npc:AddRelationship("npc_manhack D_LI 99")
	npc:AddRelationship("npc_headcrab D_LI 99")
	npc:AddRelationship("npc_headcrab_black D_LI 99")
	npc:AddRelationship("npc_headcrab_fast D_LI 99")
	npc:AddRelationship("npc_strider D_LI 99")
	npc:AddRelationship("npc_turret_floor D_LI 99")
	npc:AddRelationship("npc_hunter D_LI 99")
end

function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()

	local NPCS = {}
	
	NPCS["Headcrabs"] = {}
	NPCS["Headcrabs"][1] = "npc_headcrab"
	NPCS["Headcrabs"][2] = "npc_headcrab_black"
	NPCS["Headcrabs"][3] = "npc_headcrab_fast"
	NPCS["Zombie"] = {}
	NPCS["Zombie"][1] = "npc_zombie"
	NPCS["Zombie"][2] = "npc_poisonzombie"
	NPCS["Zombie"][3] = "npc_fastzombie"
	NPCS["Large"] = {}
	NPCS["Large"][1] = "npc_hunter"
	NPCS["Large"][2] = "npc_strider"
	--NPCS["Large"][3] = "npc_antlionguard" --ant guard removed for now as it seems to spawn invisible
	
	local main_time = 0
	local headcrab_time = 0
	local combine_time = 0
	local zombie_time = 0
	local antlion_time = 0
	local manhack_time = 0
	local large_time = 0
	
	
	timer.Create("Main_timer", 1, 0, function()
		main_time = main_time + 1
		
		if table.Count(player.GetAll()) <= 5 then
			headcrab_time = 4
			combine_time = 12
			zombie_time = 6
			antlion_time = 4
			manhack_time = 7
			large_time = 200	
		elseif table.Count(player.GetAll()) > 5 && table.Count(player.GetAll()) <= 10 then
			headcrab_time = 3
			combine_time = 10
			zombie_time = 5
			antlion_time = 3
			manhack_time = 6
			large_time = 150
		elseif table.Count(player.GetAll()) > 10 && table.Count(player.GetAll()) <= 15 then
			headcrab_time = 2
			combine_time = 8
			zombie_time = 4
			antlion_time = 2
			manhack_time = 5
			large_time = 100
		elseif table.Count(player.GetAll()) > 15 then
			headcrab_time = 1
			combine_time = 6
			zombie_time = 3
			antlion_time = 2
			manhack_time = 4
			large_time = 50
		end

		if main_time % large_time == 0 then
				for k,v in pairs(ents.FindByClass("npc_*")) do
					v:Remove()
				end
				GAMEMODE:CreateNPC(table.Random(NPCS["Large"]), ents.FindByClass("info_large_spawn")[math.random(1,table.Count(ents.FindByClass("info_large_spawn")))]:GetPos())
		end
		
		if table.Count(ents.FindByClass("npc_*")) >= maxnpcs:GetInt() then
			return
		end
		
		if main_time % headcrab_time == 0 then
				GAMEMODE:CreateNPC(table.Random(NPCS["Headcrabs"]), ents.FindByClass("info_headcrab_spawn")[math.random(1,table.Count(ents.FindByClass("info_headcrab_spawn")))]:GetPos())
		end
		
		if main_time % combine_time == 0 then
					GAMEMODE:CreateNPC("npc_combine_s", ents.FindByClass("info_npc_start")[math.random(1,table.Count(ents.FindByClass("info_npc_start")))]:GetPos())
		end
	
		if main_time % zombie_time == 0 then
				GAMEMODE:CreateNPC(table.Random(NPCS["Zombie"]), ents.FindByClass("info_zombie_spawn")[math.random(1,table.Count(ents.FindByClass("info_zombie_spawn")))]:GetPos())
		end
		
		if main_time % antlion_time == 0 then
				GAMEMODE:CreateNPC("npc_antlion", ents.FindByClass("info_antlion_spawn")[math.random(1,table.Count(ents.FindByClass("info_antlion_spawn")))]:GetPos())
		end
		
		if main_time % manhack_time == 0 then
					GAMEMODE:CreateNPC("npc_manhack", ents.FindByClass("info_manhack_spawn")[math.random(1,table.Count(ents.FindByClass("info_manhack_spawn")))]:GetPos())
		end
	end)
end

function GM:OnRoundEnd( num )
	for k,v in pairs(player.GetAll()) do
		v.killstreak = 0
	end
end

function GM:OnNPCKilled( npc, attacker, weapon ) -- taken some from base because i need to overwrite the sending of the UMSG

	// Convert the weapon to the weapon that they're holding if we can.
	if ( weapon && weapon != NULL && attacker == weapon && (weapon:IsPlayer() || weapon:IsNPC()) ) then
	
		weapon = weapon:GetActiveWeapon()
		if ( attacker == NULL ) then weapon = attacker end
	
	end
	
	local weaponClass = "World"
	local AttackerClass = "World"
	
	if ( weapon && weapon != NULL ) then weaponClass = weapon:GetClass() end
	if ( attacker  && attacker != NULL ) then AttackerClass = attacker:GetClass() end

	if ( attacker && attacker != NULL && attacker:IsPlayer() ) then
	
		umsg.Start( "PlayerKilledNPC" )
		
			umsg.String( npc:GetClass() )
			umsg.String( weaponClass )
			umsg.Entity( attacker )
		
		umsg.End()
		
	elseif ( attacker && attacker != NULL && attacker:IsNPC() ) then
	
	umsg.Start( "NPCKilledNPC" )
	
		umsg.String( npc:GetClass() )
		umsg.String( weaponClass )
		if attacker.IsTraitor == true then
			AttackerClass = attacker:GetOwner():Nick()
		end
		umsg.String( AttackerClass )
	
	umsg.End()

	end

	if attacker:IsValid() && attacker.IsTraitor == true then --killstreaks are not given to players who are using npc's to do their bidding.
		if npc:IsValid() && npc:IsNPC() then
			if npc:GetClass() == "npc_headcrab" || npc:GetClass() == "npc_headcrab_black" || npc:GetClass() == "npc_headcrab_fast" || npc:GetClass() == "npc_manhack" then
				attacker:GetOwner():AddFrags(50)
			elseif npc:GetClass() == "npc_antlion" || npc:GetClass() == "npc_zombie" then
				attacker:GetOwner():AddFrags(75)
			elseif npc:GetClass() == "npc_fastzombie" || npc:GetClass() == "npc_poisonzombie" || npc:GetClass() == "npc_combine" then
				attacker:GetOwner():AddFrags(100)
			elseif npc:GetClass() == "npc_antlionguard" || npc:GetClass() == "npc_hunter" then
				attacker:GetOwner():AddFrags(350)
			elseif npc:GetClass() == "npc_strider" then
				attacker:GetOwner():AddFrags(550)
			end
		end
	end
	
	if attacker:IsValid() && attacker:IsPlayer() then
		if npc:IsValid() && npc:IsNPC() then
			if npc:GetClass() == "npc_headcrab" || npc:GetClass() == "npc_headcrab_black" || npc:GetClass() == "npc_headcrab_fast" || npc:GetClass() == "npc_manhack" then
				attacker:AddFrags(50)
			elseif npc:GetClass() == "npc_antlion" || npc:GetClass() == "npc_zombie" then
				attacker:AddFrags(75)
			elseif npc:GetClass() == "npc_fastzombie" || npc:GetClass() == "npc_poisonzombie" || npc:GetClass() == "npc_combine" then
				attacker:AddFrags(100)
			elseif npc:GetClass() == "npc_antlionguard" || npc:GetClass() == "npc_hunter" then
				attacker:AddFrags(350)
			elseif npc:GetClass() == "npc_strider" then
				attacker:AddFrags(550)
			end
		end
		
		if attacker.killstreak == nil then
			attacker.killstreak = 1
		else
			attacker.killstreak = attacker.killstreak + 1
		end
		
		if attacker.killstreak == 5 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 5 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given Famas', 2)
								surface.PlaySound('killstreaks/5_kill.mp3')]])
			attacker:Give("weapon_famas")
			attacker:GiveAmmo(18, "CombineCannon", true)
			attacker:SelectWeapon("weapon_famas")
			
		
		elseif attacker.killstreak == 10 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 10 Kill Streak!' );
							GAMEMODE:NotifyPlayer('Given Famas Ammo', 2)
							surface.PlaySound('killstreaks/10_kill.mp3')]])
			attacker:GiveAmmo(18, "CombineCannon", true)
		
		elseif attacker.killstreak == 20 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 20 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given A Shotgun', 2)
								surface.PlaySound('killstreaks/20_kill.mp3')]])
			attacker:Give("weapon_shotty")
			attacker:GiveAmmo(30, "Buckshot", true)
			attacker:SelectWeapon("weapon_shotty")
		
		elseif attacker.killstreak == 30 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 30 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given Grenade Launcher', 2)
								surface.PlaySound('killstreaks/30_kill.mp3')]])
			attacker:Give("weapon_grenadelauncher")
			attacker:SelectWeapon("weapon_grenadelauncher")
		
		elseif attacker.killstreak == 40 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 40 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given Full Health', 2)
								surface.PlaySound('killstreaks/40_kill.mp3')]])
			attacker:SetHealth(150)
			attacker:SetArmor(100)
		
		elseif attacker.killstreak == 50 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'Well Done You' , 'got a 50 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given Traitor Gun', 2)
								surface.PlaySound('killstreaks/50_kill.mp3')]])
			attacker:Give("weapon_traitor")
			attacker:SelectWeapon("weapon_traitor")
		
		elseif attacker.killstreak == 60 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 60 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given Full Ammo', 2)
								surface.PlaySound('killstreaks/60_kill.mp3')]])
			attacker:GiveAmmo(20, "Grenade", true)
			attacker:GiveAmmo(100, "Ar2", true)
			attacker:GiveAmmo(100, "SMG1", true)
			attacker:GiveAmmo(100, "357", true)
			attacker:GiveAmmo(108, "CombineCannon", true)
			attacker:GiveAmmo(50, "RPG_Round", true)
			attacker:GiveAmmo(100, "Buckshot", true)
			attacker:GiveAmmo(100, "Pistol", true)
		
		elseif attacker.killstreak == 70 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 70 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given Low Gravity', 2)
								surface.PlaySound('killstreaks/70_kill.mp3')]])
			attacker:SetGravity(0.7)
			
		elseif attacker.killstreak == 80 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 80 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given Super Health', 2)
								surface.PlaySound('killstreaks/80_kill.mp3')]])
			attacker:SetHealth(200)
			attacker:SetArmor(200)
		
		elseif attacker.killstreak == 90 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 90 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given Super Speed', 2)
								surface.PlaySound('killstreaks/90_kill.mp3')]])
			attacker:SetRunSpeed(1000)
		
		elseif attacker.killstreak == 100 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 100 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given Everything!', 2)
								surface.PlaySound('killstreaks/100_kill.mp3')]])
			attacker:GiveAmmo(20, "Grenade", true)
			attacker:GiveAmmo(100, "Ar2", true)
			attacker:GiveAmmo(100, "SMG1", true)
			attacker:GiveAmmo(100, "357", true)
			attacker:GiveAmmo(108, "CombineCannon", true)
			attacker:GiveAmmo(50, "RPG_Round", true)
			attacker:GiveAmmo(100, "Buckshot", true)
			attacker:GiveAmmo(100, "Pistol", true)
			attacker:SetHealth(300)
			attacker:SetArmor(300)
		
		elseif attacker.killstreak == 150 then
			attacker:SendLua([[GAMEMODE:AddPlayerAction( 'You' , 'got a 150 Kill Streak!' );
								GAMEMODE:NotifyPlayer('Given 5 Traitor Ammo!', 2)
								]])
			
			attacker:GiveAmmo(5, "Gravity")
			
		
		else return
		end
		
	end
end

function EntDamage( ent, inflictor, attacker, amount, dmginfo )
 
	if ent:IsNPC() && attacker:IsPlayer() && ent.IsTraitor == true then
		dmginfo:SetDamage( 0 )  
	end
end
hook.Add("EntityTakeDamage", "HurtNPC", EntDamage)

function OnDeath(ply)
	ply.killstreak = 0
end
hook.Add("DoPlayerDeath", "IDied", OnDeath)
hook.Add("PlayerDisconnected", "ILeft", OnDeath)

function initspawn(ply)
	ply.killstreak = 0
end
hook.Add("PlayerInitialSpawn", "combine_first_spawn", initspawn)

function spawning(ply)
	ply:SelectWeapon("weapon_smg")
end
hook.Add("PlayerSpawn", "giveonspawn", spawning)