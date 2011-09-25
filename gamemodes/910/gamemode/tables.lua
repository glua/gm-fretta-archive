
GM.WinSound = Sound("common/stuck1.wav")
GM.LoseSound = Sound("items/suitchargeok1.wav")

GM.EarnPoint = Sound("buttons/blip1.wav")
GM.LosePoint = Sound("npc/roller/mine/rmine_blip3.wav")
GM.TiePoint = Sound("hl1/fvox/fuzz.wav")

GM.SpawnSounds = {
		Sound("hl1/fvox/activated.wav"),
		Sound("hl1/fvox/acquired.wav"),
		Sound("hl1/fvox/power_restored.wav"),
		Sound("hl1/fvox/targetting_system.wav") }

GM.DeathSounds = {
		Sound("hl1/fvox/armor_gone.wav"),
		Sound("hl1/fvox/bio_reading.wav"),
		Sound("hl1/fvox/bleeding_stopped.wav"),
		Sound("hl1/fvox/blood_loss.wav"),
		Sound("hl1/fvox/deactivated.wav"),
		Sound("hl1/fvox/health_critical.wav"),
		Sound("hl1/fvox/health_dropping.wav"),
		Sound("hl1/fvox/health_dropping2.wav"),
		Sound("hl1/fvox/hev_general_fail.wav"),
		Sound("hl1/fvox/innsuficient_medical.wav"),
		Sound("hl1/fvox/major_lacerations.wav"),
		Sound("hl1/fvox/near_death.wav"),
		Sound("hl1/fvox/seek_medic.wav"),
		Sound("hl1/fvox/torniquette_applied.wav"),
		Sound("hl1/fvox/voice_off.wav"),
		Sound("hl1/fvox/wound_sterilized.wav") }

GM.PropModels = {
		"models/props_junk/metal_paintcan001a.mdl",
		"models/props_junk/trafficcone001a.mdl",
		"models/props_junk/propanecanister001a.mdl",
		"models/props_junk/wood_crate001a.mdl",
		"models/props_interiors/radiator01a.mdl" }
		
GM.LargeModels = {
		"models/props_junk/trashdumpster01a.mdl",
		"models/props_interiors/vendingmachinesoda01a.mdl" }
		
GM.ExplosiveModels = {
		"models/props_c17/oildrum001_explosive.mdl",
		"models/props_junk/gascan001a.mdl" }

for k,v in pairs( GM.PropModels ) do
	util.PrecacheModel( v )
end

for k,v in pairs( GM.LargeModels ) do
	util.PrecacheModel( v )
end

for k,v in pairs( GM.ExplosiveModels ) do
	util.PrecacheModel( v )
end
