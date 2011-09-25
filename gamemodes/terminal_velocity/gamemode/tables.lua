
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

GM.FlakExplosion = {"ambient/explosions/exp1.wav",
"ambient/explosions/exp2.wav",
"ambient/explosions/exp3.wav",
"ambient/explosions/explode_4.wav",
"ambient/explosions/explode_9.wav",
"weapons/underwater_explode3.wav",
"weapons/underwater_explode4.wav"}

GM.FlakAmbient = {"ambient/levels/streetwar/city_battle14.wav",
"ambient/levels/streetwar/city_battle15.wav",
"ambient/levels/streetwar/city_battle17.wav",
"ambient/levels/streetwar/city_battle18.wav",
"ambient/levels/streetwar/city_battle19.wav",
"ambient/levels/streetwar/city_battle6.wav",
"ambient/levels/streetwar/city_battle7.wav",
"ambient/levels/streetwar/city_battle11.wav"}

GM.Corpses = {"models/player/Charple01.mdl",
"models/player/corpse1.mdl",
"models/humans/charple02.mdl",
"models/humans/charple03.mdl",
"models/humans/charple03.mdl",
"models/humans/charple04.mdl"}

for k,v in pairs( GM.Corpses ) do
	util.PrecacheModel( v )
end
