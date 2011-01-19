
include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	local min, max = self:WorldSpaceAABB();
	self.Min = min;
	self.Max = max;
	
end

function ENT:AcceptInput( name, activator, caller, data )
	
	if( name == "Trigger" ) then
		
		local enttab = ents.FindInBox( self.Min, self.Max );
		
		timer.Simple( 3, function()
			
			for _, v in pairs( enttab ) do
				
				if( v and v:IsValid() ) then
					
					if( ( v:IsPlayer() and v:Alive() ) or v:GetClass() == "cube_boot" ) then
						
						v:EmitSound( Sound( "ambient/fire/ignite.wav" ) );
						v:Ignite( 7, 0 );
						
					end
					
				end
				
			end
			
		end );
		
		timer.Simple( 9.9, function() -- hurry up and die
			
			for _, v in pairs( enttab ) do
				
				if( v and v:IsValid() ) then
					
					if( v:IsPlayer() and v:Alive() ) then
						
						v:TakeDamage( 200, self, self );
						
					end
					
				end
				
			end
			
		end );
		
	end
	
end
