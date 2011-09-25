ENT.Type = "point"

function ENT:Initialize()

	self.Team = self.Entity:GetTeam()
	self.X = self.Entity:GetPos().x

	local ent = ents.Create( "ctf_flag" )
	ent:SetTeam( self.Team )
	ent:SetSpawn( self.Entity:GetPos() )
	ent:SetPos( self.Entity:GetPos() )
	ent:SetX( self.X )
	ent:Spawn()
	ent:PositionFlag()
	
end

function ENT:GetTeam()

	local dist = 90000
	local flagteam = TEAM_RED

	for k,v in pairs( ents.FindByClass( "info_player*" ) ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < dist then
		
			dist = v:GetPos():Distance( self.Entity:GetPos() )
		
			if v:GetClass() == "info_player_terrorist" then
			
				flagteam = TEAM_RED
			
			else
			
				flagteam = TEAM_BLUE
			
			end
		
		end
	
	end

	return flagteam
	
end

function ENT:FlagHome()

	for k,v in pairs( ents.FindByClass( "ctf_flag" ) ) do
	
		if v:GetTeam() == self.Team and v:GetPos():Distance( self.Entity:GetPos() ) < 50 then
		
			return true
		
		end
	
	end
	
	return false

end

function ENT:GetFlagPos()

	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector( 0, 0, -500 )
	
	local tr = util.TraceLine( trace )
	
	return tr.HitPos + Vector( 0, 0, 50 )

end

function ENT:Think()

	if not self.Entity:FlagHome() then return end

	for k,v in pairs( ents.FindByClass( "ctf_flag" ) ) do
	
		if v:GetTeam() != self.Team and v:GetPos():Distance( self.Entity:GetPos() ) < 50 then
		
			local ed = EffectData()
			ed:SetOrigin( self.Entity:GetFlagPos() )
			ed:SetScale( self.Team )
			util.Effect( "flag_score", ed, true, true )
			
			v:Score( self.Team )
		
		end
	
	end

end
