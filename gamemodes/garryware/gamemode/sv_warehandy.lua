////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Functions used on Wares (but not only by)  //
////////////////////////////////////////////////

function GM:SetWareWindupAndLength(windup , len)
	self.Windup  = windup
	self.WareLen = len
end

function GM:OverrideAnnouncer( id )
    if (1 <= id) and (id <= #self.WASND.BITBL_TimeLeft) then
		self.WareOverrideAnnouncer = id
	end
end

function GM:ForceNoAnnouncer( )
    self.WareShouldNotAnnounce = true
end

function GM:DrawToPlayersGeneralInstructions( tPlayersInput, bInvert, sInstructions , optColorPointer , optTextColorPointer )
	local rpPlayers = RecipientFilter()
	if bInvert then
		rpPlayers:AddAllPlayers()
		for k,ply in pairs( tPlayersInput ) do
			rpPlayers:RemovePlayer( ply )
		end
	
	else
		for k,ply in pairs( tPlayersInput ) do
			rpPlayers:AddPlayer( ply )
		end
		
	end
	
	self:DrawInstructions( sInstructions , optColorPointer , optTextColorPointer , rpPlayers )
end

function GM:DrawInstructions( sInstructions , optColorPointer , optTextColorPointer , optrpFilter )
	local rp = optrpFilter or nil
			
	umsg.Start( "gw_instructions", rp )
	umsg.String( sInstructions )
	-- If there is no color, no chars about the color are passed.
	umsg.Bool( optColorPointer ~= nil )
	if (optColorPointer ~= nil) then
		-- If there is a background color, a bool stating about the presence
		-- of a text color must be passed, even if there is no text color !
		umsg.Bool( optTextColorPointer ~= nil )

		umsg.Char( optColorPointer.r - 128 )
		umsg.Char( optColorPointer.g - 128 )
		umsg.Char( optColorPointer.b - 128 )
		umsg.Char( optColorPointer.a - 128 )
		
		if (optTextColorPointer ~= nil) then
			umsg.Char( optTextColorPointer.r - 128 )
			umsg.Char( optTextColorPointer.g - 128 )
			umsg.Char( optTextColorPointer.b - 128 )
			umsg.Char( optTextColorPointer.a - 128 )
		end
	end
	umsg.End()
end

function GM:SetPlayersInitialStatus(isAchievedNilIfMystery)
	-- nil as an achieved status then can only be set globally (start of game).
	-- Use it for games where the status is set on Epilogue (not Ending), while
	-- the players shouldn't know if they won or not.
	-- Example : Watch the props ! / Stand on the missing prop ! (ver.2)
	
	for k,v in pairs(player.GetAll()) do 
		v:SetAchievedSpecialInteger( ((isAchievedNilIfMystery == nil) and -1) or ((isAchievedNilIfMystery) and 1) or 0 )
	end
	
end

function GM:SendEntityTextColor( rpfilterOrPlayer, entity, r, g, b, a )
	umsg.Start("EntityTextChangeColor", rpfilterOrPlayer)
		umsg.Entity( entity )
		umsg.Char( r - 128 )
		umsg.Char( g - 128 )
		umsg.Char( b - 128 )
		umsg.Char( a - 128 )
	umsg.End()
end

////////////////////////////////////////////////
////////////////////////////////////////////////
-- Phases.

function GM:SetNextPhaseLength( fTime )
	self.WarePhase_NextLength = (fTime > 0) and fTime or 0
	
end

function GM:GetCurrentPhase( fTime )
	return self.WarePhase_Current
end

////////////////////////////////////////////////
////////////////////////////////////////////////
-- Special overrides.

function GM:SetNextGameEnd(time)
	if not self.WareHaveStarted or not self.ActionPhase then return end
	
	local t = CurTime()
	
	-- Prevents dividing by zero
	if (t - time ~= 0) and (t - self.NextgameEnd ~= 0) then
		self.WareLen = self.WareLen * (t - time) / (t - self.NextgameEnd)
	end
	
	self.NextgameEnd = time
	
	--local rp = RecipientFilter()
	--rp:AddAllPlayers()
	umsg.Start("NextGameTimes", nil)
		umsg.Float( 0 )
		umsg.Float( self.NextgameEnd )
		umsg.Float( self.Windup )
		umsg.Float( self.WareLen )
		umsg.Bool( true )
		umsg.Bool( true )
		umsg.Char( 1 )
		umsg.Char( math.random(1, #GAMEMODE.WASND.TBL_GlobalWareningNew ) )
		umsg.Char( self.WareOverrideAnnouncer )
	umsg.End()
end

////////////////////////////////////////////////
////////////////////////////////////////////////
-- Entity trash bin functions.

function GM:AppendEntToBin( ent )
	table.insert(GAMEMODE.WareEnts,ent)
end

function GM:RemoveEnts()
	for k,v in pairs(GAMEMODE.WareEnts) do
		if (ValidEntity(v)) then
			GAMEMODE:MakeDisappearEffect(v:GetPos())
			v:Remove()
		end
	end
end

////////////////////////////////////////////////
////////////////////////////////////////////////

--In init but useable
--function GM:RespawnAllPlayers( bNoMusicEvent, bForce )
--function GM:HookTriggers()
--function GM:PhaseIsPrelude()

////////////////////////////////////////////////
////////////////////////////////////////////////