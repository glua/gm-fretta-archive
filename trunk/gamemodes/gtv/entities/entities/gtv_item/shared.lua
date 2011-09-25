function ENT:SetupDataTables()
	self:DTVar("Int",0,"ItemType")
end

gtvitem_translate = {}
gtvitem_translate["smallammo"] = GTVITEM_AMMOSMALL
gtvitem_translate["mediumammo"] = GTVITEM_AMMOMEDIUM
gtvitem_translate["largeammo"] = GTVITEM_AMMOLARGE
gtvitem_translate["healthkit"] = GTVITEM_HEALTHKIT
gtvitem_translate["machinegun"] = GTVITEM_MACHINEGUN
gtvitem_translate["shotgun"] = GTVITEM_SHOTGUN
gtvitem_translate["minigun"] = GTVITEM_MINIGUN
gtvitem_translate["rocketlauncher"] = GTVITEM_ROCKETLAUNCHER
gtvitem_translate["seeker"] = GTVITEM_SEEKER
gtvitem_translate["flamethrower"] = GTVITEM_FLAMETHROWER
gtvitem_translate["beegun"] = GTVITEM_BEEGUN
gtvitem_translate["fraggrenade"] = GTVITEM_GRENADE_FRAG
gtvitem_translate["forcegrenade"] = GTVITEM_GRENADE_FORCE
gtvitem_translate["incendiarygrenade"] = GTVITEM_GRENADE_INCENDIARY
gtvitem_translate["shrapnelgrenade"] = GTVITEM_GRENADE_SHRAPNEL
gtvitem_translate["smallpoints"] = GTVITEM_POINTS_SMALL
gtvitem_translate["mediumpoints"] = GTVITEM_POINTS_MEDIUM
gtvitem_translate["bigpoints"] = GTVITEM_POINTS_BIG

local gtvcol = Color(53,157,211,255)
local gtvcol2 = Color(104,135,155,255)
local itemcol = Color(203,51,0,255)
PrecacheParticleSystem("gtv_item_bronze")
PrecacheParticleSystem("gtv_item_silver")
PrecacheParticleSystem("gtv_item_gold")

gtv_itemtable = {}
	--Small ammo box
	gtv_itemtable[GTVITEM_AMMOSMALL] = {
		["Model"] = "models/items/boxmrounds.mdl",
		["PickupFunction"] = function(self,hitent)
				if hitent:GetAmmoCount("pistol") < 200 then
					hitent:GiveAmmo(math.min(50,200-hitent:GetAmmoCount("pistol")),"pistol")
					hitent:SendNotification("picked up small ammo")
					return true
				end
				return false
			end,
		["Color"] = itemcol,
		["ParticleEffect"] = "gtv_ammoring_small"
		}
	--Medium ammo box
	gtv_itemtable[GTVITEM_AMMOMEDIUM] = {
		["Model"] = "models/items/boxmrounds.mdl",
		["PickupFunction"] = function(self,hitent)
				if hitent:GetAmmoCount("pistol") < 200 then
					hitent:GiveAmmo(math.min(100,200-hitent:GetAmmoCount("pistol")),"pistol")
					hitent:SendNotification("picked up medium ammo")
					return true
				end
				return false
			end,
		["Color"] = itemcol,
		["ParticleEffect"] = "gtv_ammoring_medium"
		}
	--Large ammo box
	gtv_itemtable[GTVITEM_AMMOLARGE] = {
		["Model"] = "models/items/item_item_crate.mdl",
		["PickupFunction"] = function(self,hitent)
				if hitent:GetAmmoCount("pistol") < 200 then
					hitent:GiveAmmo(math.min(200,200-hitent:GetAmmoCount("pistol")),"pistol")
					hitent:SendNotification("picked up large ammo")
					return true
				end
				return false
			end,
		["Color"] = itemcol,
		["ParticleEffect"] = "gtv_ammoring_large"
		}
	--Minigun
	gtv_itemtable[GTVITEM_MINIGUN] = {
		["Model"] = "models/weapons/w_irifle.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_minigun"):IsValid() || (hitent:GetAmmoCount("pistol") < 200) then
					hitent:Give("weapon_gtv_minigun")
					return true
				end
				return false
			end,
		["Color"] = gtvcol,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_minigun"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Flamethrower
	gtv_itemtable[GTVITEM_FLAMETHROWER] = {
		["Model"] = "models/weapons/w_irifle.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_flamethrower"):IsValid() || (hitent:GetAmmoCount("pistol") < 200)  then
					hitent:Give("weapon_gtv_flamethrower")
					return true
				end
				return false
			end,
		["Color"] = gtvcol,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_flamethrower"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Beegun
	gtv_itemtable[GTVITEM_BEEGUN] = {
		["Model"] = "models/weapons/w_physics.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_beegun"):IsValid() || (hitent:GetAmmoCount("pistol") < 200)  then
					hitent:Give("weapon_gtv_beegun")
					return true
				end
				return false
			end,
		["Color"] = gtvcol,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_beegun"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Rocket Launcher
	gtv_itemtable[GTVITEM_ROCKETLAUNCHER] = {
		["Model"] = "models/weapons/w_rocket_launcher.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_rocketlauncher"):IsValid() || (hitent:GetAmmoCount("pistol") < 200)  then
					hitent:Give("weapon_gtv_rocketlauncher")
					return true
				end
				return false
			end,
		["Color"] = gtvcol,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_rocketlauncher"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Shotgun
	gtv_itemtable[GTVITEM_SHOTGUN] = {
		["Model"] = "models/weapons/w_shotgun.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_shotgun"):IsValid() || (hitent:GetAmmoCount("pistol") < 200) then
					hitent:Give("weapon_gtv_shotgun")
					return true
				end
				return false
			end,
		["Color"] = gtvcol,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_shotgun"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Machinegun
	gtv_itemtable[GTVITEM_MACHINEGUN] = {
		["Model"] = "models/weapons/w_smg1.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_machinegun"):IsValid() || (hitent:GetAmmoCount("pistol") < 200) then
					hitent:Give("weapon_gtv_machinegun")
					return true
				end
				return false
			end,
		["Color"] = gtvcol,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_machinegun"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Seeker
	gtv_itemtable[GTVITEM_SEEKER] = {
		["Model"] = "models/weapons/w_physics.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_seeker"):IsValid() || (hitent:GetAmmoCount("pistol") < 200) then
					hitent:Give("weapon_gtv_seeker")
					return true
				end
				return false
			end,
		["Color"] = gtvcol,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_seeker"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Health Kit
	gtv_itemtable[GTVITEM_HEALTHKIT] = {
		["Model"] = "models/items/healthkit.mdl",
		["PickupFunction"] = function(self,hitent)
				if hitent:Health() < 100 then
					hitent:SetHealth(100)
					//hitent:EmitSound("player/suit_sprint.wav")
					hitent:EmitSound("gtv/relief4.wav")
					hitent:SendNotification("picked up a health kit!")
					return true
				end
				return false
			end,
		["Color"] = Color(0,153,0,255),
		["Icon"] = SERVER||surface.GetTextureID("gtv/healthcross")
		}
	--Frag Grenade
	gtv_itemtable[GTVITEM_GRENADE_FRAG] = {
		["Model"] = "models/Items/grenadeAmmo.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_grenade_frag"):IsValid() || (hitent:GetAmmoCount("pistol") < 200) then
					hitent:Give("weapon_gtv_grenade_frag")
					return true
				end
				return false
			end,
		["Color"] = gtvcol2,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_grenade_frag"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Force Grenade
	gtv_itemtable[GTVITEM_GRENADE_FORCE] = {
		["Model"] = "models/Items/grenadeAmmo.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_grenade_force"):IsValid() || (hitent:GetAmmoCount("pistol") < 200) then
					hitent:Give("weapon_gtv_grenade_force")
					return true
				end
				return false
			end,
		["Color"] = gtvcol2,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_grenade_force"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Incendiary Grenade
	gtv_itemtable[GTVITEM_GRENADE_INCENDIARY] = {
		["Model"] = "models/Items/grenadeAmmo.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_grenade_incendiary"):IsValid() || (hitent:GetAmmoCount("pistol") < 200) then
					hitent:Give("weapon_gtv_grenade_incendiary")
					return true
				end
				return false
			end,
		["Color"] = gtvcol2,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_grenade_incendiary"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Shrapnel Grenade
	gtv_itemtable[GTVITEM_GRENADE_SHRAPNEL] = {
		["Model"] = "models/Items/grenadeAmmo.mdl",
		["PickupFunction"] = function(self,hitent)
				if !hitent:GetWeapon("weapon_gtv_grenade_shrapnel"):IsValid() || (hitent:GetAmmoCount("pistol") < 200) then
					hitent:Give("weapon_gtv_grenade_shrapnel")
					return true
				end
				return false
			end,
		["Color"] = gtvcol2,
		["Icon"] = SERVER||surface.GetTextureID("gtv/weapons/weapon_gtv_grenade_shrapnel"),
		["ParticleEffect"] = "gtv_weaponring"
		}
	--Small Points (Bronze Statue)
	gtv_itemtable[GTVITEM_POINTS_SMALL] = {
		["Model"] = "models/props_combine/breenbust.mdl",
		["CustomInit"] = function(self)
			self:SetMaterial("models/shiny")
			self:SetColor(178,106,0,255)
		end,
		["PickupFunction"] = function(self,hitent)
				hitent:SendPointNotification(self:GetPos(),100)
				hitent:AddFrags(100)		
				hitent:EmitToAllButSelf("weapons/fx/rics/ric5.wav",80,255)
				hitent:SendNotification("picked up small points")
				return true
			end,
		["ParticleEffect"] = "gtv_item_bronze",
		["Color"] = Color(0,153,0,255)
		}
	--Medium Points (Silver Melon)
	gtv_itemtable[GTVITEM_POINTS_MEDIUM] = {
		["Model"] = "models/props_junk/watermelon01.mdl",
		["CustomInit"] = function(self)
			self:SetMaterial("models/shiny")
			self:SetColor(214,214,214,255)
		end,
		["PickupFunction"] = function(self,hitent)
				hitent:SendPointNotification(self:GetPos(),500)
				hitent:AddFrags(500)
				hitent:EmitToAllButSelf("weapons/fx/rics/ric1.wav",80,255)
				hitent:SendNotification("picked up medium points")
				return true
			end,
		["ParticleEffect"] = "gtv_item_silver",
		["Color"] = Color(0,153,0,255)
		}
	--Big Points (Gold TV)
	gtv_itemtable[GTVITEM_POINTS_BIG] = {
		["Model"] = "models/props_c17/tv_monitor01.mdl",
		["CustomInit"] = function(self)
			self:SetMaterial("models/shiny")
			self:SetColor(251,255,74,255)
		end,
		["PickupFunction"] = function(self,hitent)
				hitent:SendPointNotification(self:GetPos(),1000)
				hitent:AddFrags(1000)
				hitent:EmitToAllButSelf("weapons/fx/rics/ric2.wav",80,255)
				hitent:SendNotification("picked up BIG POINTS")
				return true
			end,
		["ParticleEffect"] = "gtv_item_gold",
		["Color"] = Color(0,153,0,255)
		}
