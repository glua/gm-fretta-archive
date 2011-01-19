local explodesound_1 = Sound ( "ambient/explosions/explode_8.wav" )
local explodesound_2 = Sound ( "weapons/underwater_explode3.wav" )

function GMDM_Explosion( Pos, Attacker, Inflictor, Damage, Radius )

	// Shake the screen of anyone close to the explosion
	util.ScreenShake( Pos, 100, 100, 1, 2048 )
	
	// Play sounds
	WorldSound( explodesound_1, Pos, 100, math.Rand( 50, 150 ) )
	WorldSound( explodesound_1, Pos, 120, math.Rand( 50, 150 ) )
	WorldSound( explodesound_2, Pos, 130, math.Rand( 90, 100 ) )
	
	// Do visuals
	local effectdata = EffectData()
		effectdata:SetEntity( Attacker )
		effectdata:SetOrigin( Pos )
	util.Effect( "gmdm_explosion", effectdata )

	// Hurt players
	util.BlastDamage( Inflictor, Attacker, Pos, Radius, Damage )
	
end


function GMDM_Explosion_Electric( Pos, Attacker, Inflictor, Damage, Radius )

	if( !ValidEntity( Attacker ) || !ValidEntity( Inflictor ) ) then return end
	
	// Shake the screen of anyone close to the explosion
	util.ScreenShake( Pos, 100, 100, 1, 2048 )
	
	// Play sounds
	WorldSound( explodesound_1, Pos, 100, math.Rand( 50, 150 ) )
	WorldSound( explodesound_1, Pos, 120, math.Rand( 50, 150 ) )
	WorldSound( explodesound_2, Pos, 130, math.Rand( 90, 100 ) )
	
	// Do visuals
	local effectdata = EffectData()
		effectdata:SetEntity( Attacker )
		effectdata:SetOrigin( Pos )
	//util.Effect( "gmdm_explosion_electric", effectdata )
	util.Effect( "gmdm_explosion", effectdata )
	// Hurt players
	util.BlastDamage( Inflictor, Attacker, Pos, Radius, Damage )
	
end

function GM:GetHitboxMulti( hitgroup )

	if( hitgroup == HITGROUP_HEAD ) then
		return math.Rand( 10.0, 25.0 ); -- headshots should always do lots of damage
	elseif( hitgroup == HITGROUP_CHEST ) then
		return math.Rand( 1.3, 1.7 );
	elseif( hitgroup == HITGROUP_STOMACH ) then
		return math.Rand( 0.9, 1.1 );
	elseif( hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM ) then
		return math.Rand( 0.3, 0.45 );
	elseif( hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG ) then
		return math.Rand( 0.05, 0.08 );
	end
	
	return 1.0;
	
end
