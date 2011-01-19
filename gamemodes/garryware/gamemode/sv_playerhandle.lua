////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Player Handle and Model Precache           //
////////////////////////////////////////////////

function GM:PlayerCanHearPlayersVoice( pListener, pTalker )
	return true
end

function GM:PlayerInitialSpawn( ply, id )
	self.BaseClass:PlayerInitialSpawn( ply, id )
	
	ply.m_tokens = {}

	-- Give him info about the current status of the game
	local didnotbegin = false
	if (self.NextgameStart > CurTime()) then
		didnotbegin = true
	end
	
	umsg.Start("ServerJoinInfo", ply )
		umsg.Float( self.TimeWhenGameEnds )
		umsg.Bool( didnotbegin )
	umsg.End()
	umsg.Start("BestStreakEverBreached", ply )
		umsg.Long( self.BestStreakEver )
	umsg.End()
	
	if self.Decoration_Origin then
		umsg.Start("DecorationInfo", ply )
			umsg.Vector( self.Decoration_Origin )
			umsg.Vector( self.Decoration_Extrema )
		umsg.End()
	end
	
	self:SendModelList( ply )
	
	ply:SetComboSpecialInteger( 0 )
	
	-- TOKEN_GW_STATS : Need to add player if not already done NOW !
	if not DEBUG_DISABLE_STATS then self:StatsManagePlayerJoined( ply ) end
end

function GM:PlayerDisconnected( ply )
	-- TOKEN_GW_STATS : Need to store last data NOW !
	if not DEBUG_DISABLE_STATS then self:StatsStore( ply ) end
	
end

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn( ply )
	
	ply:CrosshairDisable()
	ply:RestoreDeath()
	
	if (ply._forcespawntime or 0) < (CurTime() - 0.3) then
		ply:SetAchievedSpecialInteger( -1 )
		ply:SetLockedSpecialInteger( 1 )
	end
	
	-- TODO
	-- Double send it because sometime it crashes
	if self.Decoration_Origin then
		umsg.Start("DecorationInfo", ply )
			umsg.Vector( self.Decoration_Origin )
			umsg.Vector( self.Decoration_Extrema )
		umsg.End()
	end
	
end

function GM:PlayerSelectSpawn(ply)
	if ply.ForcedSpawn then
		local spawn = ply.ForcedSpawn
		ply.ForcedSpawn = nil
		return spawn
	end
	
	local spawns
	
	if self.CurrentEnvironment then
		spawns = self.CurrentEnvironment.PlayerSpawns
	end
	
	if not spawns or #spawns==0 then
		spawns = ents.FindByClass("info_player_start")
	end
	
	return spawns[math.random(1,#spawns)]
end


function GM:PlayerDeath( victim, weapon, killer )
	self.BaseClass:PlayerDeath( victim, weapon, killer )
	victim:RestoreDeath()
	victim:ApplyLose()
	
end

function GM:RespawnAllPlayers( bNoMusicEvent, bForce )
	if not self.CurrentEnvironment then return end
	
	local rp = RecipientFilter()
	
	local spawns = {}
	
	-- Priority goes to active players, so they don't spawn in each other
	for _,v in pairs( team.GetPlayers(TEAM_HUMANS) ) do
		if bForce or (v:GetEnvironment() ~= self.CurrentEnvironment) then
			if #spawns == 0 then
				spawns = table.Copy( self.CurrentEnvironment.PlayerSpawns )
			end
		
			--No need to draw the effect no one sees them
			--self:MakeDisappearEffect( v:GetPos() )
			local loc = table.remove(spawns, math.random(1, #spawns) )
			
			v.ForcedSpawn = loc
			if bForce then v._forcespawntime = CurTime() end
			v:Spawn( )
			
			rp:AddPlayer(v)
		end
	end
	
	for _,v in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
		if v:GetEnvironment() ~= self.CurrentEnvironment then
			if #spawns == 0 then
				spawns = table.Copy(self.CurrentEnvironment.PlayerSpawns)
			end
		
			local loc = table.remove( spawns, math.random(1, #spawns) )
			
			v.ForcedSpawn = loc
			v:Spawn()
			
			rp:AddPlayer(v)
		end
	end
	
	umsg.Start("PlayerTeleported", rp)
		umsg.Bool(bNoMusicEvent or false)
		umsg.Char( math.random(1, #GAMEMODE.WASND.TBL_GlobalWareningTeleport ) )
	umsg.End()
end

////////////////////////////////////////////////
////////////////////////////////////////////////
-- Model List.

function GM:SendModelList( ply )
	if #self.ModelPrecacheTable <= 0 then return end
	
	local messageSplit = 3
	
	local count = #self.ModelPrecacheTable
	local splits = math.ceil(#self.ModelPrecacheTable / messageSplit)
	
	local lastSplit = #self.ModelPrecacheTable % messageSplit
	local model = ""
	
	for i=1,splits do
		local toSend = ((i < splits) and messageSplit) or lastSplit
		
		umsg.Start("ModelList", ply)
			umsg.Long(toSend)
			for k=1,toSend do
				model = self.ModelPrecacheTable[ (i - 1) * messageSplit + k ]
				umsg.String( model )
			end
		umsg.End()
		
	end
end
