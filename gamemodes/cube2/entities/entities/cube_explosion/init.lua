--This ent is for reusable env_explosions

include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	self.Pos = self:GetPos();
	
end

function ENT:AcceptInput( name, activator, caller, data )
	
	if( name == "Explode" ) then
		
		local exp = ents.Create( "env_explosion" );
		exp:SetPos( self.Pos );
		exp:SetKeyValue( "iMagnitude", 1000 );
		exp:Spawn();
		exp:Activate();
		exp:Fire( "Explode", "", 0 );
		
	end
	
end
