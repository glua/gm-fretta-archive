
local CLASS = {}

CLASS.Base 				= "rifleman"
CLASS.DisplayName		= "Rifleman"
CLASS.Description       = "Balanced Default Class"
CLASS.PlayerModel		= "models/player/combine_soldier.mdl"

player_class.Register( "C_Rifleman", CLASS )

local CLASS ={}
CLASS.Base 				= "smgman"
CLASS.DisplayName		= "Sub Machine Gunner"
CLASS.Description       = "Pros: Fast Cons: Weak"
CLASS.PlayerModel		= "models/player/police.mdl"

player_class.Register( "C_SMG_Gunner", CLASS )

local CLASS ={}
CLASS.Base 				= "medic"
CLASS.DisplayName		= "Medic"
CLASS.Description       = "Pros: Heals Cons: Short Range"
CLASS.PlayerModel		= "models/player/combine_soldier_prisonguard.mdl"

player_class.Register( "C_Medic", CLASS )