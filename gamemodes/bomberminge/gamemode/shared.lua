
include("shd_module_multimodel.lua")
include("shd_models.lua")
include("shd_playeranim.lua")

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Name 	= "Bomberminge"
GM.Author 	= "_Kilburn"
GM.Email 	= ""
GM.Website 	= ""
GM.Help		= "peen"

GM.TeamBased = true	
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 2
GM.GameLength = 60
GM.RoundLimit = 99					-- Maximum amount of rounds to be played in round based games
GM.VotingDelay = 5					-- Delay between end of game, and vote. if you want to display any extra screens before the vote pops up

GM.NoPlayerSuicide = true
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		-- Allow players to hurt themselves?
GM.NoPlayerTeamDamage = false		-- Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false	 	-- Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	-- Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		-- When true, all players have silent footsteps
GM.PlayerCanNoClip = false			-- When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = false		-- -1 frag on suicide

GM.MaximumDeathLength = 0			-- Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 2			-- Player has to be dead for at least this long
GM.AutomaticTeamBalance = false     -- Teams will be periodically balanced 
GM.ForceJoinBalancedTeams = false	-- Players won't be allowed to join a team if it has more players than another team
GM.RealisticFallDamage = false
GM.AddFragsToTeamScore = false		-- Adds player's individual kills to team score (must be team based)

GM.NoAutomaticSpawning = true		-- Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				-- Round based, like CS
GM.RoundLength = 60 * 3				-- Round length, in seconds
GM.RoundPreStartTime = 2			-- Preperation time before a round starts
GM.RoundPostLength = 8				-- Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false

GM.EnableFreezeCam = false			-- TF2 Style Freezecam
GM.DeathLingerTime = 3				-- The time between you dying and it going into spectator mode, 0 disables

GM.ValidSpectatorModes = {OBS_MODE_CHASE, OBS_MODE_ROAMING}

TEAM_BOMBERS = 1

--[[-------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------]]
function GM:CreateTeams()
	team.SetUp(TEAM_BOMBERS, "Bomberminges", Color(255, 255, 210), true)
	team.SetSpawnPoint(TEAM_BOMBERS, {"info_player_start"})
	team.SetClass(TEAM_BOMBERS, {"Bomberminge"})
	
	team.SetUp(TEAM_SPECTATOR, "Spectators", Color(255, 255, 80), true)
	team.SetSpawnPoint(TEAM_SPECTATOR, {"info_player_terrorist","info_player_counterterrorist","info_player_combine","info_player_rebel","info_player_start"}) 
end

local MoveAngles = {-90, 0, 90, 180}

local function sign_val(x)
	if x<0 then return -1
	elseif x>0 then return 1
	else return 0
	end
end

local hatcolors = {
	Color(255,255,255,255),
	Color(60 ,60 ,60 ,255),
	Color(240,30 ,30 ,255),
	Color(30 ,240,30 ,255),
	Color(30 ,30 ,240,255),
	Color(240,240,30 ,255),
	Color(30 ,240,240,255),
	Color(240,30 ,240,255),
}

function GM:GetTeamColor(ent)
	return hatcolors[ent:GetNWInt("HatColor")] or hatcolors[1]
end

function GM:Move(pl, move)
	local fwd, sde = move:GetForwardSpeed(), -move:GetSideSpeed()
	
	if fwd~=0 and math.abs(fwd/sde)<0.2 then fwd = 0 end
	if sde~=0 and math.abs(sde/fwd)<0.2 then sde = 0 end
	
	if pl:GetNWInt("SkullState")==4 then
		-- bwahahahaha
		fwd, sde = -fwd, -sde
	end
	
	local spd
	if pl:GetNWInt("SkullState")==1 then
		spd = 42
	elseif pl:GetNWInt("SkullState")==5 then
		spd = 500
	else
		spd = pl:GetNWInt("Speed") or 85
	end
	
	if pl:GetNWBool("FPSMode") then
		if pl:Crouching() then spd = spd / 2 end
		local d = spd / math.sqrt(fwd*fwd + sde*sde)
		move:SetForwardSpeed(fwd * d)
		move:SetSideSpeed(-sde * d)
		return
	end
	
	if fwd~=0 or sde~=0 then
		local pos = pl:GetPos()
		local dx, dy = sign_val(fwd), sign_val(sde)
		local dxL, dyL = dy, -dx
		local dxR, dyR = -dy, dx
		
		local posL = pos + 15*Vector(dxL, dyL, 1)
		local posR = pos + 15*Vector(dxR, dyR, 1)
		
		local filter = player.GetAll()
		if CLIENT then
			table.Add(filter, ents.FindByClass("class C_PhysPropClientside"))
			table.Add(filter, ents.FindByClass("class C_ClientRagdoll"))
			table.Add(filter, ents.FindByClass("class C_HL2MPRagdoll"))
		end
		for _,v in pairs(ents.FindByClass("bm_prop_bomb")) do
			if self:ShouldCollide(pl, v)==false then
				table.insert(filter, v)
			end
		end
		
		local trL = util.TraceLine{start=pos, endpos=posL, filter=filter, mask=MASK_PLAYERSOLID}
		if not trL.Hit then
			trL = util.TraceLine{start=posL, endpos=posL+17*Vector(dx, dy, 0), filter=filter, mask=MASK_PLAYERSOLID}
		end
		
		local trR = util.TraceLine{start=pos, endpos=posR, filter=filter, mask=MASK_PLAYERSOLID}
		if not trR.Hit then
			trR = util.TraceLine{start=posR, endpos=posR+17*Vector(dx, dy, 0), filter=filter, mask=MASK_PLAYERSOLID}
		end
		
		if trL.Hit and not trR.Hit then
			fwd, sde = -sde, fwd
		elseif not trL.Hit and trR.Hit then
			fwd, sde = sde, -fwd
		end
		
		pl.MoveDirection = {x=fwd, y=sde}
		
		local vec = Vector(fwd, sde, 0)
		local yaw = vec:Angle().y
		
		local best, diff
		for _,v in ipairs(MoveAngles) do
			local d = math.abs(math.AngleDifference(yaw, v))
			if not diff or d<diff then
				diff, best = d, v
			end
		end
		
		move:SetSideSpeed(0)
		if pl:Crouching() then spd = spd / 2 end
		
		move:SetForwardSpeed(spd)
		
		pl.ViewAngles = Angle(0, best, 0)
	end
	
	if pl.ViewAngles then
		pl:SetEyeAngles(pl.ViewAngles)
	else
		pl.ViewAngles = pl:EyeAngles()
	end
end

function GM:ShouldCollide(a,b)
	if a:IsPlayer() and b:IsPlayer() then return false end
	
	if b:IsPlayer() and a:GetClass()=="bm_prop_bomb" then a,b = b,a end
	if a:IsPlayer() and b:GetClass()=="bm_prop_bomb" then
		if b.CollisionRules and b.CollisionRules[a]==false then
			return false
		else
			return true
		end
	end
	
	return self.BaseClass:ShouldCollide(a,b)
end
