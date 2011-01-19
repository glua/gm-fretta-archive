
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:SetDeathCamTarget( ent )
	
	self:SetNWEntity( "TargetEnt", ent )
	
end

function meta:SetPlayerFOV( fov, time )

	if self:GetFOV() >= 75 and fov == 0 then return end

	self:SetFOV( fov, time )

end

function meta:SpawnArmor( time )

	self:GodEnable( true )
	
	local col = team.GetColor( self:Team() )
	self:SetColor( col.r, col.g, col.b, 150 )
	
	local func = function( ply )
		if not ply:IsValid() or not ply:Alive() then return end
		ply:SetColor( 255, 255, 255, 255 )
		ply:GodDisable()
	end
	
	timer.Simple( time, func, self )
	
end

function meta:Cloak( b )

	if self:GetNWBool( "Cloaked", false ) == b then return end
	
	if b and self.LastCloak and self.LastCloak > CurTime() then return end

	self.LastCloak = CurTime() + 3
	self:SetNWBool( "Cloaked", b )

	if b then
	
		self:SetMaterial( "sprites/heatwave" )
		self:DrawShadow( false )
		self:DrawWorldModel( false )
		self:SetColor( 0, 0, 0, 10 )
		self:EmitSound( Sound( "npc/combine_gunship/gunship_ping_search.wav" ) )
		
	else
	
		self:SetMaterial( "" )
		self:DrawShadow( true )
		self:DrawWorldModel( true )
		self:SetColor( 255, 255, 255, 255 )
		self:EmitSound( Sound( "npc/combine_gunship/ping_search.wav" ) )
		
	end
	
end