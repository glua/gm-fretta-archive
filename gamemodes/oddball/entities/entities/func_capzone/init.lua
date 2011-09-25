ENT.Type = "brush"
ENT.Team = nil

function ENT:KeyValue( key, value )
	if ( key == "Team" ) then
		self:SetTeam(value)
	end
end

function ENT:Touch( ent )
end

function ENT:StartTouch( ent ) --Can be buggy if the player spawns INSIDE the zone, but you don't really need to worry about that because the player will always be coming from an objective.
	if ( ent:IsPlayer() and ent:Alive() and ent:Team() == self:GetTeam() and ent:GetNWBool("HasArtifact",false) == true ) then

		--Do Shit for capping the "artifact".. for example.. call to the gamemode? GAMEMODE:CaptureArtifact(ply)

		ent:SetNWBool("InCapZone", true) --For a hud or somthing?
	end
end

function ENT:EndTouch( ent )
	if(ent:IsPlayer()) then
		ent:SetNWBool("InCapZone", false) --For a hud or somthing?
	end
end

function ENT:SetTeam(shit)
	self.Team = shit
end
function ENT:GetTeam()
	return self.Mode
end