////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Serverside Initialization                  //
////////////////////////////////////////////////

-- Defaulted OFF !
CreateConVar( "ware_stats_enabled", 0, {FCVAR_ARCHIVE} )
DEBUG_DISABLE_STATS = not (GetConVar("ware_stats_enabled"):GetInt() > 0)

include( "shared.lua" )
include( "sh_tables.lua" )

include( "sv_awards.lua" )
include( "sv_effects.lua" )
include( "sv_entitygathering.lua" )
include( "sh_chataddtext.lua" )

include( "minigames_module.lua" )
include( "environment_module.lua" )
include( "entitymap_module.lua" )

include( "sv_filelist.lua" )
include( "sv_warehandy.lua" )
include( "sv_playerhandle.lua" )
include( "sv_frettarelated.lua" )

if not DEBUG_DISABLE_STATS then
	include( "sv_statistics.lua" )
end

GM.TakeFragOnSuicide = false

-- Serverside Vars
GM.GamesArePlaying = false
GM.GameHasEnded = false
GM.WareHaveStarted = false
GM.ActionPhase = false

GM.WareOverrideAnnouncer = false
GM.WareShouldNotAnnounce = false
GM.WarePhase_Current = 0
GM.WarePhase_NextLength = 0

GM.WareLen = 100
GM.Windup = 2
GM.NextgameStart = 0
GM.NextgameEnd = 0

GM.NumberOfWaresPlayed = -1

--DEBUG
CreateConVar( "ware_debug", 0, {FCVAR_ARCHIVE} )
CreateConVar( "ware_debugname", "", {FCVAR_ARCHIVE} )

--[[
ware_debug 0 : Plays normal mode.
ware_debug 1 : Plays continuously <ware_debugname>, waiting time stripped.
ware_debug 2 : Plays normal mode, waiting time stripped.
ware_debug 3 : Plays normal mode, waiting time stripped, intro sequence skipped.
( Please don't skip gamemode intro, it is actually
required to make sure players have loaded some files )
]]--

-- Ware internal functions.

function GM:HasEveryoneLocked()
	local playertable = team.GetPlayers(TEAM_HUMANS)

	local i = 1
	while ( (i <= #playertable) and playertable[i]:GetLocked() ) do
		i = i + 1
	end
	if (i <= #playertable) then
		return false
	end
	
	return true
end

function GM:CheckGlobalStatus( endOfGameBypassValidation )
	if team.NumPlayers(TEAM_HUMANS) < 2 then return false end
	
	local playertable = team.GetPlayers(TEAM_HUMANS)
	
	
	-- Has everyone validated their status ?
	-- (Don't do that if it's the end of the game. Call Check first ONCE, then validate
	-- with bypass of the lock if that function returned true.)
	if not(endOfGameBypassValidation) then
		if not GAMEMODE:HasEveryoneLocked() then return false end
	end
	
	-- Do everyone have the same status ?
	local probableStatus = playertable[1]:GetAchieved()
	i = 2
	while ( (i <= #playertable) and (playertable[i]:GetAchieved() == probableStatus) ) do
		i = i + 1
	end
	if (i <= #playertable) then
		return false
	elseif probableStatus == nil then
		return false
	end
	
	-- TEST : Re-test this.
	if not (endOfGameBypassValidation and GAMEMODE:HasEveryoneLocked()) then
		-- Note from Ha3 : OMG, check the usermessage types next time. 1 hour waste
		--local rp = RecipientFilter()
		--rp:AddAllPlayers( )
		umsg.Start("gw_yourstatus", nil)
			umsg.Bool(probableStatus)
			umsg.Bool(true)
		umsg.End()
	end
	
	return true , probableStatus
end

function GM:SendEveryoneEvent( probable )
	--local rpAll = RecipientFilter()
	--rpAll:AddAllPlayers()
	
	umsg.Start("EventEveryoneState", nil)
		umsg.Bool( probable )
	umsg.End()
end

////////////////////////////////////////////////
////////////////////////////////////////////////
-- Ware cycles.

function GM:PickRandomGame()
	self.WareHaveStarted = true
	self.WareOverrideAnnouncer = false

	self.WarePhase_Current = 1
	self.WarePhase_NextLength = 0
	
	self:ResetWareAwards( )
	
	-- Standard initialization
	for k,v in pairs(player.GetAll()) do 
		v:SetLockedSpecialInteger(0)
		v:RemoveFirst( )
		v:StripWeapons()
	end
	
	self.Minigame = ware_mod.CreateInstance(self.NextGameName)
	
	-- Ware is initialized
	if self.Minigame and self.Minigame.Initialize and self.Minigame.StartAction then
		self.Minigame:Initialize()
		
	else
		self.Minigame = ware_mod.CreateInstance("_empty")
		self:SetWareWindupAndLength(0, 3)
		
		GAMEMODE:SetPlayersInitialStatus( false )
		GAMEMODE:DrawInstructions( "Error with minigame \""..self.NextGameName.."\"." )
		
	end
	self.NextgameEnd = CurTime() + self.Windup + self.WareLen
	
	self.NumberOfWaresPlayed = self.NumberOfWaresPlayed + 1
	
	if not self.WareOverrideAnnouncer then
		self.WareOverrideAnnouncer = self.DefaultAnnouncerID or math.random(1, #GAMEMODE.WASND.BITBL_TimeLeft )
	end
	
	local iLoopToPlay = ( (self.Windup + self.WareLen) >= 10 ) and 2 or 1
	
	-- Send info about ware
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start("NextGameTimes", rp)
		umsg.Float( CurTime() + self.Windup )
		umsg.Float( self.NextgameEnd )
		umsg.Float( self.Windup )
		umsg.Float( self.WareLen )
		umsg.Bool( self.WareShouldNotAnnounce )
		umsg.Bool( true )
		umsg.Char( 1 )
		umsg.Char( math.random(1, #GAMEMODE.WASND.TBL_GlobalWareningNew ) )
		umsg.Char( self.WareOverrideAnnouncer )
		umsg.Char( iLoopToPlay )
	umsg.End()
	self.WareShouldNotAnnounce = false
end

function GM:TryNextPhase( )
	if self.WarePhase_NextLength <= 0 then return false end
	
	-- TOKEN_GW_STATS : Need to enable stats gathering HERE !
	-- Dont forget the other one.
	-- We do it here AFTER we know that there is a next phase, and
	-- BEFORE changing the phase number
	if not DEBUG_DISABLE_STATS then self:StatsUpdateMinigameInfo() end
	
	self.WarePhase_Current = self.WarePhase_Current + 1
	
	self.WareLen = self.WarePhase_NextLength
	self.NextgameEnd = CurTime() + self.WarePhase_NextLength
	
	self.WarePhase_NextLength = 0
	
	-- self.Minigame == nil should never happen
	if self.Minigame and self.Minigame.PhaseSignal then
		self.Minigame:PhaseSignal( self.WarePhase_Current )
		
	end
	
	local iLoopToPlay = ( (self.Windup + self.WareLen) >= 10 ) and 2 or 1
	
	--local rp = RecipientFilter()
	--rp:AddAllPlayers()
	umsg.Start("NextGameTimes", nil)
		umsg.Float( 0 )
		umsg.Float( self.NextgameEnd )
		umsg.Float( self.Windup )
		umsg.Float( self.WareLen )
		umsg.Bool( self.WareShouldNotAnnounce )
		umsg.Bool( true )
		umsg.Char( 4 )
		umsg.Char( math.random(1, #GAMEMODE.WASND.TBL_GlobalWareningPhase ) )
		umsg.Char( self.WareOverrideAnnouncer )
		umsg.Char( iLoopToPlay )
	umsg.End()
	self.WareShouldNotAnnounce = false
	
	return true
end

function GM:GetCurrentMinigameName()
	return (self.Minigame and self.Minigame.Name) or ""
end

function GM:EndGame()
	if self.WareHaveStarted == true then
	
		-- Destroy all
		if self.ActionPhase == true then
			GAMEMODE:UnhookTriggers()
			self.ActionPhase = false
		end
		if self.Minigame and self.Minigame.EndAction then self.Minigame:EndAction() end
		self:RemoveEnts()
		
		local everyoneStatusIsSame, probable = GAMEMODE:CheckGlobalStatus( true )
		if (everyoneStatusIsSame and not GAMEMODE:HasEveryoneLocked()) then
			self:SendEveryoneEvent( probable )
		end
		
		-- Generic stuff on player.
		local rpWin = RecipientFilter()
		local rpLose = RecipientFilter()
		for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
			v:ApplyLock( everyoneStatusIsSame )
			
			local bAchieved = v:GetAchieved()
			if (bAchieved) then
				rpWin:AddPlayer(v)
			else
				rpLose:AddPlayer(v)
			end
			
			-- Reinit player
			v:RestoreDeath()
			v:StripWeapons()
			v:RemoveAllAmmo( )
			v:Give("weapon_physcannon")
			
			-- Clear decals : NOTE : Now done clientside on signal, it saves from a stringstream
			--v:ConCommand("r_cleardecals")
		end
		
		-- TOKEN_GW_STATS : Need to enable stats gathering HERE !
		-- We do it there because players are locked after this moment.
		-- Dont forget the other one.
		if not DEBUG_DISABLE_STATS then self:StatsUpdateMinigameInfo() end
		
		-- Send positive message to the RP list of winners.
		umsg.Start("EventEndgameTrigger", rpWin)
			umsg.Bool( true )
			umsg.Char( math.random(1, #GAMEMODE.WASND.TBL_GlobalWareningWin ) )
		umsg.End()
		
		-- Send negative message to the RP list of losers.
		umsg.Start("EventEndgameTrigger", rpLose)
			umsg.Bool( false )
			umsg.Char( math.random(1, #GAMEMODE.WASND.TBL_GlobalWareningLose ) )
		umsg.End()
		
		if (team.NumPlayers(TEAM_SPECTATOR) ~= 0) then
			local rpSpec = RecipientFilter()
			for k,v in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
				--Do generic stuff to specs
				
				rpSpec:AddPlayer( v )
				--v:ConCommand("r_cleardecals")
			end
			
			umsg.Start("EventEndgameTrigger", rpSpec)
				umsg.Bool( false )
				umsg.Char( math.random(1, #GAMEMODE.WASND.TBL_GlobalWareningLose ) )
			umsg.End()
		end
	end
	
	self.NextgameStart = CurTime() + self.WADAT.EndFlourishTime
	local tCount = team.GetPlayers( TEAM_HUMANS )
	if #tCount >= 5 then
		local iWinFailPercent = 0
		local iCount = 0
		for k,ply in pairs( team.GetPlayers( TEAM_HUMANS ) ) do
			if ply:GetAchieved() then
				iCount = iCount + 1
			end
		end
		
		iWinFailPercent = math.floor( iCount / #tCount * 100 )
		umsg.Start("Transit", nil)
			umsg.Char( iWinFailPercent )
		umsg.End()
	
	end
	
	-- Reinitialize
	self.WareHaveStarted = false
	
	--Enough time to play ?
	if ((self.TimeWhenGameEnds - CurTime()) < self.NotEnoughTimeCap) then
		self:EndOfGame( true )
	else
		--Ware is picked up now
		self:PickRandomGameName()
	end
end

function GM:PickRandomGameName( bFirst )
	local env
	
	if GetConVar("ware_debug"):GetInt() == 1 then
		self.NextGameName = GetConVar("ware_debugname"):GetString()
		env = ware_env.FindEnvironment(ware_mod.Get(self.NextGameName).Room) or self.CurrentEnvironment
		
	elseif bFirst and (GetConVar("ware_debug"):GetInt() % 2 == 0) then
		self.NextGameName = "_intro"
		env = ware_env.FindEnvironment(ware_mod.Get(self.NextGameName).Room) or self.CurrentEnvironment
		
	else
		self.NextGameName, env = ware_mod.GetRandomGameName()
		
	end
	
	if env ~= self.CurrentEnvironment then
		self.CurrentEnvironment = env
		self.NextgameStart = self.NextgameStart + self.WADAT.TransitFlourishTime
		self.NextPlayerRespawn = CurTime() + self.WADAT.EndFlourishTime
		
	end
	
end

function GM:PhaseIsPrelude()
	return CurTime() < (self.NextgameStart + self.Windup)
end

function GM:HookTriggers()
	local hooks = self.Minigame.Hooks
	if not hooks then return end
	
	for hookname,callback in pairs(hooks) do
		hook.Add(hookname, "WARE"..self.Minigame.Name..hookname,callback)
	end
end

function GM:UnhookTriggers()
	local hooks = self.Minigame.Hooks
	if not hooks then return end
	
	for hookname,_ in pairs(hooks) do
		hook.Remove(hookname, "WARE"..self.Minigame.Name..hookname)
	end
end



////////////////////////////////////////////////
////////////////////////////////////////////////
-- Ware game times.

function GM:SetNextGameStartsIn( delay )
	self.NextgameStart = CurTime() + delay
	SendUserMessage( "GameStartTime" , nil, self.NextgameStart )
end	

function GM:Think()
	self.BaseClass:Think()
	
	if (self.GamesArePlaying == true) then
		if (self.WareHaveStarted == false) then
			-- Starts a new ware
			if (CurTime() > self.NextgameStart) then
				self:PickRandomGame()
				SendUserMessage("WaitHide")
			end
			
			-- Eventually, respawn all players
			if self.NextPlayerRespawn and CurTime() > self.NextPlayerRespawn then
				self:RespawnAllPlayers()
				self.NextPlayerRespawn = nil
			end
		
		else
			-- Starts the action
			if CurTime() > (self.NextgameStart + self.Windup) and self.ActionPhase == false then
				if self.Minigame then
					self:HookTriggers()
					if self.Minigame.StartAction then
						self.Minigame:StartAction()
					end
				end
				
				self.ActionPhase = true
			end
			
			-- Ends the current ware
			if (CurTime() > self.NextgameEnd) then
				if self.Minigame.PreEndAction then
					self.Minigame:PreEndAction()
				end
				
				-- TOKEN_GW_STATS : Stats are gathered separately either in (TryNextPhase XOR EndGame), NEVER BOTH.
				if not self:TryNextPhase( ) then
					self:EndGame()
				end
				
			end
			
		end
		
		
		
		-- Ends a current game, because of lack of players
		if team.NumPlayers(TEAM_HUMANS) == 0 then
			self.GamesArePlaying = false
			GAMEMODE:EndGame()
			
			-- Send info about ware
			--local rp = RecipientFilter()
			--rp:AddAllPlayers()
			umsg.Start("NextGameTimes", nil)
				umsg.Float( 0 )
				umsg.Float( 0 )
				umsg.Float( 0 )
				umsg.Float( 0 )
				umsg.Bool( false )
				umsg.Bool( false )
			umsg.End()
			
		elseif self.FirstTimePickGame and CurTime() > self.FirstTimePickGame then
			-- Game has just started, pick the first game
			self:PickRandomGameName( true )
			self.FirstTimePickGame = nil
		end
	
	else
		-- Starts a new game
		if team.NumPlayers(TEAM_HUMANS) > 0 and self.GameHasEnded == false then
			self.GamesArePlaying = true
			self.WareHaveStarted = false
			self.ActionPhase = false
			
			if ( GetConVar("ware_debug"):GetInt() > 0 ) then
				self:SetNextGameStartsIn( 4 )
				self.FirstTimePickGame = 1.3
				
			else
				self:SetNextGameStartsIn( 27 )
				self.FirstTimePickGame = 19.3
				
			end
			SendUserMessage("WaitShow")
		end
	end
	
	self:TryFindStuck()
	
end

function GM:TryFindStuck()
	for k,ply in pairs(team.GetPlayers( TEAM_HUMANS )) do
		if ValidEntity(ply) then
			local plyPhys = ply:GetPhysicsObject()
			if plyPhys:IsValid() and plyPhys ~= NULL then
				if plyPhys:IsPenetrating() then
					ply:SetNoCollideWithTeammates( true )
					if not ply._WasStuckOneTime then
						ply._WasStuckOneTime = true
						print("Found player " .. ply:Nick() .. " stuck!")
					end
					
				elseif ply:GetNoCollideWithTeammates( ) then
					ply:SetNoCollideWithTeammates( false )
				
				end
				
			end
		
		end
		
	end
	
end

function GM:WareRoomCheckup()
	if #ents.FindByClass("func_wareroom") == 0 then
		for _,v in pairs(ents.FindByClass("gmod_warelocation")) do
			v:SetNotSolid(true)
			
		end
	
	else
		for _,v in pairs(ents.FindByClass("info_player_start")) do
			-- That's not a real ware location, but a dummy entity
			-- for making info_player_start entities detectable by the trigger
			local temp = ents.Create("gmod_warelocation")
			temp:SetPos(v:GetPos())
			temp:Spawn()
			temp.PlayerStart = v
			
		end
		
	end
	
end

function GM:InitPostEntity( )
	self.BaseClass:InitPostEntity()
	
	self:WareRoomCheckup()
	
	RemoveUnplayableMinigames()

	self.GamesArePlaying = false
	self.WareHaveStarted = false
	self.ActionPhase = false
	self.GameHasEnded = false
	
	self.NextgameStart = CurTime() + 8
	
	self.TimeWhenGameEnds = CurTime() + self.GameLength * 60.0
	
	for _,v in pairs(ents.FindByClass("func_wareroom")) do
		ware_env.Create(v)
	end
	
	-- No environment found, create the default one
	if #ware_env.GetTable() then
		ware_env.Create()
	end
	
	-- Start with a generic environment
	self.CurrentEnvironment = ware_env.FindEnvironment("generic")
	
	-- Create the precache table
	for k,name in pairs(ware_mod.GetNamesTable()) do
		if (ware_mod.Get(name).GetModelList) then
			for j,model in pairs(ware_mod.Get(name):GetModelList() or {}) do
				if (type(model) == "string") and (not table.HasValue( self.ModelPrecacheTable , model )) then
					table.insert( self.ModelPrecacheTable , model )
					
				end
				
			end
			
		end
		
	end
	
	-- Search for decoration
	local tOriginEnt = ents.FindByName("deco_center")
	local tExtremaEnt = ents.FindByName("deco_extrema")
	if #tOriginEnt > 0 and #tExtremaEnt > 0 then
		local origin  = tOriginEnt[1]
		local extrema = tExtremaEnt[1]
		self.Decoration_Origin  = origin:GetPos()
		self.Decoration_Extrema = extrema:GetPos()
	end
	
end

/*
-- (Ha3) Silent fall damage leg break sound ? Didn't work.
function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	if ent:IsPlayer() and dmginfo:IsFallDamage() then
		dmginfo:ScaleDamage( 0 )
		return false
	end
end
*/


////////////////////////////////////////////////
////////////////////////////////////////////////
-- Minigame Inclusion.

function IncludeMinigames()
	local path = string.Replace(GM.Folder, "gamemodes/", "").."/gamemode/wareminigames/"
	local names = {}
	local authors = {}
	local str = ""
	
	for _,file in pairs( file.FindInLua(path.."*.lua") ) do
		WARE = {}
		
		--AddCSLuaFile(path..file)
		include(path..file)
		
		local gamename = string.Replace(file, ".lua", "")
		ware_mod.Register(gamename, WARE)
	end
	
	print("__________\n")
	names = ware_mod.GetNamesTable()
	str = "Added wares ("..#names..") : "
	for k,v in pairs(names) do
		str = str.."\""..v.."\" "
	end
	print(str)
	
	authors = ware_mod.GetAuthorTable()
	str = "Author [wares] : "
	for k,v in pairs(authors) do
		str = str.." "..k.." ["..v.." wares]  "
	end
	print(str)
	print("__________\n")
end

function RemoveUnplayableMinigames()
	local names = ware_mod.GetNamesTable()
	local removed = {}
	
	for _,v in pairs(ware_mod.GetNamesTable()) do
		if not ware_env.HasEnvironment(ware_mod.Get(v).Room) then
			table.insert(removed,v)
			ware_mod.Remove(v)
		end
	end
	
	print("__________\n")
	str = "Removed wares ("..#removed..") : "
	for k,v in pairs(removed) do
		str = str.."\""..v.."\" "
	end
	print(str)
	print("__________\n")
end


////////////////////////////////////////////////
////////////////////////////////////////////////
-- Start up.

IncludeMinigames()
if not DEBUG_DISABLE_STATS then StatsPoolMinigameDescriptions() end

////////////////////////////////////////////////
////////////////////////////////////////////////