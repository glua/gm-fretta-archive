
GM.WinSound = Sound("common/stuck1.wav")
GM.LoseSound = Sound("items/suitchargeok1.wav")
GM.BonusSound = Sound("weapons/physgun_off.wav")

GM.HealSound = Sound("items/medshot4.wav")
GM.CureSound = Sound("items/battery_pickup.wav")
GM.ResSound = Sound("ambient/levels/labs/teleport_mechanism_windup4.wav")

GM.WinMusic = {"music/HL2_song1.mp3",
"music/HL2_song3.mp3",
"music/HL2_song4.mp3",
"music/HL2_song6.mp3",
"music/HL2_song14.mp3",
"music/HL2_song15.mp3",
"music/HL2_song16.mp3",
"music/HL2_song29.mp3",
"music/HL2_song31.mp3",
"music/HL1_song17.mp3",
"music/HL1_song10.mp3"}

GM.LoseMusic = {"music/HL2_song2.mp3",
"music/HL2_song7.mp3",
"music/HL2_song19.mp3",
"music/HL2_song26.mp3",
"music/HL2_song32.mp3",
"music/HL2_song33.mp3",
"music/HL1_song9.mp3"}

GM.DeathMusic = {"music/HL2_song28.mp3",
"music/Ravenholm_1.mp3",
"music/stingers/HL1_stinger_song16.mp3",
"music/stingers/HL1_stinger_song7.mp3",
"music/stingers/HL1_stinger_song8.mp3",
"music/stingers/HL1_stinger_song27.mp3",
"music/stingers/HL1_stinger_song28.mp3",
"music/stingers/industrial_suspense1.wav",
"music/stingers/industrial_suspense2.wav"}

GM.Drill = {"npc/dog/dog_servo6.wav",
"npc/dog/dog_servo7.wav",
"npc/dog/dog_servo10.wav",
"npc/dog/dog_servo12.wav"}

GM.WoodHammer = {"physics/wood/wood_plank_impact_hard2.wav",
"physics/wood/wood_plank_impact_hard3.wav",
"physics/wood/wood_plank_impact_hard4.wav"}

GM.AmbientScream = {"ambient/levels/prison/inside_battle_antlion2.wav",
"ambient/levels/prison/inside_battle_antlion3.wav",
"ambient/levels/prison/inside_battle_zombie1.wav",
"ambient/levels/streetwar/city_scream3.wav",
"ambient/levels/citadel/strange_talk1.wav",
"npc/combine_gunship/gunship_moan.wav",
"ambient/creatures/town_zombie_call1.wav",
"ambient/creatures/town_moan1.wav",
"ambient/creatures/town_child_scream1.wav",
"ambient/creatures/town_scared_sob1.wav",
"ambient/creatures/town_scared_sob2.wav",
"ambient/creatures/town_scared_breathing1.wav"}

GM.Cough = {"ambient/voices/cough1.wav",
"ambient/voices/cough2.wav",
"ambient/voices/cough3.wav",
"ambient/voices/cough4.wav",
"ambient/voices/citizen_beaten3.wav",
"ambient/voices/citizen_beaten4.wav",
"vo/npc/male01/startle01.wav",
"vo/npc/male01/startle02.wav",
"vo/npc/male01/moan01.wav",
"vo/npc/male01/moan02.wav",
"vo/npc/male01/moan03.wav",
"vo/npc/male01/moan04.wav",
"vo/npc/male01/moan05.wav"}

GM.Climbing = {"player/footsteps/metalgrate1.wav",
"player/footsteps/metalgrate2.wav",
"player/footsteps/metalgrate3.wav",
"player/footsteps/metalgrate4.wav"}

GM.Geiger = {"player/geiger1.wav",
"player/geiger2.wav",
"player/geiger3.wav"}

GM.Gibs = {"models/props/cs_italy/bananna.mdl",
"models/props/cs_italy/banannagib1.mdl",
"models/props/cs_italy/orangegib1.mdl",
"models/props/cs_office/projector_remote_p2.mdl",
"models/weapons/w_bugbait.mdl",
"models/props_junk/shoe001a.mdl",
"models/props_junk/watermelon01_chunk02a.mdl",
"models/props_junk/watermelon01_chunk02b.mdl",
"models/props_junk/watermelon01_chunk01b.mdl",
"models/props_junk/watermelon01_chunk01c.mdl",
"models/props_combine/breenbust_chunk02.mdl",
"models/props_combine/breenbust_chunk03.mdl",
"models/props_combine/breenbust_chunk04.mdl",
"models/props_combine/breenbust_chunk05.mdl",
"models/props_combine/breenbust_chunk06.mdl",
"models/props_combine/breenbust_chunk07.mdl",
"models/props_wasteland/prison_sinkchunk001b.mdl",
"models/props_wasteland/prison_toiletchunk01f.mdl",
"models/props_wasteland/prison_toiletchunk01i.mdl",
"models/props_wasteland/prison_toiletchunk01j.mdl",
"models/gibs/shield_scanner_gib1.mdl",
"models/gibs/shield_scanner_gib1.mdl",
"models/gibs/HGIBS_spine.mdl",
"models/gibs/HGIBS_rib.mdl",
"models/gibs/HGIBS_scapula.mdl",
"models/gibs/hgibs.mdl",
"models/gibs/antlion_gib_small_1.mdl",
"models/gibs/antlion_gib_small_2.mdl",
"models/gibs/antlion_gib_medium_1.mdl",
"models/gibs/antlion_gib_medium_2.mdl"}

for k,v in pairs( GM.Gibs ) do
	util.PrecacheModel( v )
end

GM.BonusText = {"Your weapon has been upgraded",
"Firepower increased",
"Lock and load",
"Happy birthday",
"Have a freebie",
"You are going to need this gun",
"If it bleeds we can kill it",
"This might come in handy...",
"Christmas comes early..."}

GM.WeaponWhitelist = {"weapon_zo_crowbar",
"weapon_zo_toolkit",
"weapon_zo_medikit",
"weapon_zo_ammokit",
"weapon_zo_glock18",
"weapon_zo_deagle"}

GM.AmmoAmounts = {}
GM.AmmoAmounts["Buckshot"] = 40
GM.AmmoAmounts["Pistol"] = 60
GM.AmmoAmounts["SMG"] = 180
GM.AmmoAmounts["Rifle"] = 180

GM.BonusLevels = {}
GM.BonusLevels[10] = { "weapon_zo_usp", "weapon_zo_fiveseven" } 
GM.BonusLevels[20] = { "weapon_zo_deagle", "weapon_zo_glock18" } 
GM.BonusLevels[30] = { "weapon_zo_tmp", "weapon_zo_mac10" } 
GM.BonusLevels[50] = { "weapon_zo_ump45", "weapon_zo_mp5" } 
GM.BonusLevels[80] = { "weapon_zo_ruger77", "weapon_zo_spas12" } 
GM.BonusLevels[100] = { "weapon_zo_galil", "weapon_zo_ak47" } 
GM.BonusLevels[120] = { "weapon_zo_m249" } 
