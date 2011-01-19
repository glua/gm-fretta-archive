-- Includes
include( "shared.lua" )
include( "resources.lua" )

function GM:ShouldGibEntity( pl, dmginfo )
	if( dmginfo:GetDamage() > 70 ) then
		return true
	end
	
	return false
end

/*---------------------------------------------------------
   Name: gamemode:DoPlayerDeath( )
   Desc: Player died.
---------------------------------------------------------*/
function GM:DoPlayerDeath( pl, attacker, dmginfo )

	-- explode player tripmines on death
	local tTripmines = ents.FindByClass( "item_tripmine" );
	local iCount = 0
	
	for k, v in pairs( tTripmines ) do
		if( v:GetNetworkedEntity( "Thrower" ) == pl and v.Laser and v.Laser:IsValid() and v.Laser.Activated == true and v.Laser:GetActiveTime( ) != 0 and v.Laser:GetActiveTime( ) < CurTime( ) ) then
			v:Explode()
		end
	end
	
	local Inflictor = dmginfo:GetInflictor()
	
	if( Inflictor == attacker and ( attacker:IsPlayer() or attacker:IsNPC() ) ) then
		Inflictor = attacker:GetActiveWeapon()
	end
	
	if( Inflictor.WeaponKilledPlayer != nil ) then
		Inflictor:WeaponKilledPlayer( pl, dmginfo )
	end
		
	// If we were hurt a lot then gib us
	if ( GAMEMODE:ShouldGibEntity( pl, dmginfo ) ) then
		pl:Gib( dmginfo )
	else
		pl:CreateRagdoll()
	end
	
	// Increment death counter
	pl:AddDeaths( 1 )
	
	// Add frag to killer
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == pl ) then
			attacker:AddFrags( -1 )
			attacker:PrintMessage( HUD_PRINTCENTER, "You killed yourself!" );
		else
			attacker:AddFrags( 1 )
			attacker:PrintMessage( HUD_PRINTCENTER, "You fragged " .. pl:Name() );
			pl:PrintMessage( HUD_PRINTCENTER, "You were killed by " .. attacker:Name() );
			pl:SetNetworkedFloat( "DeathTime", CurTime() );
			timer.Simple( 1.5, self.FreezeCam, self, pl, attacker );
		end
		
	end

end

function GM:FreezeCam( pl, attacker )

	if( ValidEntity( pl ) and ValidEntity( attacker ) and !pl:Alive() ) then
		pl:Spectate( OBS_MODE_FREEZECAM );
		pl:SpectateEntity( attacker );
		pl:SendLua( "LocalPlayer():EmitSound( \"Player.FreezeCam\" );" );
	end
	
end

/*---------------------------------------------------------
   Name: gamemode:EntityTakeDamage( entity, inflictor, attacker, amount, dmginfo )
   Desc: The entity has received damage	 
---------------------------------------------------------*/
function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if ( ent:IsPlayer() ) then
		ent:OnTakeDamage( inflictor, attacker, amount, dmginfo );
	end

end
