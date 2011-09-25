local CLASS = {}

CLASS.Base                  = "Base Class"
CLASS.DisplayName			= "Gunslinger"
CLASS.StartHealth			= 300
CLASS.MaxHealth				= 300
CLASS.WalkSpeed 			= 350
CLASS.RunSpeed				= 350
CLASS.JumpPower				= 300
CLASS.MaxFuel               = 40
CLASS.Primaries             = { "jj_spas12", "jj_ak74", "jj_m79", "jj_m249", "jj_awp" }
CLASS.Secondaries           = { "jj_deagle", "jj_rpg" }

player_class.Register( "Gunslinger", CLASS )