
GM.WinSound = Sound("common/stuck1.wav")
GM.LoseSound = Sound("items/suitchargeok1.wav")
GM.Pickup = Sound("items/itempickup.wav")

GM.BodySmack = {"physics/body/body_medium_break2.wav",
"physics/body/body_medium_break3.wav",
"physics/body/body_medium_impact_hard4.wav",
"physics/body/body_medium_impact_hard5.wav"}

GM.Burn = {"player/pl_burnpain3.wav",
"player/pl_burnpain2.wav",
"player/pl_burnpain1.wav",
"ambient/levels/canals/toxic_slime_sizzle2.wav",
"ambient/levels/canals/toxic_slime_sizzle3.wav"}

GM.Ricochet = {"weapons/fx/rics/ric1.wav",
"weapons/fx/rics/ric2.wav",
"weapons/fx/rics/ric3.wav",
"weapons/fx/rics/ric4.wav",
"weapons/fx/rics/ric5.wav"}

GM.MetalHit = {"physics/metal/metal_solid_impact_soft1.wav",
"physics/metal/metal_solid_impact_soft2.wav",
"physics/metal/metal_solid_impact_soft3.wav",
"physics/metal/metal_solid_impact_hard1.wav"}

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

GM.CarSmash = {"vehicles/v8/vehicle_impact_heavy1.wav",
"vehicles/v8/vehicle_impact_heavy2.wav",
"vehicles/v8/vehicle_impact_heavy3.wav",
"vehicles/v8/vehicle_impact_heavy4.wav",
"vehicles/v8/vehicle_impact_medium2.wav",
"vehicles/v8/vehicle_impact_medium3.wav",
"ambient/materials/cartrap_explode_impact2.wav"}

GM.CashTake = {"physics/metal/chain_impact_hard1.wav",
"physics/metal/chain_impact_soft1.wav",
"physics/metal/chain_impact_soft2.wav",
"physics/metal/chain_impact_soft3.wav"}

GM.Debris = {"models/gibs/scanner_gib01.mdl",
"models/gibs/scanner_gib05.mdl",
"models/Gibs/Shield_Scanner_Gib5.mdl",
"models/Gibs/Shield_Scanner_Gib6.mdl",	
"models/Gibs/helicopter_brokenpiece_02.mdl",
"models/props_wasteland/tram_lever01.mdl",
"models/gibs/airboat_broken_engine.mdl",
"models/props_c17/oildrumchunk01a.mdl",
"models/props_c17/oildrumchunk01d.mdl",
"models/props_c17/consolebox05a.mdl",
"models/props_c17/lamp001a.mdl",
"models/props_wasteland/gear01.mdl",
"models/props_wasteland/gear02.mdl",
"models/props_junk/metal_paintcan001a.mdl",
"models/props_junk/cardboard_box004a.mdl",
"models/props_interiors/pot01a.mdl",
"models/props_interiors/pot02a.mdl",
"models/props_lab/reciever01b.mdl",
"models/props_lab/reciever01c.mdl",
"models/props_junk/vent001_chunk1.mdl",
"models/props_junk/vent001_chunk2.mdl",
"models/props_interiors/refrigeratordoor02a.mdl",
"models/props_vehicles/carparts_tire01a.mdl",
"models/props_vehicles/carparts_wheel01a.mdl",
"models/props_vehicles/carparts_wheel01a.mdl",
"models/props_vehicles/carparts_axel01a.mdl",
"models/props_vehicles/carparts_muffler01a.mdl",
"models/Items/car_battery01.mdl"}

GM.Corpses = {"models/player/Charple01.mdl",
"models/player/corpse1.mdl",
"models/humans/charple02.mdl",
"models/humans/charple03.mdl",
"models/humans/charple03.mdl",
"models/humans/charple04.mdl"}

for k,v in pairs( GM.Corpses ) do 
	util.PrecacheModel( v )
end

for k,v in pairs( GM.Debris ) do 
	util.PrecacheModel( v )
end

GM.SpawnableVehicles = { "vehicle_mini", 
"vehicle_tomboy", 
"vehicle_dutchess", 
"vehicle_stallion", 
"vehicle_van", 
"vehicle_truck",
"vehicle_cougar", 
"vehicle_admiral" }

GM.RoadkillNotices = { "ROAD RAGE",
"HIT AND RUN",
"RECKLESS DRIVING",
"PEDESTRIAN PIE",
"FATALITY",
"HONK HONK",
"VROOM SPLAT",
"LICK IT",
"ROADKILL",
"MANSLAUGHTER" }

GM.WeaponNotices = { "THIS COULD BE USEFUL",
"THIS LOOKS DANGEROUS",
"FIREPOWER INCREASED",
"LOCK AND LOAD",
"CHRISTMAS COMES EARLY" }

GM.StealNotices = { "NICE STEAL",
"YOU EARNED SOME MONEY",
"YOU STOLE A VEHICLE",
"CARJACK COMPLETE",
"YOU SCORED SOME CASH" } 

GM.ArrestNotices = { "YOU WENT TO PRISON",
"THE COPS TOOK YOUR CASH",
"THE POLICE CAUGHT YOU",
"YOU WERE ARRESTED",
"YOU GOT BUSTED" }

GM.CopNotices = { "YOU BUSTED A GANGSTER",
"POLICE BRUTALITY",
"YOU TASED A BRO",
"YOU BEAT DOWN A PUNK",
"DEATH SENTENCE" }

GM.GangStartNotices = { "go steal some vehicles",
"go rob some civilians",
"bring cars to your garage",
"look out for the police",
"kill some hookers" }

GM.CopStartNotices = { "time to bust some gangsters",
"go arrest some thieves",
"protect the neighborhood",
"keep the civilians safe",
"watch out for carjackers" }

