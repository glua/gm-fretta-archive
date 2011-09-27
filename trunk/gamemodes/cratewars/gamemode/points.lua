
function SetupPoints(ply)
	ply.points = 0
	GAMEMODE:addpoints(ply, 50)
end
hook.Add("PlayerInitialSpawn", "SetupPoints", SetupPoints)

function playerDies( victim, weapon, killer )
	if (killer != victim) then
		GAMEMODE:addpoints(killer, 5)
	else
		GAMEMODE:addpoints(victim, 0)
	end
end
hook.Add( "PlayerDeath", "playerDeathTest", playerDies )

function showpoints(ply)
	GAMEMODE:addpoints(ply, 0)
end
hook.Add("PlayerSpawn", "AddPointsOnSpawn", showpoints)

function GM:addpoints(ply, ammount)
	if(ply:IsPlayer())then
		ply.points = ply.points + ammount
		SendUserMessage("SetPoints", ply, ply.points)
	end
end

function GM:ResetAllPlayersPoints()
	for _, ply in pairs(player.GetAll()) do
		SetupPoints(ply)
	end
end