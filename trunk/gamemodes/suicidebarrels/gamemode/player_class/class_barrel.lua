local CLASS = {}

CLASS.DisplayName			= "Barrel"
CLASS.WalkSpeed 			= 200
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 100
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 0
CLASS.DrawTeamRing			= true
CLASS.PlayerModel			= "models/props_c17/oildrum001_explosive.mdl"
CLASS.MaxHealth				= 1
CLASS.StartHealth			= 1
CLASS.StartArmor			= 0
CLASS.DisableFootsteps		= true
CLASS.DrawTeamRing			= false

function CLASS:Loadout( pl )
	
end

function CLASS:OnSpawn( pl )

	pl.NextTaunt = CurTime() + 1;
	pl.CanExplodeAfter = CurTime() + 1;
	
	pl:StripWeapons()
	pl:SetViewOffset( Vector( 0, 0, 42 ) )

end

function CLASS:OnDeath( pl )

	local boom = ents.Create( "env_explosion" )
	boom:SetPos( pl:GetPos() ) 
	boom:SetOwner( pl )
	boom:Spawn()
	boom:SetKeyValue( "iMagnitude", "150" ) 
	boom:Fire( "Explode", 0, 0 ) 
	
end

function CLASS:OnKeyPress( pl, key )

	if !pl:Alive() then return end
	
	if( key == IN_ATTACK and pl.CanExplodeAfter and CurTime() >= pl.CanExplodeAfter ) then
	
		pl.CanExplode = false
		pl:EmitSound( "Grenade.Blip" )
		
		timer.Simple( .5, function() if ValidEntity( pl ) and pl:Alive() then pl:EmitSound( "Grenade.Blip" ) end end )
		timer.Simple( 1, function() if ValidEntity( pl ) and pl:Alive() then pl:EmitSound( "Grenade.Blip" ) end end )
		timer.Simple( 1.5, function() if ValidEntity( pl ) and pl:Alive() then pl:EmitSound( "Weapon_CombineGuard.Special1" ) end end )
		timer.Simple( 2, function() if ValidEntity( pl ) and pl:Alive() then pl:Kill() end end )
		
		pl.CanExplodeAfter = CurTime() + 2.5
		
	end
 
	if( key == IN_ATTACK2 and pl.NextTaunt and CurTime() >= pl.NextTaunt ) then
		pl:EmitSound( table.Random( TAUNTS ), 100, 140 )
		pl.NextTaunt = CurTime() + 2
	end
		
end

player_class.Register( "Barrel", CLASS )