 	
ENT.Type 		= "brush"

AddCSLuaFile( "shared.lua" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

end

/*---------------------------------------------------------
   Name: StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( ent )

	if ent:GetClass() == "prop_physics" then
		self:AddScore( ent )
	end
	
	if ent:GetClass() == "info_prop" then
		ent:Remove()
	end

end

/*---------------------------------------------------------
   Name: EndTouch
---------------------------------------------------------*/
function ENT:EndTouch( ent )

	if ent:GetClass() == "prop_physics" then
		self:RemoveScore( ent )
	end
	
end

function ENT:AddScore( ent )
	
	if !ent or !ent:IsValid() then return end
	
	for k,v in pairs ( ents.FindInSphere( ent:GetPos(), 16 ) ) do
		if v:GetClass() == "info_prop" then
			v:Remove()
			ent:SetModel( "models/props_c17/oildrum001_explosive.mdl" ) -- This prevents score from being taken
			ent:Remove()
			return
		end
	end
	
	local model = ent:GetModel()
	
	if table.HasValue( GAMEMODE.PropModels, model ) then
		team.AddScore( TEAM_BLUE, 1 )
		
		if ( team.GetScore( TEAM_BLUE ) - 1 <= team.GetScore( TEAM_YELLOW ) ) &&( team.GetScore( TEAM_BLUE ) > team.GetScore( TEAM_YELLOW ) ) then
			GAMEMODE:BlueTakesLead()
		end
		
		if ( ent:GetNWEntity( "L_Affector" ) and ent:GetNWEntity( "L_Affector" ):IsPlayer() ) then
			if ent:GetNWEntity( "L_Affector" ):Team() == TEAM_BLUE then
				ent:GetNWEntity( "L_Affector" ):AddDeliveries( 1 )
			elseif ent:GetNWEntity( "L_Affector" ):Team() == TEAM_YELLOW then
				ent:GetNWEntity( "L_Affector" ):AddSteals( -1 )
			end
		end
	elseif table.HasValue( GAMEMODE.LargeModels, model ) then
		team.AddScore( TEAM_BLUE, 2 )
		
		if ( team.GetScore( TEAM_BLUE ) - 2 <= team.GetScore( TEAM_YELLOW ) ) &&( team.GetScore( TEAM_BLUE ) > team.GetScore( TEAM_YELLOW ) ) then
			GAMEMODE:BlueTakesLead()
		end
		
		if ( ent:GetNWEntity( "L_Affector" ) and ent:GetNWEntity( "L_Affector" ):IsPlayer() ) then
			if ent:GetNWEntity( "L_Affector" ):Team() == TEAM_BLUE then
				ent:GetNWEntity( "L_Affector" ):AddDeliveries( 2 )
			elseif ent:GetNWEntity( "L_Affector" ):Team() == TEAM_YELLOW then
				ent:GetNWEntity( "L_Affector" ):AddSteals( -2 )
			end
		end
	end
	
	local boosh = EffectData()
	boosh:SetOrigin( ent:GetPos() )
	boosh:SetScale( 1 )
	util.Effect( "blue_point", boosh )
	
end


function ENT:RemoveScore( ent )

	if !ent or !ent:IsValid() then return end
	
	local model = ent:GetModel()
	
	if table.HasValue( GAMEMODE.PropModels, model ) then
		team.AddScore( TEAM_BLUE, -1 )
		
		if ( team.GetScore( TEAM_BLUE ) + 1 > team.GetScore( TEAM_YELLOW ) ) &&( team.GetScore( TEAM_BLUE ) <= team.GetScore( TEAM_YELLOW ) ) then
			GAMEMODE:GameTied()
		end
		
		if ( ent:GetNWEntity( "L_Affector" ) and ent:GetNWEntity( "L_Affector" ):IsPlayer() ) then
			if ent:GetNWEntity( "L_Affector" ):Team() == TEAM_BLUE then
				ent:GetNWEntity( "L_Affector" ):AddDeliveries( -1 )
			elseif ent:GetNWEntity( "L_Affector" ):Team() == TEAM_YELLOW then
				ent:GetNWEntity( "L_Affector" ):AddSteals( 1 )
			end
		end
	elseif table.HasValue( GAMEMODE.LargeModels, model ) then
		team.AddScore( TEAM_BLUE, -2 )
		
		if ( team.GetScore( TEAM_BLUE ) + 2 > team.GetScore( TEAM_YELLOW ) ) &&( team.GetScore( TEAM_BLUE ) <= team.GetScore( TEAM_YELLOW ) ) then
			GAMEMODE:GameTied()
		end
		
		if ( ent:GetNWEntity( "L_Affector" ) and ent:GetNWEntity( "L_Affector" ):IsPlayer() ) then
			if ent:GetNWEntity( "L_Affector" ):Team() == TEAM_BLUE then
				ent:GetNWEntity( "L_Affector" ):AddDeliveries( -2 )
			elseif ent:GetNWEntity( "L_Affector" ):Team() == TEAM_YELLOW then
				ent:GetNWEntity( "L_Affector" ):AddSteals( 2 )
			end
		end
	end
	
	local boosh = EffectData()
	boosh:SetOrigin( ent:GetPos() )
	boosh:SetScale( 1 )
	util.Effect( "blue_point", boosh )
	
end
