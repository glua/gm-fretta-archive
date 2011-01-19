
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_scores.lua" )
AddCSLuaFile( "vgui_scoreboard_team.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "prop_list.lua" )

include( "shared.lua" )
include( "concommands.lua" )

resource.AddFile( "models/fw/fw_flag.dx80.vtx" )
resource.AddFile( "models/fw/fw_flag.dx90.vtx" )
resource.AddFile( "models/fw/fw_flag.mdl" )
resource.AddFile( "models/fw/fw_flag.phy" )
resource.AddFile( "models/fw/fw_flag.sw.vtx" )
resource.AddFile( "models/fw/fw_flag.vvd" )

resource.AddFile( "materials/models/fw/flaginner.vmt" )
resource.AddFile( "materials/models/fw/flaginner.vtf" )
resource.AddFile( "materials/models/fw/flaginner_dudv.vtf" )
resource.AddFile( "materials/models/fw/flaginner_normal.vtf" )
resource.AddFile( "materials/models/fw/flagouter.vmt" )
resource.AddFile( "materials/models/fw/flagouter.vtf" )
resource.AddFile( "materials/models/fw/flagouter_normal.vtf" )

resource.AddFile( "materials/fw/flag.vtf" )
resource.AddFile( "materials/fw/flag.vmt" )
resource.AddFile( "materials/fw/explode.vtf" )
resource.AddFile( "materials/fw/explode.vmt" )

resource.AddFile( "materials/effects/fw/firecloud.vtf" )
resource.AddFile( "materials/effects/fw/firecloud.vmt" )
resource.AddFile( "materials/effects/fw/firestream.vtf" )
resource.AddFile( "materials/effects/fw/firestream.vmt" )

local snd = "Buttons.snd6" //Blip!

function Init()
	
	for _, v in pairs( player.GetAll() ) do
		v:SetNWInt( "Props", 0 ) //All players start with 0 props!
	end
	
end

hook.Add( "Initialize", "Sett0r", Init )

function OnDrop( ply, ent )
	if ( ent:GetClass() == "fw_prop" ) then
		ent:GetPhysicsObject():EnableMotion( false ) //If the player stops holding the object, freeze it!
	end
end

hook.Add( "PhysgunDrop", "Freez0r", OnDrop )

function OnReload( weapon, player )

	local ent = player:GetEyeTrace().Entity
	if ( ent:IsValid() and ent:GetNWEntity( "Owner", NULL ) == player ) then
		ent:Remove() //Remove objects
		player:SetNWInt( "Props", player:GetNWInt( "Props", 0 ) - 1 ) //I really shouldn't be doing it like this, it might fuck up if you rapidly spawn and remove props...
		player:EmitSound( snd )
	end
	
	return false //Don't unfreeze it
	
end

hook.Add( "OnPhysgunReload", "Remov0r", OnReload )

function ScaleDamage( ply, hitgroup, dmginfo )
	
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 2 )
		HeadShot( ply )
	end
 
	if ( hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_GEAR ) then
		dmginfo:ScaleDamage( 0.5 )
	end
	
	/*if ( dmginfo:GetAttacker():IsPlayer() ) then
		dmginfo:GetAttacker():ChatPrint( "You damaged " .. ply:Nick() .. " with " .. tostring( dmginfo:GetDamage() ) .. " percent!" )
	end*/
 
end
 
hook.Add( "ScalePlayerDamage", "Scal0r", ScaleDamage )

local headshotsnd = { "player/headshot1.wav", "player/headshot2.wav" }

function HeadShot( ply )
	ply:EmitSound( table.Random( headshotsnd ) )
end

function GM:GravGunPickupAllowed( ply, ent )
	if ( !ValidEntity( ent ) ) then return end
	if ( ent:GetClass() != "fw_flag" and ent:GetClass() != "fw_c4" ) then return false end //Can only pick up the flag and bombs!
	return true
end

function GM:OnPreRoundStart( num )//Stop it clearing the map when the first round ends. Taken from carnag's Fortwars

	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
	-------------------------------------------------
	
	if ( GetGlobalInt( "RoundNumber" ) == 2 ) then
	
		local ent = ents.FindByName( "separator" )[1] //Remove the wall, so enemies can actually kill eachother!
		SafeRemoveEntity( ent )
		
		for _, v in pairs( ents.FindByClass( "func_fw_propfield" ) ) do
			v:Remove()
		end
		
	end

end

function TookDamage( ent, inflictor, attacker, amount, dmginfo )
	
	local flag = GetFlag()
	if ( !ValidEntity( flag ) ) then return end
	
	if ( ent:IsPlayer() ) then
		if ( inflictor == flag ) then
			dmginfo:SetDamageType( DMG_DISSOLVE ) //Remember, the flag inner stuff is highly dissolving! This function is very recent, the Gmod Lua Notepad++ plugin doesn't even recognize it :D
		end
	end
	
end

hook.Add( "EntityTakeDamage", "Disintegrat0r", TookDamage )

function GetFlag() //This returns the flag entity
	local flag = ents.FindByClass( "fw_flag" )[1]
	if ( !ValidEntity( flag ) ) then print( "No flag entity! Whine at mapper!" ) return end
	return flag
end

local lastcheck = CurTime()

function Think()

	local flag = GetFlag()
	if ( !ValidEntity( flag ) ) then return end
	
	local physobj = flag:GetPhysicsObject()
	if ( GetGlobalInt( "RoundNumber" ) != 2 ) then
		physobj:EnableMotion( false ) //Freeze flag if we're not in the fight phase
	else
		physobj:EnableMotion( true )
		local holder = flag:GetNWEntity( "CheckHolder", NULL )
		if ( ValidEntity( holder ) and lastcheck < CurTime() ) then
			if ( flag:IsPlayerHolding() ) then
				if ( flag:GetNWBool( "Check", false ) ) then
					lastcheck = CurTime() + 1 //Add points every second if someone is holding the ball
					team.AddScore( holder:Team(), 1 )
				end
			else
				if ( flag:GetNWVector( "RColor", Vector( 1, 1, 1 ) ) != Vector( 1, 1, 1 ) ) then
					flag:SetNWVector( "RColor", Vector( 1, 1, 1 ) ) //Make it white if dropped!
				end
			end
		end
	end
	
end

hook.Add( "Think", "Freez0r2", Think )

function GM:PlayerLoadout( ply )

	ply:CheckPlayerClassOnSpawn()

	ply:OnLoadout()
	
	// Switch to prefered weapon if they have it
	local cl_defaultweapon = ply:GetInfo( "cl_defaultweapon" )
	
	if ( ply:HasWeapon( cl_defaultweapon )  ) then
		ply:SelectWeapon( cl_defaultweapon ) 
	end
	
	----------------------------------------------------------------------------------------------------------
	
	if ( GetGlobalInt( "RoundNumber" ) <= 1 ) then //Give physgun and spawnpoint gun if we're in the building phase
		ply:StripWeapons()
		ply:Give( "weapon_physgun" )
		ply:Give( "weapon_fw_spawnpoint" )
	end
	
end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )

	// Here's an immediate respawn thing by default. If you want to 
	// re-create something more like CS or some shit you could probably
	// change to a spectator or something while dead.
	if ( newteam == TEAM_SPECTATOR ) then
	
		// If we changed to spectator mode, respawn where we are
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )
		
	elseif ( oldteam == TEAM_SPECTATOR ) then
	
		// If we're changing from spectator, join the game
		if ( !GAMEMODE.NoAutomaticSpawning ) then
			ply:Spawn()
		end
	
	else
	
		// If we're straight up changing teams just hang
		//  around until we're ready to respawn onto the 
		//  team that we chose
		
	end
	
	PrintMessage( HUD_PRINTTALK, Format( "%s joined '%s'", ply:Nick(), team.GetName( newteam ) ) )
	
	// From here is the custom stuff which happens upon changing teams -------------------------------------------------------
	
	ply:SetNWVector( "Spawnpoint", Vector(0,0,0) ) //Reset spawnpoint
	ply:SetNWAngle( "Spawnang", Angle(0,0,0) )
	ply:SetNWInt( "Props", 0 ) //Set his prop count to zero
	RemoveAllProps( ply ) //Remove all his props. This function is defined here VVV
	
end

function RemoveAllProps( ply )
	for _, v in pairs( ents.FindByClass( "fw_prop" ) ) do
		if ( v:GetNWEntity( "Owner" ) == ply ) then
			v:Remove()
		end
	end
end

function GM:OnRoundEnd( num )
	if ( GetGlobalInt( "RoundNumber" ) == 2 ) then
		UTIL_FreezeAllPlayers() //Freeze all players
		UTIL_StripAllPlayers() //Strip their weapons
	end
end

function GM:PlayerDeathSound()
	return true //Don't play the stupid BEEEEEEEEEEEEEEEEEEEP sound
end

function GravPickup( ply, ent )
	if ( ent:GetClass() == "fw_flag" ) then
		local col = team.GetColor( ply:Team() )
		ent:SetNWVector( "RColor", Vector( col.r / 127, col.g / 127, col.b / 127 ) ) //Change the color of the flag
		ent:SetNWBool( "Check", true ) //Start adding seconds to the team time
		ent:SetNWEntity( "CheckHolder", ply ) //This indicates what player last picked up the flag
		TellEveryone( "TAKE", ply:Team() ) //Flag has been taken!
	end
	return true
end

hook.Add( "GravGunOnPickedUp", "Color0r", GravPickup )

function GravityDropFunction( ply, ent )
	ent:SetNWVector( "RColor", Vector( 1, 1, 1 ) ) //Color the flag white
	ent:SetNWBool( "Check", false ) //Stop adding seconds to the team hold-on time  
	TellEveryone( "DROP", ply:Team() ) //Flag has been dropped!
	ent:SetOwner( NULL ) //Avoid the flag getting no-collided with ply
end

function GravDrop( ply, ent )
	if ( ent:GetClass() == "fw_flag" ) then
		GravityDropFunction( ply, ent ) //Execute gravity gun drop function
	end
end

hook.Add( "GravGunOnDropped", "Color0r2", GravDrop )

function Death( ply, inflictor, attacker )

	local ent = GetFlag()
	if ( !ValidEntity( ent ) ) then return end
	
	if ( ent:GetNWEntity( "CheckHolder", NULL ) == ply and ent:IsPlayerHolding() ) then
		GravityDropFunction( ply, ent ) //Execute gravity gun drop function
	end
	
	PlayDeathSound( ply ) //Defined here vvvv
	
end

function PlayDeathSound( ply )

	local rndsnd = Sound( "npc_citizen.pain0"..math.random(1,9) )
	local choose = math.random(1,4)
		
	if (choose == 3) then
		rndsnd = Sound( "npc_barney.ba_no0" .. math.random(2) )
	end
	
	if (choose == 4) then
		rndsnd = Sound( "npc_citizen.no0" .. math.random(2) )
	end
	
	ply:EmitSound( rndsnd, 160, 100 ) //OUCH
	
end

hook.Add( "PlayerDeath", "Dropp0r", Death )
hook.Add( "DoPlayerDeath", "Stripp0r", function( a, b, c ) a:StripWeapon( "weapon_physcannon" ) end )
//^ Avoid the flag getting no-collided with you if you die while holding the flag

function TellEveryone( msg, Team )
	for _, v in pairs( player.GetAll() ) do
		v:ConCommand( Format( "fwx_flagwarn %s %s", msg, Team ) ) //Warn them!
	end
end