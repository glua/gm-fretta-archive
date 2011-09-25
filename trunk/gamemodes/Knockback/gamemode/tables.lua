GM.WinSound = Sound("common/stuck1.wav")
GM.LoseSound = Sound("items/suitchargeok1.wav")

GM.Corpses = {"models/player/Charple01.mdl",
"models/player/corpse1.mdl",
"models/humans/charple02.mdl",
"models/humans/charple03.mdl",
"models/humans/charple03.mdl",
"models/humans/charple04.mdl"}

GM.GlassHit = {"physics/glass/glass_impact_bullet1.wav",
"physics/glass/glass_impact_bullet2.wav",
"physics/glass/glass_impact_bullet3.wav",
"physics/glass/glass_impact_bullet4.wav"}

GM.GlassBreak = {"physics/glass/glass_largesheet_break1.wav",
"physics/glass/glass_largesheet_break2.wav",
"physics/glass/glass_largesheet_break3.wav",
"physics/glass/glass_sheet_break1.wav",
"physics/glass/glass_sheet_break2.wav",
"physics/glass/glass_sheet_break3.wav"}

for k,v in pairs(GM.Corpses) do
	util.PrecacheModel(v)
end