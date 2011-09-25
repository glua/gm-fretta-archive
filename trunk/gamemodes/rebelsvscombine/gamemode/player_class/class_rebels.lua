include( "rebelplayers.lua" )

local CLASS = {}

CLASS.Base 				= "rifleman"
CLASS.DisplayName		= "Rifleman"
CLASS.Description       = "Balanced Default Class"
CLASS.PlayerModel		= table.Random( rebels[1] )

player_class.Register( "R_Rifleman", CLASS )

local CLASS ={}
CLASS.Base 				= "smgman"
CLASS.DisplayName		= "Sub Machine Gunner"
CLASS.Description       = "Pros: Fast Cons: Weak"
CLASS.PlayerModel		= table.Random( rebels[2] )

player_class.Register( "R_SMG_Gunner", CLASS )

local CLASS ={}
CLASS.Base 				= "medic"
CLASS.DisplayName		= "Medic"
CLASS.Description       = "Pros: Heals Cons: Short Range"
CLASS.PlayerModel		= table.Random( rebels[3] )

player_class.Register( "R_Medic", CLASS )