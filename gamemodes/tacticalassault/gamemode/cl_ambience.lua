
// INGAME AMBIENCE
local ambience = {
	/*["dronescape"] = {
		Sound("ta/ambient1.wav"),
		Sound("ta/ambient2.wav"),
		Sound("ta/ambient3.wav"),
		Sound("ta/ambient4.wav"),
		Sound("ta/ambient5.wav"),
		Sound("ta/ambient6.wav"),
		Sound("ta/ambient7.wav"),
		Sound("ta/ambient8.wav"),
		Sound("ta/ambient9.wav"),
	},*/
	["battle"] = {
		Sound("ambient/explosions/battle_loop1.wav"),
		Sound("ambient/explosions/battle_loop2.wav"),
		Sound("ambient/levels/streetwar/strider_distant_walk1.wav"),
		Sound("ambient/levels/streetwar/city_riot2.wav"),
		Sound("ambient/levels/streetwar/heli_distant1.wav"),
		Sound("ambient/levels/streetwar/apc_distant1.wav"),
		Sound("ambient/levels/streetwar/apc_distant3.wav"),
		Sound("ambient/levels/streetwar/city_battle4.wav"),
	},
	["wind"] = {
		Sound("ambient/wind/windgust_strong.wav"),
		Sound("ambient/wind/windgust.wav"),
		Sound("ambient/wind/windgust_med1.wav"),
		Sound("ambient/wind/windgust_snippet5.wav"),
		Sound("ambient/wind/wasteland_wind.wav"),
		Sound("ambient/levels/canals/tunnel_wind_loop1.wav"),
		Sound("ambient/levels/canals/windmill_wind_loop1.wav"),
	},
	["lake"] = {
		Sound("ambient/water/lake_water.wav"),
	},	
	["klaxon_alarm"] = { Sound("ambient/alarms/klaxon1.wav") },
	["bank_alarm"] = { Sound("ambient/alarms/combine_bank_alarm_loop4.wav") },
	["citadel_alarm"] = {Sound("ambient/alarms/citadel_alert_loop2.wav") },
	["apc_alarm"] = {Sound("ambient/alarms/apc_alarm_loop1.wav") },
}

local cur_sound = nil
function LoopAmbience(snd)
	
	if cur_sound then cur_sound:Stop() end
	cur_sound = CreateSound(LocalPlayer(),snd)
	cur_sound:PlayEx(0.1,100)
	cur_sound:SetSoundLevel(1.25)
	
	timer.Simple(SoundDuration(snd) - 0.5,function() cur_sound:FadeOut(0.5) end)
	
	local tab = ""
	if not ambience[GetGlobalString("ta_ambience")] then tab = "battle" else tab = GetGlobalString("ta_ambience") end
	timer.Simple(SoundDuration(snd),function() LoopAmbience(table.Random(ambience[tab])) end)
end
timer.Simple(10,function() LoopAmbience(ambience["battle"][1]) end)


// ROUND END SOUNDS
local roundend = {
	{ "ta/endround/win-loop1.wav",
	"ta/endround/win-loop2.mp3",
	},
	{ "ta/endround/lose-loop1.wav",
	"ta/endround/lose-riff2.wav",
	},
}

usermessage.Hook("endRoundSound",function(um)
	local snd = ""
	if um:ReadBool() then snd = table.Random(roundend[1])
	else snd = table.Random(roundend[2]) end
	
	if string.find(snd,"loop") then
		surface.PlaySound(snd)
		timer.Create("loopEndSound",SoundDuration(snd),2,function() surface.PlaySound(snd) end)
	else
		surface.PlaySound(snd)
	end
end)

usermessage.Hook("stopRoundSound",function() timer.Destroy("loopEndSound") end)
	
