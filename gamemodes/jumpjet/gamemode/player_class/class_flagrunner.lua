local CLASS = {}

CLASS.Base                  = "Base Class"
CLASS.DisplayName			= "Flagrunner"
CLASS.StartHealth			= 100
CLASS.MaxHealth				= 100
CLASS.WalkSpeed 			= 500
CLASS.RunSpeed				= 500
CLASS.JumpPower				= 400
CLASS.MaxFuel               = 60
CLASS.Primaries             = { "jj_steyr", "jj_p90", "jj_shotgun", "jj_mac10", "jj_deagles" }
CLASS.Secondaries           = { "jj_usp", "jj_knife" }

player_class.Register( "Flagrunner", CLASS )