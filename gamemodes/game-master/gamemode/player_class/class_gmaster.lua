
local CLASS = {}

CLASS.DisplayName			= "Gamemaster"
CLASS.DrawViewModel			= false
CLASS.CanUseFlashlight      = false
CLASS.PlayerModel			= "models/blackout.mdl" //Invisible model

local movespeed = 8
local moveup = Vector( 0, 0, movespeed )
local moveright = Vector( movespeed, 0, 0 )
local moveup2 = Vector( 0, 0, movespeed * 2 )
local moveright2 = Vector( movespeed * 2, 0, 0 )

function CLASS:Loadout( pl )
end

function CLASS:OnSpawn( pl )

	pl:CrosshairDisable()
	pl:SetMoveType( MOVETYPE_NOCLIP )
	pl:SetSolid( SOLID_NONE )
	pl:SetNoTarget( true )
	
	for k, v in pairs( partlist ) do
		pl:SetNWInt( k .. "Part", math.max( 0, v.amount + math.random( -2, 2 ) + math.Round( ( #team.GetPlayers( TEAM_RUNNER ) - 5 ) / 5 ) ) ) //Give him all the parts he needs!
	end

end

function CLASS:OnDeath( pl, attacker, dmginfo )
end

function CLASS:Think( pl )
end

function CLASS:Move( pl, mv )
	
	if ( pl:KeyDown( IN_SPEED ) ) then
		if ( pl:KeyDown( IN_FORWARD ) ) then mv:SetOrigin( mv:GetOrigin() + moveup2 ) end
		if ( pl:KeyDown( IN_BACK ) ) then mv:SetOrigin( mv:GetOrigin() - moveup2 ) end
		if ( pl:KeyDown( IN_MOVELEFT ) ) then mv:SetOrigin( mv:GetOrigin() - moveright2 ) end
		if ( pl:KeyDown( IN_MOVERIGHT ) ) then mv:SetOrigin( mv:GetOrigin() + moveright2 ) end
	else
		if ( pl:KeyDown( IN_FORWARD ) ) then mv:SetOrigin( mv:GetOrigin() + moveup ) end
		if ( pl:KeyDown( IN_BACK ) ) then mv:SetOrigin( mv:GetOrigin() - moveup ) end
		if ( pl:KeyDown( IN_MOVELEFT ) ) then mv:SetOrigin( mv:GetOrigin() - moveright ) end
		if ( pl:KeyDown( IN_MOVERIGHT ) ) then mv:SetOrigin( mv:GetOrigin() + moveright ) end
	end
	
	return true //Don't use default movement!
	
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

function CLASS:CalcView( ply, origin, angles, fov )
end

player_class.Register( "Gamemaster", CLASS )