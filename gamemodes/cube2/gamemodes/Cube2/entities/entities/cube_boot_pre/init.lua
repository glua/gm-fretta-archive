include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	self:SetModel( "models/props_junk/shoe001a.mdl" );
	
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER );
	
	local phy = self:GetPhysicsObject();
	if( phy and phy:IsValid() ) then
		phy:Wake();
	end
	
end

function ENT:Think()
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:Alive() and v:Team() != TEAM_SPECTATOR ) then
			
			if( v:GetPos():Distance( self:GetPos() ) < 32 ) then
				
				self:Pickup( v );
				
			end
			
		end
		
	end
	
	self:NextThink( CurTime() + 0.2 );
	
end

function ENT:Pickup( ent )
	
	if( ent:IsPlayer() ) then
		
		ent:EmitSound( Sound( "items/ammo_pickup.wav" ) );
		ent.Boots = ent.Boots + 1;
		umsg.Start( "UpBootCounter", ent ); umsg.End();
		self:Remove();
		
	end
	
end
