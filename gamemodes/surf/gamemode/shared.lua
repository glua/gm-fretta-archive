GM.Name 	= "Surf"
GM.Author 	= "Zargero"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= [[Surf to the end and kill the enemy team.]]

GM.GameLength = 30 --Game length
GM.RoundLimit = 10 --Total number of rounds

GM.TeamBased = true
GM.ForceJoinBalancedTeams = true --Auto balance teams?

GM.RoundBased = true
GM.RoundLength = 60*10	--The Length of the each round
GM.RoundPreStartTime = 1 --Time before round start
GM.RoundPostLength = 5 --Delay after round end
GM.RoundEndsWhenOneTeamAlive = true --Round will end after everyone on a team is dead

GM.RealisticFallDamage = true --Realistic fall damage
GM.NoAutomaticSpawning = true
GM.RedLingerTime = 2

GM.AllowSpectating = true --Can people spectate?
GM.CanOnlySpectateOwnTeam = true --Can they only spectate their own team
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE, OBS_MODE_ROAMING }

DeriveGamemode( "fretta" )
IncludePlayerClasses()

TEAM_Red = 1
TEAM_Blue = 2

function GM:CreateTeams()
 
	if ( !GAMEMODE.TeamBased ) then return end
 
	team.SetUp( TEAM_Blue, "Blue", Color( 20, 20, 200 ), true )
	team.SetSpawnPoint( TEAM_Blue, "info_player_counterterrorist" )
	team.SetClass( TEAM_Blue, { "Blue" } )
 
	team.SetUp( TEAM_Red, "Red", Color( 200, 20, 20 ), true )
	team.SetSpawnPoint( TEAM_Red, "info_player_terrorist" ) 
	team.SetClass( TEAM_Red, { "Red" } )
	
end

function SurfMove(pl, movedata)
	if pl:IsOnGround() or !pl:Alive() or pl:WaterLevel() > 0 then return end
	
	local aim = movedata:GetMoveAngles()
	local forward, right = aim:Forward(), aim:Right()
	local fmove = movedata:GetForwardSpeed()
	local smove = movedata:GetSideSpeed()
	
	forward.z, right.z = 0,0
	forward:Normalize()
	right:Normalize()

	local wishvel = forward * fmove + right * smove
	wishvel.z = 0

	local wishspeed = wishvel:Length()

	if(wishspeed > movedata:GetMaxSpeed()) then
		wishvel = wishvel * (movedata:GetMaxSpeed()/wishspeed)
		wishspeed = movedata:GetMaxSpeed()
	end

	local wishspd = wishspeed
	wishspd = math.Clamp(wishspd, 0, 30)

	local wishdir = wishvel:GetNormal()
	local current = movedata:GetVelocity():Dot(wishdir)

	local addspeed = wishspd - current

	if(addspeed <= 0) then return end

	local accelspeed = (120) * wishspeed * FrameTime()

	if(accelspeed > addspeed) then
		accelspeed = addspeed
	end

	local vel = movedata:GetVelocity()
	vel = vel + (wishdir * accelspeed)
	movedata:SetVelocity(vel)

	return false
end
hook.Add("Move", "Surfing", SurfMove)