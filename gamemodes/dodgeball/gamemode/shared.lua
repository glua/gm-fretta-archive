DeriveGamemode( "fretta" )   

GM.Name		= "Dodgeball"
GM.Author	= "Termy58"
GM.Email	= "Termy58@gmail.com"
GM.Website	= "http://www.termy58.com/"
GM.Help     = "Grab the ball with the gravity gun and punt it"  

--With credit to
	--YouAreMea, dedicated shitlessly
	--Cani, revived the project at one point, dodgeball_logic
	--Primus8, db_terminus, help start project
	--Rambo_6, freeze effect, general influence
	--Jinto, huge influence from day one of coding
	--Foszor, helped me out a lot over the years
	--Gimmik
	--HQRSE
		--Thanks guys!
  
GM.TeamBased = true  
GM.AllowAutoTeam = true  
GM.AllowSpectating = true  
GM.SelectClass = false
GM.SecondsBetweenTeamSwitches = 5
GM.GameLength = 15
GM.NoPlayerDamage = true
GM.NoPlayerSelfDamage = true  
GM.NoPlayerTeamDamage = true  
GM.NoPlayerPlayerDamage = true 
GM.NoNonPlayerPlayerDamage = true  
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team
GM.NoAutomaticSpawning = true		// Players don't spawn automatically when they die, some other system spawns them
GM.RoundBased = true				// Round based, like CS
GM.RoundLength = 90					// Round length, in seconds

GM.RoundEndsWhenOneTeamAlive = true	// CS Style rules
//Team setup
	TEAM_RED	= 1
	TEAM_BLUE	= 2

function GM:CreateTeams()
	
	team.SetUp(TEAM_RED, "Red Team", Color( 255, 70, 70 ), true ) //suggested by CapsAdmin
	team.SetUp(TEAM_BLUE, "Blue Team", Color( 70, 125, 255 ), true ) //slightly changed darker
	
end
