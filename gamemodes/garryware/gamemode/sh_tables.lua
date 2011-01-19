////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Shared Tables                              //
////////////////////////////////////////////////

GM.WASND = {}
GM.WADAT = {}
GM.WADAT.EndFlourishTime = 2.50
GM.WADAT.StartFlourishLength = 2.50
GM.WADAT.TransitFlourishTime = 1.3

GM.WADAT.TBL_GlobalWareningEpic = {}
GM.WADAT.TBL_GlobalWareningEpic[1] = {}
GM.WADAT.TBL_GlobalWareningEpic[2] = {}
-- Prologue Data
GM.WADAT.TBL_GlobalWareningEpic[1].MusicFadeDelay  = 0.4
GM.WADAT.TBL_GlobalWareningEpic[1].StartDalay = 2.0
GM.WADAT.TBL_GlobalWareningEpic[1].Length = 10.24
-- Epilogue Data
GM.WADAT.TBL_GlobalWareningEpic[2].MusicFadeDelay = 0.00
GM.WADAT.TBL_GlobalWareningEpic[2].StartDalay = 2.0
GM.WADAT.TBL_GlobalWareningEpic[2].Length = 20.10


GM.WADAT.EpilogueFlourishDelayAfterEndOfGamemode = 2.26

GM.WASND.THL_AmbientMusic = {
Sound("ware/exp_loop_1.wav"),
Sound("ware/exp_loop_2.wav")
}

GM.WASND.BITBL_GlobalWarening = {}

GM.WASND.TBL_GlobalWareningNew    = {
Sound("ware/exp_game_new_1.mp3"),
Sound("ware/exp_game_new_2.mp3"),
Sound("ware/exp_game_new_3.mp3"),
Sound("ware/exp_game_new_4.mp3"),
Sound("ware/exp_game_new_5.mp3")
}

GM.WASND.TBL_GlobalWareningWin    = {
Sound("ware/exp_game_win_1.mp3"),
Sound("ware/exp_game_win_2.mp3"),
Sound("ware/exp_game_win_3.mp3")
}

GM.WASND.TBL_GlobalWareningLose   = {
Sound("ware/exp_game_lose_1.mp3"),
Sound("ware/exp_game_lose_2.mp3"),
Sound("ware/exp_game_lose_3.mp3")
}

GM.WASND.TBL_GlobalWareningPhase = {
Sound("ware/exp_game_new_1.mp3"),
Sound("ware/exp_game_new_2.mp3"),
Sound("ware/exp_game_new_3.mp3"),
Sound("ware/exp_game_new_4.mp3"),
Sound("ware/exp_game_new_5.mp3")
}

GM.WASND.BITBL_GlobalWarening[1] = GM.WASND.TBL_GlobalWareningNew
GM.WASND.BITBL_GlobalWarening[2] = GM.WASND.TBL_GlobalWareningWin
GM.WASND.BITBL_GlobalWarening[3] = GM.WASND.TBL_GlobalWareningLose
GM.WASND.BITBL_GlobalWarening[4] = GM.WASND.TBL_GlobalWareningPhase

GM.WASND.GlobalWareningReport = Sound("ware/game_information.mp3")

--[[
GM.WASND.TBL_GlobalWareningReport = {
Sound("ware/game_report.mp3")
}
]]--

GM.WASND.TBL_GlobalWareningTeleport = {
Sound("ware/exp_game_transit_1.mp3"),
Sound("ware/exp_game_transit_2.mp3")
}

GM.WASND.TBL_GlobalWareningEpic   = {
Sound("ware/game_prologue.mp3"),
Sound("ware/game_epilogue.mp3")
}


GM.WASND.BITBL_TimeLeft = {}

GM.WASND.BITBL_TimeLeft[1] = {}
if SERVER or (CLIENT and not file.Exists("../sound/vo/announcer_begins_1sec.wav")) then
	GM.WASND.BITBL_TimeLeft[1][1] = Sound("ware/countdown_ann_sec1.mp3")
	GM.WASND.BITBL_TimeLeft[1][2] = Sound("ware/countdown_ann_sec2.mp3")
	GM.WASND.BITBL_TimeLeft[1][3] = Sound("ware/countdown_ann_sec3.mp3")
	GM.WASND.BITBL_TimeLeft[1][4] = Sound("ware/countdown_ann_sec4.mp3")
	GM.WASND.BITBL_TimeLeft[1][5] = Sound("ware/countdown_ann_sec5.mp3")
	
else
	GM.WASND.BITBL_TimeLeft[1][1] = Sound("vo/announcer_begins_1sec.wav")
	GM.WASND.BITBL_TimeLeft[1][2] = Sound("vo/announcer_begins_2sec.wav")
	GM.WASND.BITBL_TimeLeft[1][3] = Sound("vo/announcer_begins_3sec.wav")
	GM.WASND.BITBL_TimeLeft[1][4] = Sound("vo/announcer_begins_4sec.wav")
	GM.WASND.BITBL_TimeLeft[1][5] = Sound("vo/announcer_begins_5sec.wav")
end

GM.WASND.BITBL_TimeLeft[2] = {}
GM.WASND.BITBL_TimeLeft[2][1] = Sound("ware/countdown_dos_sec1.mp3")
GM.WASND.BITBL_TimeLeft[2][2] = Sound("ware/countdown_dos_sec2.mp3")
GM.WASND.BITBL_TimeLeft[2][3] = Sound("ware/countdown_dos_sec3.mp3")
GM.WASND.BITBL_TimeLeft[2][4] = Sound("ware/countdown_dos_sec4.mp3")
GM.WASND.BITBL_TimeLeft[2][5] = Sound("ware/countdown_dos_sec5.mp3")

GM.WASND.BITBL_TimeLeft[3] = {}
GM.WASND.BITBL_TimeLeft[3][0] = Sound("ware/countdown_tick_high.wav")
GM.WASND.BITBL_TimeLeft[3][1] = Sound("ware/countdown_tick_high.wav")
GM.WASND.BITBL_TimeLeft[3][2] = Sound("ware/countdown_tick_low.wav")
GM.WASND.BITBL_TimeLeft[3][3] = Sound("ware/countdown_tick_high.wav")
GM.WASND.BITBL_TimeLeft[3][4] = Sound("ware/countdown_tick_low.wav")
GM.WASND.BITBL_TimeLeft[3][5] = Sound("ware/countdown_tick_high.wav")

-- Bi-reference the sounds above for client send inclusion.
GM.WASND.BIREF_1 = GM.WASND.BITBL_TimeLeft[1]
GM.WASND.BIREF_2 = GM.WASND.BITBL_TimeLeft[2]
GM.WASND.BIREF_3 = GM.WASND.BITBL_TimeLeft[3]

GM.WASND.TBL_LocalWon = {
Sound("ware/local_exo_won1.wav"),
Sound("ware/local_exo_won2.wav"),
Sound("ware/local_exo_won3.wav"),
Sound("ware/local_exo_won2.wav"),
Sound("ware/local_exo_won3.wav")
}
-- Repeating 2 and 3 for more chances of playing

GM.WASND.TBL_LocalLose = {
Sound("ware/local_lose2.wav"),
Sound("ware/local_lose3.wav"),
Sound("ware/local_lose4.wav")
}

GM.WASND.Confirmation  = Sound("ware/local_exo_target_hit.wav")

if SERVER or (CLIENT and not file.Exists("../sound/player/crit_hit.wav")) then
	GM.WASND.OtherWin  = Sound("ware/other_exo_won1.wav")
	
else
	GM.WASND.OtherWin  = Sound("TFPlayer.CritHit")
	
end

GM.WASND.OtherLose = Sound("ware/other_lose1.wav")

GM.WASND.EveryoneWon  = Sound("ware/everyone_won3.wav")
GM.WASND.EveryoneLost = Sound("ware/everyone_lose2.wav")

GM.WASND.TBL_Teleport = {
Sound("ambient/machines/teleport1.wav"),
Sound("ambient/machines/teleport3.wav"),
Sound("ambient/machines/teleport4.wav")}
--[[
SNDOFFS_MALE    = 1
SNDOFFS_FEMALE  = 2
SNDOFFS_COMBINE = 3
SNDOFFS_POLICE  = 4
SNDOFFS_MONSTER = 5

GM.WASNDOFFS = {}

GM.WASNDOFFS.PlayerJoy = {}
GM.WASNDOFFS.PlayerJoy[SNDOFFS_MALE]    = {
}
GM.WASNDOFFS.PlayerJoy[SNDOFFS_FEMALE]  = {
}
GM.WASNDOFFS.PlayerJoy[SNDOFFS_COMBINE] = {
}
GM.WASNDOFFS.PlayerJoy[SNDOFFS_POLICE]  = {
}
GM.WASNDOFFS.PlayerJoy[SNDOFFS_MONSTER] = {
}

GM.WASNDOFFS.PlayerSad = {}
GM.WASNDOFFS.PlayerSad[SNDOFFS_MALE]    = {
}
GM.WASNDOFFS.PlayerSad[SNDOFFS_FEMALE]  = {
}
GM.WASNDOFFS.PlayerSad[SNDOFFS_COMBINE] = {
}
GM.WASNDOFFS.PlayerSad[SNDOFFS_POLICE]  = {
}
GM.WASNDOFFS.PlayerSad[SNDOFFS_MONSTER] = {
}
]]--
GM.WACOLS = {}
GM.WACOLS["unknown"]  = Color(255,255,255,255)
GM.WACOLS["topic"]    = Color(220,210,92,255)
GM.WACOLS["link"]     = Color(255,255,255,255)
GM.WACOLS["info"]     = Color(170,255,170,255)
GM.WACOLS["dom_outline"] = Color(0,0,0,255)
GM.WACOLS["dom_text"]    = Color(255,255,255,255)

GM.WareEnts = {}

GM.ColorTable = {
	{ "black"		, Color(0,0,0,255) 		, "twirl"	 },
	{ "grey"		, Color(138,138,138,255)	, "cross" 	 },
	{ "white"		, Color(255,255,255,255)	, "triangle" },
	{ "red"			, Color(220,0,0,255)		, "square"   },
	{ "green"		, Color(0,220,0,255)		, "circle"	 },
	{ "blue"		, Color(64,64,255,255)		, "star" 	 },
	{ "pink"		, Color(255,0,255,255)		, "flower"	 }
}

G_GWI_SKIN = "ware"

ENTS_ONCRATE = "oncrate"
ENTS_OVERCRATE = "overcrate"
ENTS_INAIR = "inair"
ENTS_CROSS = "cross"


DTVAR_PLAYER_ACHIEVED_INT  = 0
DTVAR_PLAYER_LOCKED_INT    = 1
DTVAR_PLAYER_COMBO_INT     = 2
DTVAR_PLAYER_BESTCOMBO_INT = 3


AWARD_IQ_WIN    = "iq_win"
AWARD_IQ_FAIL   = "iq_fail"
AWARD_REFLEX    = "reflex"
AWARD_MOVES     = "moves"
AWARD_FRENZY    = "frenzy"
AWARD_AIM       = "aim"
AWARD_VICTIM    = "victim"


if false then
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:EnableFirstFailAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	GAMEMODE:SetFailAwards( AWARD_VICTIM )
	

	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_IQ_WIN )
	GAMEMODE:SetFailAwards( AWARD_IQ_FAIL )
	
end






