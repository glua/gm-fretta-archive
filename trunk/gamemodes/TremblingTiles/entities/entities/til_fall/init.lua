include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

ENT.FallSounds = {
	"whoops01",
	"uhoh",
	"startle01",
	"startle02",
	"ohno",
	"no01",
	"no02",
	"help01",
	"goodgod",
	"fantastic01",
	"fantastic02",
	"cit_dropper04",
}

function ENT:Initialize()
	
	self:PhysicsInit( SOLID_NONE );
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_NONE );
	
	local min, max = self:WorldSpaceAABB();
	self.Pos = ( min + max ) / 2; -- Brush entities have...issues...
	self.Min = min;
	self.Max = max;
	
end

function ENT:Think()
	
	local enttab = ents.FindInBox( self.Min, self.Max );
	
	for _, v in pairs( player.GetAll() ) do
		
		if( table.HasValue( enttab, v ) and v:Alive() ) then
			
			if( v.SecondChance ) then
				
				v.SecondChance = false;
				
				local enttab = ents.GetAllAliveTiles();
				
				if( #enttab > 0 ) then
					
					local ent = table.Random( enttab );
					v:SetPos( ent.Pos + Vector( 0, 0, 32 ) );
					
				end
				
			elseif( v:Team() != TEAM_SPECTATOR ) then
				
				if( table.HasValue( FemalePlayermodels, v:GetModel() ) ) then
					
					v:EmitSound( Sound( "vo/npc/female01/" .. table.Random( self.FallSounds ) .. ".wav" ) );
					
				else
					
					v:EmitSound( Sound( "vo/npc/male01/" .. table.Random( self.FallSounds ) .. ".wav" ) );
					
				end
				
				v:Kill();
				
			end
			
		end
		
	end
	
	self:NextThink( CurTime() + 0.6 );
	return true;
	
end
