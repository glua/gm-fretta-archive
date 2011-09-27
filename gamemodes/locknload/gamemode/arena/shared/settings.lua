GM.Name 	= "Lock 'n Load - Arena"

GM.Help		= "Before spawning, select and customise two weapons.\n\nArena Mode:\n    To win the round for your team, kill all the players on the other team, or capture the marked zone.\n    You do not respawn in Arena Mode - keep yourself alive, but stop the enemy team capturing the zone!"

GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15
GM.VotingDelay = 8

GM.NoPlayerTeamDamage = true

GM.NoAutomaticSpawning = true
GM.RoundBased = true
GM.RoundLimit = -1
GM.RoundLength = 150
--GM.RoundPreStartTime = 10
GM.RoundPreStartTime = 15
GM.RoundPostLength = 8
GM.RoundEndsWhenOneTeamAlive = true

GM.CaptureZoneActivationDelay = 15
GM.CaptureZoneTimeRequired = 15

--Resources!

resource.AddFile ("materials/lnl/white_notnoz.vmt")
