
GM.Ricochet = {"weapons/fx/rics/ric1.wav",
"weapons/fx/rics/ric3.wav",
"weapons/fx/rics/ric4.wav",
"weapons/fx/rics/ric5.wav"}

GM.PlayerGore = {"jumpjet/blood01.wav",
"jumpjet/blood02.wav",
"jumpjet/blood03.wav"}

GM.PlayerPain = {"jumpjet/pain01.wav",
"jumpjet/pain02.wav",
"jumpjet/pain03.wav",
"jumpjet/pain04.wav",
"jumpjet/pain05.wav"}

GM.PlayerDie = {"jumpjet/die01.wav",
"jumpjet/die02.wav",
"jumpjet/die03.wav",
"jumpjet/die04.wav",
"jumpjet/die05.wav",
"jumpjet/carnage01.wav",
"jumpjet/carnage02.wav",
"jumpjet/carnage03.wav",
"jumpjet/carnage04.wav",
"jumpjet/carnage05.wav"}

GM.SpawnSounds = { "ambient/machines/teleport1.wav",
"ambient/machines/teleport3.wav",
"ambient/machines/teleport4.wav" }

GM.PlasmaExplosion = {"ambient/explosions/explode_7.wav",
"ambient/levels/labs/electric_explosion1.wav",
"ambient/levels/labs/electric_explosion2.wav",
"ambient/levels/labs/electric_explosion3.wav",
"ambient/levels/labs/electric_explosion4.wav",
"ambient/levels/labs/electric_explosion5.wav"}

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

GM.GoreSplat = {"npc/antlion_grub/squashed.wav",
"physics/flesh/flesh_squishy_impact_hard1.wav",
"physics/flesh/flesh_squishy_impact_hard2.wav",
"physics/flesh/flesh_squishy_impact_hard3.wav",
"physics/flesh/flesh_squishy_impact_hard4.wav",
"physics/flesh/flesh_bloody_impact_hard1.wav",
"ambient/levels/canals/toxic_slime_sizzle1.wav",
"ambient/levels/canals/toxic_slime_gurgle8.wav"}

GM.SmallGibs = {"models/gibs/HGIBS_spine.mdl",
"models/gibs/HGIBS_scapula.mdl",
"models/gibs/antlion_gib_small_1.mdl",
"models/gibs/antlion_gib_small_2.mdl",
"models/gibs/shield_scanner_gib1.mdl",
"models/props_wasteland/prison_sinkchunk001h.mdl",
"models/props_wasteland/prison_toiletchunk01g.mdl",
"models/props_wasteland/prison_toiletchunk01i.mdl",
"models/props_wasteland/prison_toiletchunk01l.mdl",
"models/props_combine/breenbust_chunk02.mdl",
"models/props_combine/breenbust_chunk03.mdl",
"models/weapons/w_bugbait.mdl",
"models/props/cs_italy/bananna.mdl"}

GM.BigGibs = {"models/gibs/HGIBS.mdl",
"models/gibs/antlion_gib_medium_1.mdl",
"models/gibs/antlion_gib_medium_2.mdl",
"models/gibs/shield_scanner_gib5.mdl",
"models/props_junk/garbage_bag001a.mdl",
"models/props_junk/shoe001a.mdl",
"models/props_junk/Rock001a.mdl",
"models/props_wasteland/prison_sinkchunk001b.mdl",
"models/props_wasteland/prison_sinkchunk001c.mdl",
"models/props_wasteland/prison_toiletchunk01j.mdl",
"models/props_wasteland/prison_toiletchunk01k.mdl",
"models/props_junk/watermelon01_chunk01b.mdl",
"models/props_junk/watermelon01_chunk01c.mdl"}

GM.CrateGibs = {"models/props_junk/wood_crate001a_chunk01.mdl",
"models/props_junk/wood_crate001a_chunk02.mdl",
"models/props_junk/wood_crate001a_chunk03.mdl",
"models/props_junk/wood_crate001a_chunk04.mdl",
"models/props_junk/wood_crate001a_chunk05.mdl",
"models/props_junk/wood_crate001a_chunk06.mdl",
"models/props_junk/wood_crate001a_chunk07.mdl",
"models/props_junk/wood_crate001a_chunk09.mdl"}

for k,v in pairs( GM.BigGibs ) do
	util.PrecacheModel( v )
end

for k,v in pairs( GM.SmallGibs ) do
	util.PrecacheModel( v )
end

for k,v in pairs( GM.CrateGibs ) do
	util.PrecacheModel( v )
end
