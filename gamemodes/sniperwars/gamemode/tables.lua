
GM.WinSound = Sound("common/stuck1.wav")
GM.LoseSound = Sound("items/suitchargeok1.wav")

GM.Ricochet = {"weapons/fx/rics/ric1.wav",
"weapons/fx/rics/ric2.wav",
"weapons/fx/rics/ric3.wav",
"weapons/fx/rics/ric4.wav",
"weapons/fx/rics/ric5.wav"}

GM.BombExplosion = {"ambient/explosions/explode_1.wav",
"ambient/explosions/explode_2.wav",
"ambient/explosions/explode_4.wav",
"ambient/explosions/explode_5.wav",
"ambient/explosions/explode_6.wav",
"ambient/explosions/explode_8.wav",
"ambient/explosions/explode_9.wav",
"npc/env_headcrabcanister/explosion.wav",
"ambient/machines/wall_crash1.wav"}

GM.BombExplosion2 = {"weapons/hegrenade/explode3.wav",
"weapons/hegrenade/explode4.wav",
"weapons/hegrenade/explode5.wav"}

GM.Airplanes = {"ambient/machines/aircraft_distant_flyby1.wav",
"ambient/machines/aircraft_distant_flyby3.wav",
"ambient/machines/truck_pass_distant3.wav",
"ambient/machines/truck_pass_overhead1.wav",
"ambient/levels/citadel/portal_beam_shoot3.wav",
"ambient/atmosphere/city_skypass1.wav"}

GM.Corpses = {"models/player/Charple01.mdl",
"models/player/corpse1.mdl",
"models/humans/charple02.mdl",
"models/humans/charple03.mdl",
"models/humans/charple03.mdl",
"models/humans/charple04.mdl"}

for k,v in pairs( GM.Corpses ) do
	util.PrecacheModel( v )
end