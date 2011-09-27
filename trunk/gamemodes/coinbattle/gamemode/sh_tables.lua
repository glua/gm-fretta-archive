
GM.WinSound = Sound("common/stuck1.wav")
GM.LoseSound = Sound("items/suitchargeok1.wav")

CoinTable = {
	[1] = {
		type = "coin_gold",
		value = 10
	},
	[2] = {
		type = "coin_silver",
		value = 5
	},
	[3] = {
		type = "coin_copper",
		value = 1
	},
}

WeaponTable = {
	[1] = {
		[1] = {
			name = "SMG",
			cost = 10,
			entity = "cb_weapon_smg",
			help = "Standard issue SMG, good accuracy and high rate of fire.\n\nPrimary Fire: Fire bullets, fully auto.\n\nSecondary Fire: Enter Ironsights."
		},
		[2] = {
			name = "Shotgun",
			cost = 20,
			entity = "cb_weapon_shotgun",
			help = "A powerful close range weapon, slow firing, but powerful.\n\nPrimary Fire: Fire bullets.\n\nSecondary Fire: Unleash a powerful blast that sends you flying backwards."
		},
		[3] = {
			name = "Double Mine",
			cost = 40,
			entity = "cb_weapon_doublemine",
			help = "A mine laying device, fires 2 mines at a time, only allows 6 mines to be deployed at one time.\n\nPrimary Fire: Fire mines horizontally.\n\nSecondary Fire: Fire mines vertically."
		}
	},
	[2] = {
		[1] = {
			name = "Pistol",
			cost = 10,
			entity = "cb_weapon_pistol",
			help = "Standard issue Pistol, powerful secondary weapon for tough situations.\n\nPrimary Fire: Fire bullets.\n\nSecondary Fire: Fires a burst of bullets."
		},
		[2] = {
			name = "Cloak",
			cost = 20,
			entity = "cb_weapon_cloak",
			help = "A device that will cloak you from enemy eyes, however cloaking does slow you down.\n\nPrimary and Secondary Fire: Toggle device state."
		},
		// [3] = {
		// 	name = "Medic Gun",
		// 	cost = 40,
		// 	entity = "cb_weapon_medgun"
		// }
	},
	[3] = {
		[1] = {
			name = "Frag",
			cost = 10,
			entity = "cb_nade_base",
			help = "Typical Grenade."
		}
	}
}