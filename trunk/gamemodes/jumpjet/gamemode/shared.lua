
GM.Name 	= "Jumpjet CTF"
GM.Author 	= "Rambo_6"

DeriveGamemode( "fretta" )
IncludePlayerClasses()

GM.Help		= "Steal the enemy flag and bring it to your base!"
GM.TeamBased = true
GM.AllowAutoTeam = true
GM.AllowSpectating = true
GM.SelectClass = true
GM.SecondsBetweenTeamSwitches = 10
GM.GameLength = 18
GM.RoundBased = false

GM.NoPlayerSuicide = false
GM.NoPlayerDamage = false
GM.NoPlayerSelfDamage = false		// Allow players to hurt themselves?
GM.NoPlayerTeamDamage = true		// Allow team-members to hurt each other?
GM.NoPlayerPlayerDamage = false 	// Allow players to hurt each other?
GM.NoNonPlayerPlayerDamage = false 	// Allow damage from non players (physics, fire etc)
GM.NoPlayerFootsteps = false		// When true, all players have silent footsteps
GM.PlayerCanNoClip = false			// When true, players can use noclip without sv_cheats
GM.TakeFragOnSuicide = false			// -1 frag on suicide

GM.MaximumDeathLength = 10			// Player will repspawn if death length > this (can be 0 to disable)
GM.MinimumDeathLength = 5			// Player has to be dead for at least this long
GM.ForceJoinBalancedTeams = true	// Players won't be allowed to join a team if it has more players than another team

GM.NoAutomaticSpawning = false		
GM.RoundBased = true				
GM.RoundLength = 60 * 5      		
GM.RoundPreStartTime = 5			// Preperation time before a round starts
GM.RoundPostLength = 10				// Seconds to show the 'x team won!' screen at the end of a round
GM.RoundEndsWhenOneTeamAlive = false

GM.SuicideString = "suicided"
GM.EnableFreezeCam = false			// TF2 Style Freezecam
GM.DeathLingerTime = 0				// The time between you dying and it going into spectator mode, 0 disables

GM.ValidSpectatorModes = { OBS_MODE_FIXED }

TEAM_RED = 1
TEAM_BLUE = 2

function GM:CreateTeams()

	if ( !GAMEMODE.TeamBased ) then return end
	
	team.SetUp( TEAM_RED, "Outlaws", Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_RED, {"info_player_terrorist","info_player_rebel"} )
	team.SetClass( TEAM_RED, { "Flagrunner", "Gunslinger" } )
	
	team.SetUp( TEAM_BLUE, "Mercenaries", Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_BLUE, {"info_player_counterterrorist","info_player_combine"} )
	team.SetClass( TEAM_BLUE, { "Flagrunner", "Gunslinger" } )
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true )
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_start", "info_player_rebel", "info_player_counterterrorist" } ) 

end

function GM:PlayerTraceAttack( ply, dmginfo, dir, trace )

	if SERVER then
	
		GAMEMODE:ScalePlayerDamage( ply, trace.HitGroup, dmginfo )
		
		if not ply.DamageTimer then
		
			ply.DamageTimer = CurTime() + 1.5
			ply.DamageCounter = 1
		
		else
		
			ply.DamageCounter = ply.DamageCounter + 1
			
			if ply.DamageTimer < CurTime() then
			
				if ply.DamageCounter >= 3 then
				
					ply:EmitSound( table.Random( GAMEMODE.PlayerPain ), 150 )
				
				end
				
				ply.DamageTime = nil
				ply.DamageCounter = 0
			
			end
		
		end
		
		local ed = EffectData()
		ed:SetOrigin( trace.HitPos )
		ed:SetNormal( trace.HitNormal )
		ed:SetMagnitude( dmginfo:GetDamage() )
		util.Effect( "blood_splat", ed, true, true )
	
	end
	
	return false
	
end