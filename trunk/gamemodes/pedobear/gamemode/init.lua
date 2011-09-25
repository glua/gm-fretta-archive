AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_selectscreen.lua" )

include( "shared.lua" )
include( "round_controller.lua" )

resource.AddFile("sound/mhs/bennyhill.mp3")
fireagain = true
oldtime = 10
function GM:Think()
	if(GAMEMODE:InRound())then
		CheckRoundEnd()
		if(fireagain == true)then
			time = 8
			print(GetGlobalFloat( "RoundEndTime" ) - CurTime())
			if(GetGlobalFloat( "RoundEndTime" ) - CurTime() < 0)then
				time = 8
			elseif(GetGlobalFloat( "RoundEndTime" ) - CurTime() < 30)then
				time = 1
			elseif(GetGlobalFloat( "RoundEndTime" ) - CurTime() < 60)then
				time = 3
			elseif(GetGlobalFloat( "RoundEndTime" ) - CurTime() < 120)then
				time = 5
			end
			timer.Create("pedoTimer",  time,  1,  function()
				local ent = ents.Create("pedobear")
				ent:SetPos(GAMEMODE:GetRndSpawn():GetPos() +Vector(0,0,10))
				ent:Spawn()
				fireagain = true
			end)
			fireagain = false
		end
	else
		timer.Destroy("pedoTimer")
		fireagain = true
	end
end

function GM:GetRndSpawn()
        cps = ents.FindByClass("pb_spawn")
        return table.Random(cps)
end

function GM:PlayerInitialSpawn( pl )

	pl:SetTeam( TEAM_UNASSIGNED )
	pl:SetPlayerClass( "Spectator" )
	pl.m_bFirstSpawn = true
	pl:UpdateNameColor()
	
	GAMEMODE:CheckPlayerReconnected( pl )
	
end

function GM:CheckPlayerReconnected( pl )

	if table.HasValue( GAMEMODE.ReconnectedPlayers, pl:UniqueID() ) then
		GAMEMODE:PlayerReconnected( pl )
	end

end

function GM:PlayerSpawn( ply )
	ply.dead = false
	self.BaseClass:PlayerSpawn( ply )
end

function GM:PlayerDeath( ply, attacker, dmginfo )
	CheckRoundEnd()
end

function GM:PedoDeath(ply, attacker, dmginfo)
	if(ply != attacker)then
		
	end
end

function GM:PlayerDisconnected( ply )
	CheckRoundEnd()
end

function NumAlive()
	i=0
	for k,v in pairs(team.GetPlayers(TEAM_PLAYER)) do
		if(v:Alive())then
			i=i+1
		end
	end
	return i
end

function CheckRoundEnd()
	if(GAMEMODE:InRound())then
		i = 0
		for k,v in pairs(team.GetPlayers(TEAM_PLAYER)) do
			if(v:Alive())then
				i=i+1
				ply = v
			end
		end
		if(i == 1)then
			GAMEMODE:RoundEndWithResult(ply, ply:Nick().." escaped Pedo Bear!")
		end
		if(i <= 0)then GAMEMODE:RoundEndWithResult( 1001, "Wtf Happened?!" ) end
	end
end

function GM:SpawnPlayers()
	for k,v in pairs(team.GetPlayers(TEAM_PLAYER))do
		v:Spawn()
		v:SendLua('PlaySound()')
	end
end