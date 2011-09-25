
local CLASS = {}

CLASS.DisplayName			= "Default Class"
CLASS.WalkSpeed 			= 300
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 500
CLASS.DuckSpeed				= 0.4
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= true

function CLASS:Loadout( pl )

	pl:Give( "weapon_laserdance" )
	
end

function CLASS:OnSpawn( pl )

	if ( IsValid( pl.m_entTrail ) ) then
		pl.m_entTrail:Remove()
	end
	
	//local AttachmentID = pl:LookupAttachment( "chest" )
	//if ( AttachmentID <= 0 ) then AttachmentID = pl:LookupAttachment( "hips" ) end
	//if ( AttachmentID <= 0 ) then AttachmentID = 0 end
	
	local AttachmentID = 0
	
	local col = team.GetColor( pl:Team() )
	
	pl.m_entTrail = util.SpriteTrail( pl, AttachmentID, col, true, 48, 4, 10, 0, "trails/plasma.vmt" )
	pl.m_entTrail:SetParent( pl )

end

player_class.Register( "Default", CLASS )