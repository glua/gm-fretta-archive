
MAX_ZOMBIES = 20
local function SPModeSpawnZombie()
	if #ents.FindByClass("npc_zombie") > MAX_ZOMBIES then return end
	
	local validPositions = {}
	for x=1,GAMEMODE.Map.W do
		for y=1,GAMEMODE.Map.H do
			if GAMEMODE:IsFreeCell(x, y) then
				table.insert(validPositions, {x,y})
			end
		end
	end
	
	if #validPositions==0 then return end
	
	local c = table.Random(validPositions)
	local z = ents.Create("npc_zombie")
	z:SetPos(GAMEMODE:CellToPosition(c[1], c[2]))
	z:SetAngles(Angle(0, math.Rand(-180,180), 0))
	z:Spawn()
end
timer.Create("ZombieSpawnTimer", 5, 0, SPModeSpawnZombie)
timer.Stop("ZombieSpawnTimer")

--[[---------------------------------------------------
  Fretta shit goes here
-----------------------------------------------------]]

function GM:GetAlivePlayers()
	local t = {n=0}
	for _,v in pairs(team.GetPlayers(TEAM_BOMBERS)) do
		if v:Alive() and v:Health()==1 then
			t.n = t.n + 1
			table.insert(t, v)
		end
	end
	
	return t
end

function GM:CheckRoundEnd()
	if not self:InRound() or self.SinglePlayerMode then return end
	
	local t = self:GetAlivePlayers()
	
	if t.n <= 1 then
		self:RoundEndWithResult(t[1])
	end
end

function GM:RoundTimerEnd()
	if not self:InRound() then return end
	self:RoundEndWithResult(-2)
end

function GM:OnRoundStart()
	if self.SinglePlayerMode then
		MsgN("Singleplayer mode is on")
	else
		MsgN("Singleplayer mode is off")
	end
	
	UTIL_UnFreezeAllPlayers()
end


function GM:ProcessResultText(result)
	local text
	
	if type(result)=="number" or not ValidEntity(result) then
		return "lol it's a draw"
	else
		return result:GetName().." wins lololo"
	end
end

function GM:ShowPostRoundScoreboard(pl, newscore)
	umsg.Start("ShowPostRoundScoreboard")
		umsg.Entity(pl)
		umsg.Short(newscore)
	umsg.End()
end

function GM:HidePostRoundScoreboard()
	umsg.Start("HidePostRoundScoreboard")
	umsg.End()
end

function GM:RoundEndWithResult(result)
	if self.SinglePlayerMode then
		timer.Stop("ZombieSpawnTimer")
	end
	
	if not result then
		result = -1
	end
	
	resulttext = self:ProcessResultText(result)
	
	if type(result)=="number" then
		self:SetRoundResult(result, resulttext)
		self:RoundEnd()
		self:OnRoundResult(result, resulttext)
	else
		self:SetRoundWinner(result, resulttext)
		self:RoundEnd()
		self:OnRoundWinner(result, resulttext)
	end
	
end

function GM:OnRoundWinner(pl)
	if type(pl)=="Player" then
		local score = pl:GetNWInt("Victories") + 1
		self.LastRoundWinner = pl
		timer.Simple(3, self.ShowPostRoundScoreboard, self, pl, score)
	end
end

function GM:OnEndOfGame()
	for k,v in pairs(player.GetAll()) do
		v:Freeze(true)
	end
	
	timer.Simple(self.VotingDelay, self.HidePostRoundScoreboard, self)
end

function GM:OnPreRoundStart(num)
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
	if ValidEntity(self.LastRoundWinner) then
		self.LastRoundWinner:SetNWInt("Victories", self.LastRoundWinner:GetNWInt("Victories") + 1)
		self.LastRoundWinner = nil
	end
		
	local n = team.NumPlayers(TEAM_BOMBERS)
	self.SinglePlayerMode = (n == 1)
	
	-- Always start with a pre-game mode, so incoming players can start playing immediately
	if self.SinglePlayerMode then
		self.NoAutomaticSpawning = false
		self.RoundLength = 2*60
		SetGlobalInt("RoundNumber", 0)
		timer.Start("ZombieSpawnTimer")
		CrateRatio = 0.4
		ItemRatio = 0.6
	else
		self.NoAutomaticSpawning = true
		self.RoundLength = 3*60
		timer.Stop("ZombieSpawnTimer")
		CrateRatio = 0.7
		ItemRatio = 0.6
	end
	
	for _,v in pairs(team.GetPlayers(TEAM_BOMBERS)) do
		v.NumBombs = 0
	end
	
	self:ResetMap()
	
	self:HidePostRoundScoreboard()
end

function GM:CanStartRound()
	local n = team.NumPlayers(TEAM_BOMBERS)
	return n>0
end

function GM:HasReachedRoundLimit()
	for _,v in pairs(player.GetAll()) do
		if self.LastRoundWinner==v and v:GetNWInt("Victories")+1>=self.RoundLimit then
			return true
		end
	end
	return false
end
