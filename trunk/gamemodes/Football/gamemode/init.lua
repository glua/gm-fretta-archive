
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "admin.lua" )
AddCSLuaFile( "tables.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
include( "admin.lua" )
include( "tables.lua" )


function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()
	SpawnCrate()
end

function GM:OnRoundResult( t )

	UTIL_FreezeAllPlayers()
		
	for k,v in pairs( player.GetAll() ) do 
	
		if  v:Team() == t then
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.WinSound .. "\" )" )
			v:ChatPrint( "YOUR TEAM WON!" );
		else
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.LoseSound .. "\" )" )
			v:ChatPrint( "YOUR TEAM FAILED!" );
		end
		
	end
	
	timer.Simple( 5, function() GAMEMODE:EndOfGame( true ) end )
end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end

	if team.GetScore( TEAM_RED ) < team.GetScore( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE )
	elseif team.GetScore( TEAM_RED ) > team.GetScore( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_RED )
	else
		GAMEMODE:RoundEndWithResult( ROUND_RESULT_DRAW )
	end

end

function GM:BlueAddScore() 
for k, v in pairs(ents.FindByClass("ball")) do
		v:Remove()
	end
for k, ply in pairs( player.GetAll() ) do 
     ply:KillSilent()
	 ply:Spawn()
	 team.AddScore( TEAM_BLUE , 1 )
	 ply:ChatPrint( "Blue Scored" )
	 SpawnCrate()
	 end
 end 
hook.Add( "PlayerUse", "PrintUseHook", BlueWin ) 

		
function GM:RedAddScore() 
for k, v in pairs(ents.FindByClass("ball")) do
		v:Remove()
	end
for k, ply in pairs( player.GetAll() ) do 
     ply:KillSilent()
	 ply:Spawn()
	 team.AddScore( TEAM_RED , 1 )
	 ply:ChatPrint( "Red Scored" )
	 SpawnCrate()
	 end 
 end 
hook.Add( "PlayerUse", "PrintUseHook", RedWin )

function SpawnCrate()
	
	local thespawn = table.Random(ents.FindByClass("info_ballspawn"))
	spawnpos = thespawn:GetPos()
	local ball = ents.Create("ball")
	ball:SetPos(spawnpos)
	ball:Spawn()
	ball:EmitSound("Weapon_MegaPhysCannon.Launch")
	
	local expEffect = EffectData()
	expEffect:SetStart(spawnpos)
	expEffect:SetOrigin(spawnpos)
	expEffect:SetScale(3)
	util.Effect("ManhackSparks", expEffect)
	
end

function GM:GravGunPickupAllowed()
		return false
	end