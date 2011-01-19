
/*----------------------------
	Console commands
*/----------------------------

function TestParticleEff( pl, commandName, args)
	
	if not pl:IsListenServerHost() then return end
	
	if not args[1] then
		print("Give particle effect name as argument!")
	else
		local num = tonumber(args[1])
		if num and num != 0 then
			if (ParticleList[num]) then
				timer.Simple(1, function( pe )
					ParticleEffect(pe,pl:GetShootPos()+pl:GetAimVector()*200,Angle(0,0,0),nil)
				end, ParticleList[num])
				print("Showing ParticleSystem "..ParticleList[num])
			end
		else
			timer.Simple(1, function( pe )
				ParticleEffect(pe,pl:GetShootPos()+pl:GetAimVector()*200,Angle(0,0,0),nil)
			end, args[1])
			print("Showing ParticleSystem "..args[1])
		end
	end
	
end
concommand.Add("test_particle",TestParticleEff) 

function SpawnPowerup( pl, commandName, args)
	
	if not pl:IsListenServerHost() then return end
	GAMEMODE:CreatePowerup(args[1])
	
end
concommand.Add("spawn_powerup",SpawnPowerup) 

function ForceEndRound( pl, cmd, args )

	if not pl:IsListenServerHost() then return end
	timer.Adjust( "RoundEndTimer", 1, 0, function() GAMEMODE:RoundTimerEnd() end )
	
end
concommand.Add("force_endround",ForceEndRound) 

/*----------------------------
	Chat command functions
*/----------------------------

GM.ChatCommands = {} 
GM.AdminChatCommands = {}

function AddChatCommand( trigger_text, func )
	if (GM) then // hack hack hack
		GM.ChatCommands[trigger_text] = func
	else
		GAMEMODE.ChatCommands[trigger_text] = func
	end
end

function AddAdminChatCommand( trigger_text, func )
	if (GM) then
		GM.AdminChatCommands[trigger_text] = func
	else
		GAMEMODE.AdminChatCommands[trigger_text] = func
	end
end

function PlayerCommand( pl, text, team_only, dead ) 
	
	//print("PlayerSay "..pl:Name().." text: "..text)
	for k, v in pairs(GAMEMODE.ChatCommands) do
		if (k == string.Explode(" ",text)[1]) then
			v(text, text, team_only, dead)
		end
	end
		
	if pl:IsAdmin() then
		for k, v in pairs(GAMEMODE.AdminChatCommands) do
			if (k == string.Explode(" ",text)[1]) then
				v(pl, text, team_only, dead)
			end
		end
	end

end
hook.Add("PlayerSay","PlayerCommand",PlayerCommand)

/*------------------------------------
	Chat commands (mainly for debug)
*/------------------------------------

function DebugPrint( pl, text, team_only, dead )
	
	print("Entity validation test")
	print(tostring(GAMEMODE:GetTeamDividerAngles()))

end
AddChatCommand( "!debug", DebugPrint )

// Test stuff
ParticleList = {"aurora_01"
		, "aurora_02"
		, "aurora_02b"
		, "aurora_shockwave"
		, "blood_advisor_puncture"
		, "blood_advisor_puncture_withdraw"
		, "blood_advisor_shrapnel_impact"
		, "blood_drip_slow"
		, "blood_frozen"
		, "building_explosion"
		, "burning_character"
		, "burning_engine_01"
		, "ceiling_dust"
		, "choreo_borealis_snow"
		, "choreo_launch_camjet_1"
		, "choreo_launch_camjet_2"
		, "choreo_launch_camjet_sparks"
		, "choreo_launch_rocket_jet"
		, "choreo_launch_rocket_skyboxsmoke"
		, "choreo_launch_rocket_start"
		, "choreo_launch_rocket_upsmoke"
		, "choreo_silo_door"
		, "citadel_shockwave"
		, "citadel_shockwave_06"
		, "door_explosion_core"
		, "dust_bridge_crack"
		, "dust_bridgefall"
		, "dust_bridgefall_2"
		, "Dust_Ceiling_Inn"
		, "Dust_Ceiling_Rumble_24Diam"
		, "Dust_Ceiling_Rumble_512Square"
		, "dust_motes_lit_cone"
		, "electrical_arc_01_system"
		, "explosion_cabin"
		, "explosion_silo"
		, "extract_vorteat_juice"
		, "frozen_steam"
		, "grenade_explode_core"
		, "hunter_projectile_explosion_3"
		, "larvae_glow"
		, "larvae_glow_extract"
		, "larval_extract_drip"
		, "portal_lightning_01"
		, "portal_lightning_01_06a"
		, "portal_lightning_02"
		, "portal_lightning_03"
		, "portal_rift_01"
		, "Rain_01"
		, "rock_impact_stalactite"
		, "rock_splinter_stalactite"
		, "skybox_cloud_glow"
		, "skybox_cloud_glow2"
		, "skybox_cloud_glow3"
		, "skybox_fire_01"
		, "Skybox_Smoke_01"
		, "Skybox_Smoke_03"
		, "Skybox_Smoke_03_06a"
		, "Skybox_Smoke_04"
		, "Skybox_Smoke_05"
		, "slime_drip_slow"
		, "slime_drip_slow_brown"
		, "smoke_dark_plume_1"
		, "smoke_dog_v_strider_dropship"
		, "smoke_exhaust_01"
		, "smoke_mesh_01"
		, "smoke_smoulder_01"
		, "steam_jet_80"
		, "striderbuster_explode_dummy_core"
		, "water_drip_fast"
		, "water_drip_moderate"
		, "water_drip_slow"
		, "water_foam_01"
		, "water_foam_line_long"
		, "water_foam_line_short"
		, "water_gate_open"
		, "water_impact_bubbles_1"
		, "water_splash_leakypipe_silo"
		, "Waterfall_Spray_01"
		, "Waterfall_Cascade_01"
		, "Waterfall_Impact_01"
		, "WaterLeak_Pipe_1"
		, "WaterLeak_Pipe_Silo_01"
		, "Weapon_Combine_Ion_Cannon_Explosion"
		, "Weapon_Combine_Ion_Cannon_Intake" }
