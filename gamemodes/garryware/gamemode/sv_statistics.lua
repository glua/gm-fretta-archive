////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Statistics (server)                        //
////////////////////////////////////////////////

include("sh_statistics.lua")
include("cl_version.lua")
local stats = GM.GW_STATS

stats.PlayerTable = {}
--[[
COMPO
"SteamID" : "ID when first joined"
"Nick" : Nick when first joined
]]--

stats.PlayTable = {}
--[[
COMPO
1 : sMinigameDesc
2 : iWare
3 : iPhase
4 : WonLostUIDS
4.1 : Table of winners UIDS
4.2 : Table of losers UIDS
4.3 : Table of hold while on the server UIDS (unused)
5 : iTokens -- WARNING : A minigame can have phases with different tokens !
]]--

stats.SynthesisTable = {}
--[[
COMPO
1 : sMinigameDesc
2 : iWare
3 : iNumPhases
4 : itTokens
4.x : Tokens for a certain x phase (x < iNumPhase)
]]--
stats.RollupTable = {}

function GM:StatsManagePlayerJoined( ply )
	if not (ValidEntity( ply ) and ply:IsPlayer()) then return end
	local sSteamID = ply:SteamID()
	
	local UIDmatch = nil
	for uid,data in pairs( stats.PlayTable ) do
		if data.SteamID == sSteamID then
			
			UIDmatch = uid
			break -- HORROR MUSEUM
		end
	end
	
	if UIDmatch then
		self:StatsRestore( ply, UIDmatch )
		
	else
		self:StatsAddPlayer( ply )
		
	end
	
end

function GM:StatsRestore( ply, uid )
	ply.GWID = uid
	ply:SetFrags( stats.PlayerTable[ply.GWID].Won )
	ply:SetDeaths( stats.PlayerTable[ply.GWID].Lost )
	
	
end


-- TOKEN_GW_STATS : Remember to call this when game ends before doing any stats !
function GM:StatsStore( ply )
	if not ply.GWID then return end
	
	stats.PlayerTable[ply.GWID].Won  = ply:Frags()
	stats.PlayerTable[ply.GWID].Lost = ply:Deaths()
end

function GM:StatsAddPlayer( ply )
	if not (ValidEntity( ply ) and ply:IsPlayer()) then return end
	local UID = ply:UserID()
	
	if stats.PlayerTable[UID] then return end
	
	stats.PlayerTable[UID] = {}
	local pdat = stats.PlayerTable[UID]
	
	pdat.Nick    = ply:Nick()
	pdat.SteamID = ply:SteamID()
	
	pdat.Won = ply:SteamID()
	pdat.Lost = ply:SteamID()
	
	ply.GWID = UID
	
end

-- ALERT : Stats are gathered AFTER THE PreEndGame !
-- That means, if you have statuses to invalidate,
-- you have to do it AFTER PREENDGAME and not in PHASESIGNAL !
function GM:StatsUpdateMinigameInfo( )
	local iWare  = self.NumberOfWaresPlayed
	local iPhase = self.WarePhase_Current
	
	--local sMinigameName = self.Minigame.Name
	local iTokens = 0
	-- TOKEN_GW_STATS : Why do we use a function to get tokens and
	-- not a static in the minigame ?
	-- That's because tokens can vary with the different phases
	-- of a same minigame, or a minigame can use different tokens
	-- in real time.
	if self.Minigame.GetTokens then
		iTokens = self:StatsRawTableToBitwise( self.Minigame:GetTokens() or nil )
	end
	
	local sMinigameDesc = self.Minigame.Desc or ("<raw>" .. (self.Minigame.Name or "ERROR"))
	local data = { sMinigameDesc, iWare, iPhase, {{},{},{}}, iTokens }
	
	local WonLostHoldUIDS = data[4]
	
	for k,ply in pairs(player.GetAll()) do
		if not ply:IsWarePlayer() or ply:IsOnHold() then
			table.insert( WonLostHoldUIDS[3], ply.GWID )
		elseif not ply:GetAchieved() then
			table.insert( WonLostHoldUIDS[2], ply.GWID )
		else
			table.insert( WonLostHoldUIDS[1], ply.GWID )
		end
	end
	
	table.insert( stats.PlayTable, data )
	
end

-- TOKEN_GW_STATS : SHOULD CALL AFTER REMOVEUNPLAYABLE IN INIT
function StatsPoolMinigameDescriptions()
	local names = ware_mod.GetNamesTable()
	for _,name in pairs( names ) do
		local desc = ware_mod.Get(v).Desc
		
		if desc then
			umsg.PoolString( desc )
		end
	end
	
end

function GM:StatsCompress()
	stats._UIDTABLE = {}
	for uid,data in pairs( stats.PlayerTable ) do
		table.insert( stats._UIDTABLE, uid )
		stats.RollupTable[uid] = {}
		
	end
	
	stats._UID_TO_INDEX   = {}
	stats._UID_NOT_DUMPED = {}
	for index,uid in pairs( stats._UIDTABLE ) do
		stats._UID_TO_INDEX[uid]   = index
		stats._UID_NOT_DUMPED[uid] = true
		
	end
	
	for id,play in pairs( stats.PlayTable ) do
		-- SYNTHESIS
		local numSyn = #stats.SynthesisTable
		
		if (numSyn > 0) and (stats.SynthesisTable[numSyn][2] == play[2]) then
			stats.SynthesisTable[numSyn][3] = stats.SynthesisTable[numSyn][3] + 1
			table.insert( stats.SynthesisTable[numSyn][4], play[5] )
			
		else
			local composite = {}
			composite[1] = play[1]
			composite[2] = play[2]
			composite[3] = 1 -- iNumPhases
			composite[4] = { play[5] }
			table.insert( stats.SynthesisTable, composite )
		end
	
		-- ROLLUP
		local playerDump = table.Copy( stats._UID_NOT_DUMPED )
		
		-- Won: EVEN
		for _,uid in pairs( play[4][1] ) do
			local entries = #stats.RollupTable[uid]
			if (entries > 0) and ((stats.RollupTable[uid][entries] % 2) == 0) then
				stats.RollupTable[uid][entries] = stats.RollupTable[uid][entries] + 2
				
			else
				table.insert( stats.RollupTable[uid], 2 )
				
			end
			playerDump[uid] = false
			
		end
		
		-- Lost: UNEVEN
		for _,uid in pairs( play[4][2] ) do
			local entries = #stats.RollupTable[uid]
			if (entries > 0) and ((stats.RollupTable[uid][entries] % 2) == 1) then
				stats.RollupTable[uid][entries] = stats.RollupTable[uid][entries] + 2
				
			else
				-- THEN YOU NEED TO DO ((x + 1) / 2) to get the occurs, NOT ((x - 1) / 2)
				table.insert( stats.RollupTable[uid], 1 )
				
			end
			playerDump[uid] = false
			
		end
		
		for uid,status in pairs( playerDump ) do
			if status == true then
			local entries = #stats.RollupTable[uid]
				if (entries > 0) and ((stats.RollupTable[uid][entries] < 0)) then
					stats.RollupTable[uid][entries] = stats.RollupTable[uid][entries] - 1
					
				else
					table.insert( stats.RollupTable[uid], -1 )
					
				end
			end
			
		end
		
		
	end
	
end

function GM:StatsCR_MakeSynthesis()
	self:StatsCompress()
	return stats.SynthesisTable, stats.PlayerTable, stats.RollupTable

end


function GM:StatsCR_SynthesisToGLON()
	local tSta, tPta, tRta = self:StatsCR_MakeSynthesis()
	local glonSta = glon.encode( tSta )
	local glonPta = glon.encode( tPta )
	local glonRta = glon.encode( tRta )
	
	return glonSta, glonPta, glonRta
	
end

function GM:StatsCR_LogSynthesisGLON()
	local glonSta, glonPta, glonRta = self:StatsCR_SynthesisToGLON()
	
	local contents = "::MGD:" .. #stats.SynthesisTable .. "::PL:" .. #stats.PlayerTable .. "\n" .. glonSta .. "\n" .. glonPta .. "\n" .. glonRta .. "\n"
	
	filex.Append( "garryware/stats.txt", contents )
	
end

function GM:StatsCR_TryDecodeGLON()
	local tSta, tRta = self:StatsCR_MakeSynthesisRollup()
	local glonSta = glon.encode( tSta )
	local glonRta = glon.encode( tRta )
	
	print("GW_STATS:DC_GLON::")
	PrintTable( glon.decode( glonSta ) )
	PrintTable( glon.decode( glonRta ) )
	print("::GW_STATS")
	
end

function GM:StatsStream()
	-- HOLY JEEBUS.
	--Send players
	for uid,data in pairs( stats.PlayerTable ) do
		-- TOKEN_GW_STATS : Optimize
		umsg.Start("StatsPlayerData")
			umsg.Char( uid - 128 )
			umsg.String( data.Nick )
		umsg.End()
		
	end
	
	-- AT THE SAME TIME, TRY TO MAKE THE PLAYER CRASH,
	-- DUE TO UNOPTIMIZED CODE IN EDGE CASES.
	--Send minigames
	for i,data in pairs( stats.PlayTable ) do
		umsg.Start("StatsRollup")
			umsg.Char( i - 128 )
			umsg.String( data[1] )
			umsg.Char( data[2] - 128 )
			umsg.Char( data[3] - 128 )
			umsg.Char( #data[4][1] - 128 )
			umsg.Char( #data[4][2] - 128 )
			umsg.Char( #data[4][3] - 128 )
			for l,tp in pairs( data[4] ) do
				for k,uid in pairs( tp[l] ) do
					-- Remember, there actually could be 32 of these.
					-- I mean, does chat.AddText use more?
					umsg.Char( uid - 128 )
				end
			end
			-- TOKEN_GW_STATS : Send the bitwise thing or try to use Pooled Strings.
			umsg.Short( #data[5] - 128 )
		umsg.End()
	end
	
end


function GM:StatsUncompress()

end

function GM:StatsConsider()
	-- TOKEN_GW_STATS : Remember :
	-- If we encounter this situation
	
	-- COMPRESSED : 
	-- Minigame  -    2  3     4  5  6
	-- N-Phase   -    1  2     1  1  1
	-- Player A  - ..+2  1  2  3     2+...
	
	-- UNCOMPRESSED : 
	-- Minigame  -    2  3  3  4  5  6
	-- Phase     -    1  1  2  1  1  1
	-- Player A  -    1  0  1  0  0  1
	--
	-- THEN We have to consider that :
	-- Player A has scored a combo of 2 games that ended on game 4.
	--
	-- BECAUSE :
	-- A win/fail situation is determined by the FINAL phase.
	-- EVEN if player lock-lose before.
	-- Tokens however are accounted for the win/fail situation of the CURRENT PHASE.
	-- Tokens are taken as a whole. If a minigame has a Think phase 1 and Think phase 2, then
	-- the game accouts for TWO tokens.
	--- So if a player plays ONE minigame in the whole gamemode that has two THINK tokens,
	--- while he won ONE of then and lost the OTHER, no matter the ordering, then
	--- He will earn a "One out of two" as a scoring token.
end
