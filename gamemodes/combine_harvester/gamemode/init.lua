AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua")
include( "shared.lua" )

local meta = FindMetaTable("Player")

function meta:SetKillStreak(intKillStreak)
	self:SetPData("killstreak", tostring(intKillStreak))
end

function meta:AddKillStreak(intKillStreak)
	self:SetPData("killstreak", tostring(self:GetPData("killstreak") + intKillStreak))
end

function meta:GetKillStreak()
	return tonumber(self:GetPData("killstreak"))
end

function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()

	local time 
	
	if table.Count(player.GetAll()) >= 15 then
		time = 1
	else
		time = 16 - table.Count(player.GetAll())
	end
	
	for k,v in pairs( ents.FindByClass("info_npc_start")) do
		
		local npc = ents.Create( "npc_combine_s" )
		npc:SetPos( v:GetPos() )
		npc:SetModel("models/Combine_Super_Soldier.mdl")
		npc:SetKeyValue( "additionalequipment", "weapon_ar2" );  
		npc:SetKeyValue( "NumGrenades", "4" );  
		npc:SetKeyValue( "tacticalvariant", "true" ); 												
		if math.random(1,2) == 1 then
			npc:SetKeyValue( "spawnflags", "256" );
		end
		npc:SetKeyValue( "spawnflags", "512" );
		npc:SetKeyValue( "squadname", "combine" );  
		npc:Spawn();  
		npc:Activate();  
		npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD );  
		npc:Fire( "StartPatrolling", "", 0.5 ); 
	end
	
	timer.Create("Create_Combine", time, 0, function()
 
											if table.Count( ents.FindByClass("npc_combine_s")) > 80 then return end
											
											for k,v in pairs( ents.FindByClass("info_npc_start")) do
		
												local npc = ents.Create( "npc_combine_s" );
												npc:SetPos( v:GetPos() )
												npc:SetModel("models/Combine_Super_Soldier.mdl")
												npc:SetKeyValue( "additionalequipment", "weapon_ar2" );  
												npc:SetKeyValue( "NumGrenades", "4" );  
												npc:SetKeyValue( "tacticalvariant", "true" );  
												if math.random(1,2) == 1 then
													npc:SetKeyValue( "spawnflags", "256" );
												end
												npc:SetKeyValue( "spawnflags", "512" );												
												npc:SetKeyValue( "squadname", "combine" ); 
												npc:Spawn();  
												npc:Activate();  
												npc:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD );  
												npc:Fire( "StartPatrolling", "", 0.5 );    
											end
										end)

end

function GM:OnRoundEnd( num )
	timer.Destroy("Create_Combine")
end

function OnKillCombine(npc, attacker, weapon)

	if attacker:IsValid() && attacker:IsPlayer() then
		attacker:AddFrags(1)
		if attacker:GetKillStreak() == nil then
			attacker:SetKillStreak(1)
		else
			attacker:AddKillStreak(1)
		end
		
		if attacker:GetKillStreak() == 5 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'You' , 'got a 5 Kill Streak!' );")
			attacker:GiveAmmo(3, "SMG1_Grenade", true)
		end
		
		if attacker:GetKillStreak() == 10 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'You' , 'got a 10 Kill Streak!' );")
			attacker:Give("weapon_shotgun")
			attacker:SelectWeapon("weapon_shotgun")
		end
		
		if attacker:GetKillStreak() == 20 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'You' , 'got a 20 Kill Streak!' );")
			attacker:Give("weapon_357")
			attacker:SelectWeapon("weapon_357")
		end
		
		if attacker:GetKillStreak() == 30 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'You' , 'got a 30 Kill Streak!' );")
			attacker:Give("weapon_crossbow")
			attacker:SelectWeapon("weapon_crossbow")
		end
		
		if attacker:GetKillStreak() == 40 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'You' , 'got a 40 Kill Streak!' );")
			attacker:SetHealth(150)
			attacker:SetArmor(100)
		end
		
		if attacker:GetKillStreak() == 50 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'Well Done You' , 'got a 50 Kill Streak!' );")
			attacker:Give("weapon_rpg")
			attacker:SelectWeapon("weapon_rpg")
		end
		
		if attacker:GetKillStreak() == 60 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'You' , 'got a 60 Kill Streak!' );")
			attacker:GiveAmmo(100, "Grenade", true)
			attacker:GiveAmmo(100, "Ar2", true)
			attacker:GiveAmmo(100, "SMG1", true)
			attacker:GiveAmmo(100, "357", true)
			attacker:GiveAmmo(100, "XBowBolt", true)
			attacker:GiveAmmo(50, "RPG_Round", true)
			attacker:GiveAmmo(100, "Buckshot", true)
			attacker:GiveAmmo(100, "Pistol", true)
		end
		
		if attacker:GetKillStreak() == 70 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'You' , 'got a 70 Kill Streak!' );")
		end
		
		if attacker:GetKillStreak() == 80 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'You' , 'got a 80 Kill Streak!' );")
			attacker:SetHealth(150)
			attacker:SetArmor(100)
		end
		
		if attacker:GetKillStreak() == 90 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'You' , 'got a 90 Kill Streak!' );")
		end
		
		if attacker:GetKillStreak() == 100 then
			attacker:SendLua("GAMEMODE:AddPlayerAction( 'OMG!! You' , 'got a 100 Kill Streak!' );")
		end
		
	end
end
hook.Add("OnNPCKilled", "Killed_Combine", OnKillCombine)

function OnDeath(ply)
	ply:SetKillStreak(0)
end
hook.Add("DoPlayerDeath", "IDied", OnDeath)
hook.Add("PlayerDisconnected", "ILeft", OnDeath)

function initspawn(ply)
	ply:ChatPrint("This is only a beta. Any bugs please report at http://www.facepunch.com/showthread.php?t=853986 \n This map is just something i threw together. A much better one is in production.")
end
hook.Add("PlayerInitialSpawn", "combine_first_spawn", initspawn)