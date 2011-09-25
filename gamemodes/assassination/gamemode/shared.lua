// Fretta. derived
DeriveGamemode( "fretta" )
IncludePlayerClasses()

// Includes
include( "weapons.lua" );
include( "player_extensions.lua" );
include( "player_animation.lua" );

-- Configurable cvars
as_roundlength = CreateConVar( "as_roundlength", "3", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE } )

GM.Name 			= "Assassination"
GM.Author 			= "SteveUK"
GM.Email 			= "stephen.swires@gmail.com"
GM.Website 			= "http://s-swires.org/"

GM.Help				= "As the Combine, you must escort Dr Breen (which is a random player), to the extraction point. The objective of the Rebels is assassinate Dr Breen before he gets to safety."

// Fretta Settings
GM.TeamBased 						= true;
GM.AllowAutoTeam 					= true;
GM.AllowSpectating 					= true;
GM.SecondsBetweenTeamSwitches 		= 10;
GM.GameLength 						= 15;

GM.NoPlayerSuicide 					= false;
GM.NoPlayerTeamDamage 				= true;
GM.TakeFragOnSuicide 				= true;

GM.AutomaticTeamBalance			 	= true; // keep everything in check
GM.ForceJoinBalancedTeams 			= true;
GM.RealisticFallDamage 				= true;

GM.NoAutomaticSpawning 				= true;
GM.RoundBased 						= true;
GM.RoundLength 						= 150; // 2:30
GM.RoundPreStartTime 				= 5;
GM.RoundPostLength 					= 10;
GM.RoundEndsWhenOneTeamAlive 		= true; // yes, but it still needs to check if Dr. Breen was killed

GM.DeathLingerTime 					= 5; // yay we died early.
GM.SelectModel 						= false; // nope, sorry.
GM.SuicideString 					= "had enough";

GM.ValidSpectatorModes 				= { OBS_MODE_CHASE, OBS_MODE_IN_EYE }; // no we can't use no clip
GM.ValidSpectatorEntities 			= { "player" };

// Team Enums
TEAM_COMBINE		= 5;
TEAM_REBELS			= 6;

/*---------------------------------------------------------
   Name: gamemode:CreateTeams()
   Desc: Note - HAS to be shared.
---------------------------------------------------------*/
function GM:CreateTeams()

	GAMEMODE.RoundLength = as_roundlength:GetFloat() * 60;
	
	if ( !GAMEMODE.TeamBased ) then return end

	team.SetUp( TEAM_COMBINE, "Combine Soldiers", Color( 80, 150, 255 ), true );
	team.SetSpawnPoint( TEAM_COMBINE, { "info_player_terrorist", "info_player_rebel", "info_player_axis" } );
	team.SetClass( TEAM_COMBINE, { "Combine_Soldier" } );
	
	team.SetUp( TEAM_REBELS, "Rebels", Color( 255, 80, 80 ), true );
	team.SetSpawnPoint( TEAM_REBELS, { "info_player_counterterrorist", "info_player_combine", "info_player_allies" } );
	team.SetClass( TEAM_REBELS, { "Rebel_Assault" } );
	
	team.SetUp( TEAM_SPECTATOR, "Spectators", Color( 255, 255, 80 ), true );
	team.SetSpawnPoint( TEAM_SPECTATOR, { "info_player_terrorist", "info_player_rebels", "point_viewcontrol", "info_player_start" } );

end


function GM:GetRagdollEyes( ply )

	local Ragdoll = nil
	
	Ragdoll = ply:GetRagdollEntity()
	if ( !Ragdoll ) then return end
	
	
	local att = Ragdoll:GetAttachment( Ragdoll:LookupAttachment("eyes") )
	if ( att ) then
	
		local RotateAngle = Angle( math.sin( CurTime() * 0.5 ) * 30, math.cos( CurTime() * 0.5 ) * 30, math.sin( CurTime() * 1 ) * 30 )	

		att.Pos = att.Pos + att.Ang:Forward() * 1
		att.Ang = att.Ang
		
		return att.Pos, att.Ang
	
	end
	

end

function GM:CalcView( ply, origin, angle, fov )

	if( ply:IsObserver() and ply:GetObserverTarget() and ply:GetObserverTarget():IsPlayer() ) then ply = ply:GetObserverTarget() end
	if( !ply ) then return end
	
	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	ply.LastStrafeRoll = ply.LastStrafeRoll or 0
	ply.WalkTimer = ply.WalkTimer or 0
	ply.VelSmooth = ply.VelSmooth or 0	
	
	local RagdollPos, RagdollAng = self:GetRagdollEyes( ply )
	if ( RagdollPos && RagdollAng && !ply:Alive() ) then
		return self.BaseClass:CalcView( ply, RagdollPos, RagdollAng, 90 )
	end

	ply.VelSmooth = math.Clamp( ply.VelSmooth * 0.9 + vel:Length() * 0.1, 0, 700 )
	
	ply.WalkTimer = ply.WalkTimer + ply.VelSmooth * FrameTime() * 0.05
	
	// Roll on strafe (smoothed)
	ply.LastStrafeRoll = (ply.LastStrafeRoll * 3) + (ang:Right():DotProduct( vel ) * 0.0001 * ply.VelSmooth * 0.3)
	ply.LastStrafeRoll = ply.LastStrafeRoll * 0.25
	angle.roll = angle.roll + ply.LastStrafeRoll
	

	// Roll on steps
	if ( ply:GetGroundEntity() != NULL ) then	
	
		angle.roll = angle.roll + math.sin( ply.WalkTimer ) * ply.VelSmooth * 0.000002 * ply.VelSmooth
		angle.pitch = angle.pitch + math.cos( ply.WalkTimer * 0.5 ) * ply.VelSmooth * 0.000002 * ply.VelSmooth
		angle.yaw = angle.yaw + math.cos( ply.WalkTimer ) * ply.VelSmooth * 0.000002 * ply.VelSmooth
		
	end
	
	angle = angle + ply:HeadshotAngles() + ply:ShootShakeAngles()
	
	return self.BaseClass:CalcView( ply, origin, angle, fov )

end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	
	if( hitgroup == HITGROUP_HEAD ) then
	
		if( ply:IsBreen() && dmginfo:GetDamage() >= 50 ) then // increase sniper damage on teh breen
			dmginfo:ScaleDamage( 10 );
		else
			dmginfo:ScaleDamage( 5 );
		end
	
	elseif( ply:IsBreen() ) then
		dmginfo:ScaleDamage( 0.5 ); // do half of the damage everywhere else
	elseif( hitgroup == HITGROUP_CHEST ) then
		dmginfo:ScaleDamage( 2 );
	elseif( hitgroup == HITGROUP_LEFTLEG || hitgroup == HITGROUP_RIGHTLEFT ) then
		dmginfo:ScaleDamage( 0.75 );
	elseif( hitgroup == HITGROUNP_LEFTARM || hitgroup == HITGROUP_LEFTLEG ) then
		dmginfo:ScaleDamage( 0.5 );
	end
	
	if( ply:IsBreen() && ( dmginfo:GetDamageType() == DMG_BLAST || dmginfo:GetDamageType() == DMG_FALL ) ) then
		dmginfo:ScaleDamage( 0.25 ); // lower blast and fall damage for breen
	end
	
	return dmginfo;
	
end