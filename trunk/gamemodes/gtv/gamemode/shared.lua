DeriveGamemode( "fretta" )

-- gamerules
GM.Name 	= "Garry TV"
GM.Author 	= "TEAM REALTALK"
GM.Help		= "Top Down Mayhem!"

GM.TeamBased = false
GM.AllowAutoTeam = true
GM.NoPlayerSelfDamage = false	
GM.AllowSpectating = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 15.75
GM.MaximumDeathLength = 10			// Player will repspawn if death length > this (can be 0 to disable) --hank I am setting this to ten to let the player see their own death if they want
GM.MinimumDeathLength = 1			// Player has to be dead for at least this long
GM.NoPlayerTeamDamage = false 
GM.RealisticFallDamage = false
GM.NoPlayerSuicide = false
GM.NoAutomaticSpawning = false	
GM.TakeFragOnSuicide = true
GM.SelectColor = true

GM.RoundBased = true
GM.RoundLength = 300
GM.RoundPreStartTime = 3
GM.RoundPostLength = 10
GM.RoundEndsWhenOneTeamAlive = false
GM.MaxCameraHeight = 800

IncludePlayerClasses()

function GM:Initialize()
	
	if( CLIENT ) then
	--lol don't you worry about this ghor you filthy faggot slut i'm reading this out loud to poringez on skype
	-- i hope you enjoy the comments i leave
	end
	
	self.BaseClass:Initialize()
	
end


function GM:CreateTeams()

	team.SetUp( TEAM_UNASSIGNED, "Players", Color( 70, 230, 70 ) )
	team.SetClass( TEAM_UNASSIGNED, { "default_gtv" } )
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 200, 200, 200 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "point_viewcontrol" } )
	team.SetClass( TEAM_SPECTATOR, { "Spectator" } )

end

_E.GTVITEM_AMMOSMALL = 0
_E.GTVITEM_AMMOMEDIUM = 1
_E.GTVITEM_AMMOLARGE = 2
_E.GTVITEM_HEALTHKIT = 3
_E.GTVITEM_MACHINEGUN = 4
_E.GTVITEM_SHOTGUN = 5
_E.GTVITEM_MINIGUN = 6
_E.GTVITEM_ROCKETLAUNCHER = 7
_E.GTVITEM_SEEKER = 8
_E.GTVITEM_FLAMETHROWER = 9
_E.GTVITEM_BEEGUN = 10
_E.GTVITEM_GRENADE_FRAG = 11
_E.GTVITEM_GRENADE_FORCE = 12
_E.GTVITEM_GRENADE_INCENDIARY = 13
_E.GTVITEM_GRENADE_SHRAPNEL = 14
_E.GTVITEM_POINTS_SMALL = 15
_E.GTVITEM_POINTS_MEDIUM = 16
_E.GTVITEM_POINTS_BIG = 17
