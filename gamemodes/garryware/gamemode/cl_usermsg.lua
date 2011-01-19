////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Usermessages and VGUI                      //
////////////////////////////////////////////////

gws_NextgameStart = 0
gws_NextwarmupEnd = 0
gws_NextgameEnd = 0
gws_WarmupLen = 0
gws_WareLen = 0
gws_TimeWhenGameEnds = 0
gws_TickAnnounce = 0

gws_PrecacheSequence = 0

gws_CurrentAnnouncer = 1

gws_AmbientMusic = {}
gws_AmbientMusic_dat = {}
gws_AmbientMusicIsOn = false

-- TODO DEBUG : SET TO FALSE AFTER EDITING !
gws_AtEndOfGame = false


local function DecorationInfo( m )
	local origin  = m:ReadVector()
	local extrema = m:ReadVector()
	
	GAMEMODE:MapDecoration( origin, extrema )
end
usermessage.Hook( "DecorationInfo", DecorationInfo )

local function ModelList( m )
	local numberOfModels = m:ReadLong()
	local currentModelCount = #GAMEMODE.ModelPrecacheTable
	local model = ""
	
	for i=1,numberOfModels do
		table.insert( GAMEMODE.ModelPrecacheTable, m:ReadString() )
	end
	
	gws_PrecacheSequence = (gws_PrecacheSequence or 0) + 1
	
	print( "Precaching sequence #".. gws_PrecacheSequence .."." )
	for k=(currentModelCount + 1),(currentModelCount + numberOfModels) do
		model = GAMEMODE.ModelPrecacheTable[ k ]
		--print( "Precaching model " .. k .. " : " .. model )
		util.PrecacheModel( model )
	end
end
usermessage.Hook( "ModelList", ModelList )

local function GameStartTime( m )
	gws_NextgameStart = m:ReadLong()
end
usermessage.Hook( "GameStartTime", GameStartTime )

local function ServerJoinInfo( m )
	local didnotbegin = false

	gws_TimeWhenGameEnds = m:ReadFloat()
	didnotbegin = m:ReadBool()
	
	if didnotbegin == true then
		WaitShow()
	end
	print("Game ends on time : "..gws_TimeWhenGameEnds)
end
usermessage.Hook( "ServerJoinInfo", ServerJoinInfo )

local function EnableMusicVolume( optiLoopToPlay )
	if gws_AmbientMusicIsOn then
		gws_AmbientMusic[optiLoopToPlay]:ChangeVolume( 0.7 )
	end
end

local function EnableMusic( optiLoopToPlay )	
	if gws_AmbientMusicIsOn then
		for k, music in pairs( gws_AmbientMusic ) do
			music:Stop()
			gws_AmbientMusic_dat[k]._IsPlaying = false
			
		end
		
		gws_AmbientMusic[optiLoopToPlay]:Play()
		gws_AmbientMusic_dat[optiLoopToPlay]._IsPlaying = true
		gws_AmbientMusic[optiLoopToPlay]:ChangeVolume( 0.1 )
		gws_AmbientMusic[optiLoopToPlay]:ChangePitch( GAMEMODE:GetSpeedPercent() )
		timer.Simple( GAMEMODE.WADAT.StartFlourishLength * 0.7 , EnableMusicVolume, optiLoopToPlay )
		
	end
	
end

local function DisableMusic()
	if not gws_AmbientMusicIsOn then
		for k, music in pairs( gws_AmbientMusic ) do
			if gws_AmbientMusic_dat[k]._IsPlaying then
				music:ChangeVolume( 0.1 )
				
			else
				music:Stop()
				
			end
			
		end
		
	end
end

local function PlayEnding( musicID )
	local dataRef = GAMEMODE.WADAT.TBL_GlobalWareningEpic[musicID]
	
	LocalPlayer():EmitSound( GAMEMODE.WASND.TBL_GlobalWareningEpic[musicID] , 60, GAMEMODE:GetSpeedPercent() )
	gws_AmbientMusicIsOn = true
	
	for k, music in pairs( gws_AmbientMusic ) do
		music:Stop()
		gws_AmbientMusic_dat[k]._IsPlaying = false
		
	end
	
	timer.Simple( dataRef.Length, EnableMusic, 1 )
end

local function NextGameTimes( m )
	gws_NextwarmupEnd = m:ReadFloat()
	gws_NextgameEnd   = m:ReadFloat()
	gws_WarmupLen     = m:ReadFloat()
	gws_WareLen       = m:ReadFloat()
	local bShouldKeepAnnounce = m:ReadBool()
	local bShouldPlayMusic = m:ReadBool()
	
	if not bShouldKeepAnnounce then
		gws_TickAnnounce = 5
	else
		gws_TickAnnounce = 0
	end
	
	if bShouldPlayMusic then
		local libraryID = m:ReadChar()
		local musicID = m:ReadChar()
		gws_CurrentAnnouncer = m:ReadChar()
		local loopToPlay = m:ReadChar()
		LocalPlayer():EmitSound( GAMEMODE.WASND.BITBL_GlobalWarening[libraryID][musicID] , 60, GAMEMODE:GetSpeedPercent() )
		gws_AmbientMusicIsOn = true
		EnableMusic( loopToPlay )
		
	end
	
end
usermessage.Hook( "NextGameTimes", NextGameTimes )

local function EventEndgameTrigger( m )
	local achieved = m:ReadBool()
	local musicID = m:ReadChar()
	
	gws_AmbientMusicIsOn = false
	timer.Simple( 0.5, DisableMusic )
	
	if (achieved) then
		LocalPlayer():EmitSound( GAMEMODE.WASND.TBL_GlobalWareningWin[ musicID ] , 60, GAMEMODE:GetSpeedPercent() )
	else
		LocalPlayer():EmitSound( GAMEMODE.WASND.TBL_GlobalWareningLose[ musicID ] , 60, GAMEMODE:GetSpeedPercent() )
	end
end
usermessage.Hook( "EventEndgameTrigger", EventEndgameTrigger )

local function BestStreakEverBreached( m )
	GAMEMODE:SetBestStreak( m:ReadLong() )
end
usermessage.Hook( "BestStreakEverBreached", BestStreakEverBreached )

local function EventEveryoneState( m )
	local achieved = m:ReadBool()

	if (achieved) then
		LocalPlayer():EmitSound( GAMEMODE.WASND.EveryoneWon, 100, GAMEMODE:GetSpeedPercent() )
	else
		LocalPlayer():EmitSound( GAMEMODE.WASND.EveryoneLost, 100, GAMEMODE:GetSpeedPercent() )
	end
end
usermessage.Hook( "EventEveryoneState", EventEveryoneState )

local function PlayerTeleported( m )
	if not m:ReadBool() then
		local musicID = m:ReadChar()
		LocalPlayer():EmitSound( GAMEMODE.WASND.TBL_GlobalWareningTeleport[ musicID ] , 60, GAMEMODE:GetSpeedPercent() )
	end
	LocalPlayer():EmitSound( table.Random(GAMEMODE.WASND.TBL_Teleport) , 40, GAMEMODE:GetSpeedPercent() )
end
usermessage.Hook( "PlayerTeleported", PlayerTeleported )




local function EntityTextChangeColor( m )
	local target = m:ReadEntity()
	local r,g,b,a = m:ReadChar() + 128, m:ReadChar() + 128, m:ReadChar() + 128, m:ReadChar() + 128
	
	if ValidEntity(target) and target.SetEntityColor then
		target:SetEntityColor(r,g,b,a)
	else
		timer.Simple( 0, function(target,r,g,b,a) if ValidEntity(target) and target.SetEntityColor then target:SetEntityColor(r,g,b,a) end end )
	end
end
usermessage.Hook( "EntityTextChangeColor", EntityTextChangeColor )


/*----------------------------------
VGUI Includes
------------------------------------*/


local vgui_transit = vgui.RegisterFile( "vgui_transitscreen.lua" )
local vgui_wait = vgui.RegisterFile( "vgui_waitscreen.lua" )
local vgui_clock = vgui.RegisterFile( "vgui_clock.lua" )
local vgui_clockgame = vgui.RegisterFile( "vgui_clockgame.lua" )
local vgui_stupidboard = vgui.RegisterFile( "garryware_vgui_main.lua")
local vgui_livescoreboard = vgui.RegisterFile( "garryware_vgui_livescoreboard.lua")
local vgui_instructions = vgui.RegisterFile( "garryware_vgui_instructions.lua")
local vgui_status = vgui.RegisterFile( "garryware_vgui_status.lua")
local vgui_ammo = vgui.RegisterFile( "garryware_vgui_ammo.lua")
local vgui_awards = vgui.RegisterFile( "garryware_vgui_awards.lua")

local TransitVGUI = vgui.CreateFromTable( vgui_transit )
local WaitVGUI = vgui.CreateFromTable( vgui_wait )
local ClockVGUI = vgui.CreateFromTable( vgui_clock )
local ClockGameVGUI = vgui.CreateFromTable( vgui_clockgame )
local StupidBoardVGUI = vgui.CreateFromTable( vgui_stupidboard )
local LiveScoreBoardVGUI = vgui.CreateFromTable( vgui_livescoreboard )
local InstructionsVGUI = vgui.CreateFromTable( vgui_instructions )
local StatusVGUI = vgui.CreateFromTable( vgui_status )
local AmmoVGUI = vgui.CreateFromTable( vgui_ammo )
local AwardVGUI = vgui.CreateFromTable( vgui_awards )

local function ForceRefreshVGUI()
	LiveScoreBoardVGUI:LabelRefresh( true )
end
concommand.Add("ware_forcerefresh_vgui", ForceRefreshVGUI)

function GM:ScoreboardShow()
	if not gws_AtEndOfGame then
		--GAMEMODE:GetScoreboard():SetVisible( true )
		--GAMEMODE:PositionScoreboard( GAMEMODE:GetScoreboard() )
		LiveScoreBoardVGUI:UseSecondarySort()
		
	else
		AwardVGUI:Show()
		
	end
	
end

function GM:ScoreboardHide()
	if not gws_AtEndOfGame then
		--GAMEMODE:GetScoreboard():SetVisible( false )
		--GAMEMODE:PositionScoreboard( GAMEMODE:GetScoreboard() )
		LiveScoreBoardVGUI:UseNormalSort()
		
	else
		AwardVGUI:Hide()
		
	end
	
end

StupidBoardVGUI:Show()
LiveScoreBoardVGUI:Show()
AmmoVGUI:Show()

local tWinEvalutaion = {
{5, "Epic FAIL"}, -- --> 0 to 5
{11, "Massive FAIL"},
{16, "Huge fail"},
{31, "Fail"},
{46, "Okay"}, ---
{65, "Success"},
{80, "Huge success"},
{95, "Massive WIN"},
{100, "Epic WIN"}
}
local function EvaluateFailure( iPercent )
	local iPos = 1
	while (iPos < #tWinEvalutaion) and ( iPercent > tWinEvalutaion[iPos][1] ) do
		iPos = iPos + 1
	end
	return tWinEvalutaion[iPos][2]
end

local function Transit( m )
	if m then
		local theoWinFailNum = tonumber( m:ReadChar() )
		TransitVGUI:SetSubtitle("Server Fail-o-meter : " .. tostring( 100 - theoWinFailNum ) .. "% ... " .. EvaluateFailure( theoWinFailNum ) .. "!"  )
		
		local fWinFailBlend = theoWinFailNum / 100
		fWinFailBlend = math.Clamp((fWinFailBlend - 0.5) * 1.5 + 0.5, 0, 1)
		TransitVGUI:SetBlend( fWinFailBlend )
		
	end
	
	TransitVGUI:Show()
	RunConsoleCommand("r_cleardecals")
	
	timer.Simple( 2.7, function() TransitVGUI:Hide() end )
end
usermessage.Hook( "Transit", Transit )

function WaitShow( m ) --used in ServerJoinInfo
	WaitVGUI:Show()
end
usermessage.Hook( "WaitShow", WaitShow )

local function WaitHide( m )
	WaitVGUI:Hide()
end
usermessage.Hook( "WaitHide", WaitHide )


local function EndOfGamemode( m )
	ClockVGUI:Hide()
	ClockGameVGUI:Hide()
	StupidBoardVGUI:Hide()
	LiveScoreBoardVGUI:Hide()
	AmmoVGUI:Show()
	
	AwardVGUI:Show()
	AwardVGUI:PerformScoreData()
	
	GAMEMODE:GetScoreboard():SetVisible( false )
	
	gws_AtEndOfGame = true
	
	--timer.Simple( GAMEMODE.WADAT.EpilogueFlourishDelayAfterEndOfGamemode, PlayEnding, 2 )
end
usermessage.Hook( "EndOfGamemode", EndOfGamemode )

local function SpecialFlourish( m )
	local musicID = m:ReadChar()
	local dataRef = GAMEMODE.WADAT.TBL_GlobalWareningEpic[musicID]
	timer.Simple( dataRef.StartDalay + dataRef.MusicFadeDelay, function() gws_AmbientMusic[1]:ChangeVolume( 0.0 ) end )
	timer.Simple( dataRef.StartDalay, PlayEnding, musicID )
end
usermessage.Hook( "SpecialFlourish", SpecialFlourish )


local function HitConfirmation( m )
	LocalPlayer():EmitSound( GAMEMODE.WASND.Confirmation, GAMEMODE:GetSpeedPercent() )
end
usermessage.Hook( "HitConfirmation", HitConfirmation )

local function DoRagdollEffect( ply, optvectPush, optiObjNumber, iIter)
	if not ValidEntity( ply ) then return end
	
	local ragdoll = ply:GetRagdollEntity()
	if ragdoll then
		local physobj = nil
		if optiObjNumber >= 0 then
			physobj = ragdoll:GetPhysicsObjectNum( optiObjNumber )
			
		else
			physobj = ragdoll:GetPhysicsObject( )
			
		end
		
		--print(ply:GetModel(), physobj:GetMass() )
		
		if physobj and physobj:IsValid() and physobj ~= NULL then
			physobj:SetVelocity( 10^6 * optvectPush )
			
		else
			timer.Simple(0, function() DoRagdollEffect( ply, optvectPush, optiObjNumber, iIter - 1) end)
		
		end
		
	else
		if iIter > 0 then
			timer.Simple(0, function() DoRagdollEffect( ply, optvectPush, optiObjNumber, iIter - 1) end)
		end
	end
	
end

local function PlayerRagdollEffect( m )
	local ply = m:ReadEntity()
	local optvectPush = m:ReadVector()
	local optiObjNumber = m:ReadChar()
	
	if not ValidEntity( ply ) then return end
	
	DoRagdollEffect( ply, optvectPush, optiObjNumber, 20)
end
usermessage.Hook( "PlayerRagdollEffect", PlayerRagdollEffect )

local function ReceiveInstructions( usrmsg )
	local sText = usrmsg:ReadString()
	local bUseCustomBG  = usrmsg:ReadBool()
	
	local cFG_Builder = nil
	local cBG_Builder = nil
	
	if bUseCustomBG then
		local bUseCustomFG = usrmsg:ReadBool()
		
		cBG_Builder = Color(usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128)
		
		if bUseCustomFG then
			cFG_Builder = Color( usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128, usrmsg:ReadChar() + 128)
			
		end
	
	end
	InstructionsVGUI:PrepareDrawData( sText, cFG_Builder, cBG_Builder )
	
end
usermessage.Hook( "gw_instructions", ReceiveInstructions )


	
local cStatusBackWinColorSet  = Color(0, 164, 237,192)
local cStatusBackLoseColorSet = Color(255,  87,  87,192)
local cStatusTextColorSet = Color(255,255,255,255)

local tWinParticles = {
	{"effects/yellowflare",35,2,ScrW()*0,ScrH(),20,20,50,70,-45,-60,60,64,256,Color(0, 164, 237,255),Color(0, 164, 237,0),5,1},
	{"effects/yellowflare",5,2,ScrW()*0,ScrH(),10,10,20,30,-45,-60,60,256,512,Color(255,255,255,255),Color(255,255,255,0),10,1},
	{"gui/silkicons/check_on.vmt",5,2,ScrW()*0,ScrH(),16,16,32,32,-45,-60,60,64,128,Color(255,255,255,255),Color(255,255,255,0),0,0.2}
}
local tFailParticles = {
	{"effects/yellowflare",35,2,ScrW()*0,ScrH(),20,20,50,70,-45,-60,60,64,256,Color(255,87,87,255),Color(255,87,87,0),5,1},
	{"effects/yellowflare",5,2,ScrW()*0,ScrH(),10,10,20,30,-45,-60,60,256,512,Color(255,255,255,255),Color(255,255,255,0),10,1},
	{"gui/silkicons/check_off.vmt",5,2,ScrW()*0,ScrH(),16,16,32,32,-45,-60,60,64,128,Color(255,255,255,255),Color(255,255,255,0),0,0.2}
}

local function MakeParticlesFromTable( myTablePtr )
	for k,particle in pairs(myTablePtr) do
		GAMEMODE:OnScreenParticlesMake(particle)
		
	end
	
end

local function ReceiveStatuses( usrmsg )	
	local sText = ""
	
	local yourStatus = usrmsg:ReadBool() or false
	local isServerGlobal = usrmsg:ReadBool() or false
	
	if not isServerGlobal then
		sText = ((yourStatus and "Success!") or "Failure!") -- MaxOfS2D you fail
		if yourStatus then
			LocalPlayer():EmitSound( table.Random(GAMEMODE.WASND.TBL_LocalWon), 100, GAMEMODE:GetSpeedPercent() )
		
			MakeParticlesFromTable( tWinParticles )
			
		else
			LocalPlayer():EmitSound( table.Random(GAMEMODE.WASND.TBL_LocalLose), 100, GAMEMODE:GetSpeedPercent() )
		
			MakeParticlesFromTable( tFailParticles )
			
		end
		
	else
		sText = ((yourStatus and "Everyone won!") or "Everyone failed!")
		
	end

	local colorSelect = yourStatus and cStatusBackWinColorSet or cStatusBackLoseColorSet

	StatusVGUI:PrepareDrawData( sText, nil, colorSelect, 3.0 )
end
usermessage.Hook( "gw_yourstatus", ReceiveStatuses )

local function ReceiveSpecialStatuses( usrmsg )	
	local specialStatus = usrmsg:ReadChar() or 0
	local positive = false
	
	local sText = ""
	
	if specialStatus == 1 then
		positive = true
		
		sText = "Done!"
		LocalPlayer():EmitSound( table.Random(GAMEMODE.WASND.TBL_LocalWon), 100, GAMEMODE:GetSpeedPercent() )
		
	end

	local colorSelect = positive and cStatusBackWinColorSet or cStatusBackLoseColorSet

	StatusVGUI:PrepareDrawData( sText, nil, colorSelect, 1.0 )
end
usermessage.Hook( "gw_specialstatus", ReceiveSpecialStatuses )
