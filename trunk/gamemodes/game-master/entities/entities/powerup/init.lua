
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()

	self.Entity:SetModel( powerups[self:GetPowerup()].model )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	
end

function ENT:KeyValue( key, value )

	if ( key == "powerup" ) then //If there's a powerup key...
		
		local pw = 0
		for k, v in pairs( powerups ) do //Find the name in the table
			if ( value == v.name ) then pw = k break end
		end
		
		if ( pw > 0 ) then
			self:SetPowerup( pw ) //Set the powerup 
		end
		
	end
	
end

function ENT:Think()

	local close_ents = ents.FindInSphere( self.Entity:GetPos(), POWERUP_RADIUS )
	
	for _, v in ipairs( close_ents ) do
		if ( v:IsPlayer() and v:Team() == TEAM_RUNNER and v:Alive() ) then
			if ( powerups[self:GetPowerup()].func( v ) ) then return end //Function from the powerup table
			self.Entity:EmitSound( "buttons/button18.wav", 0.27, 100 )
			self:EmitEffect()
			break
		end
	end

end

function ENT:EmitEffect()
	
	local efdata = EffectData()
	efdata:SetOrigin( self.Entity:GetPos() )
	efdata:SetStart( col2vec( powerups[self:GetPowerup()].color ) )
	util.Effect( "powerup_grab", efdata )
	
	self.Entity:Remove()
	
end