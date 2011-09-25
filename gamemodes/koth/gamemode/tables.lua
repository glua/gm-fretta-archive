
GM.WinSound = Sound("common/stuck1.wav")
GM.LoseSound = Sound("items/suitchargeok1.wav")

GM.EnterHill = Sound("HL1/fvox/blip.wav")
GM.ExitHill = Sound("HL1/fvox/fuzz.wav")
GM.HillMove = Sound("ambient/alarms/warningbell1.wav")

GM.Corpses = {"models/player/Charple01.mdl",
"models/player/corpse1.mdl",
"models/humans/charple02.mdl",
"models/humans/charple03.mdl",
"models/humans/charple03.mdl",
"models/humans/charple04.mdl"}

GM.PlasmaExplode = {"ambient/explosions/explode_7.wav",
"ambient/levels/labs/electric_explosion1.wav",
"ambient/levels/labs/electric_explosion2.wav",
"ambient/levels/labs/electric_explosion3.wav",
"ambient/levels/labs/electric_explosion4.wav",
"ambient/levels/labs/electric_explosion5.wav"}

GM.QuietZap = {"weapons/physcannon/superphys_small_zap1.wav",
"weapons/physcannon/superphys_small_zap2.wav",
"weapons/physcannon/superphys_small_zap3.wav",
"weapons/physcannon/superphys_small_zap4.wav"}

GM.SmallZap = {"ambient/energy/spark1.wav",
"ambient/energy/spark2.wav",
"ambient/energy/spark3.wav",
"ambient/energy/spark4.wav",
"ambient/energy/spark5.wav",
"ambient/energy/spark6.wav",
"weapons/stunstick/spark1.wav",
"weapons/stunstick/spark2.wav",
"weapons/stunstick/spark3.wav"}

GM.MediumZap = {"ambient/energy/zap1.wav",
"ambient/energy/zap2.wav",
"ambient/energy/zap3.wav",
"ambient/energy/zap5.wav",
"ambient/energy/zap6.wav",
"ambient/energy/zap7.wav",
"ambient/energy/zap8.wav",
"ambient/energy/zap9.wav",
"npc/scanner/scanner_pain1.wav",
"npc/scanner/scanner_pain2.wav"}

GM.ElectricDissipate = {"ambient/energy/weld1.wav",
"ambient/energy/weld2.wav"}

GM.BulletSmash = {"player/headshot1.wav",
"player/headshot2.wav"}

GM.NearMiss = {"weapons/fx/nearmiss/bulletltor03.wav",
"weapons/fx/nearmiss/bulletltor04.wav",
"weapons/fx/nearmiss/bulletltor05.wav",
"weapons/fx/nearmiss/bulletltor06.wav",
"weapons/fx/nearmiss/bulletltor07.wav",
"weapons/fx/nearmiss/bulletltor09.wav",
"weapons/fx/nearmiss/bulletltor10.wav",
"weapons/fx/nearmiss/bulletltor11.wav",
"weapons/fx/nearmiss/bulletltor12.wav",
"weapons/fx/nearmiss/bulletltor13.wav"}

GM.Geiger = {"player/geiger1.wav",
"player/geiger2.wav",
"player/geiger3.wav"}

for k,v in pairs( GM.Corpses ) do
	util.PrecacheModel( v )
end