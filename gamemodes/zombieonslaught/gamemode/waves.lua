
GM.Waves = {}
GM.WaveTimer = 0

// format: TIME BEFORE WAVE BEGINS, TYPE OF ZOMBIE
local function AddWave( time, zombietype, msg )

	table.insert( GM.Waves, { Time = time, ZombieType = zombietype } )
	
	local func = function()
		for k,v in pairs( team.GetPlayers( TEAM_ALIVE ) ) do
			v:Notice( msg, 8, 255, 50, 0 )
			v:SendLua("surface.PlaySound( \"" .. table.Random( GAMEMODE.AmbientScream ) .. "\" )") 
		end
	end
	
	timer.Create( "WaveNotice"..time, time, 1, func )
	
end

AddWave( 60 * 0.3, "npc_zombie_normal", "Here come the zombies..." )
AddWave( 60 * 3.0, "npc_zombie_fast", "Things are going to get interesting..." )
AddWave( 60 * 8.0, "npc_zombie_poison", "You might want to lock the doors..." )

function GM:GetZombieSpawns()

	if not GAMEMODE.ZombieSpawns then
	
		GAMEMODE.ZombieSpawns = ents.FindByClass( "info_player_terrorist" )
		GAMEMODE.ZombieSpawns = table.Add( GAMEMODE.ZombieSpawns, ents.FindByClass( "info_player_combine" ) )
		GAMEMODE.ZombieSpawns = table.Add( GAMEMODE.ZombieSpawns, ents.FindByClass( "info_player_zombie" ) )
	
	end
	
	return GAMEMODE.ZombieSpawns

end

function GM:CreateZombie( ztype )

	if #ents.FindByClass( "npc_zombie_*" ) >= 50 then return end

	local pos = table.Random( GAMEMODE:GetZombieSpawns() ):GetPos()
	
	local zombie = ents.Create( ztype )
	zombie:SetPos( pos )
	zombie:Spawn()

end 

function GM:WaveThink()

	local time = GetGlobalFloat( "RoundStartTime" ) - ( GetGlobalFloat( "RoundStartTime" ) - CurTime() )

	if GAMEMODE.WaveTimer <= CurTime() then
	
		GAMEMODE.WaveTimer = CurTime() + 20
		
		for k,v in pairs( GAMEMODE.Waves ) do
		
			if v.Time <= time and GAMEMODE:InRound() then
			
				for i=0, team.NumPlayers( TEAM_ALIVE ) do
				
					GAMEMODE:CreateZombie( v.ZombieType )
					
				end	
			end
		end
	end
end


