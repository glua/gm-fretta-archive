
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
					
					if( v:GetClass() == "cube_boot" or ( v:IsPlayer() and v:Alive() ) ) then
						
						v:EmitSound( Sound( "cube/icecrack.wav" ) );
						v:SetColor( 79, 234, 255, 255 );
						
					end
					
					if( v:IsPlayer() and v:Alive() ) then
						
						v:Freeze( true );
						umsg.Start( "FrozenOverlayOn", v ); umsg.End();
						v:GetActiveWeapon():SetColor( 79, 234, 255, 255 );
						
					end
					
				end
				
			end
			
		end );
		
		timer.Simple( 9.9, function() -- hurry up and die
			
			for _, v in pairs( enttab ) do
				
				if( v and v:IsValid() ) then
					
					if( v:GetClass() == "cube_boot" or ( v:IsPlayer() and v:Alive() ) ) then
						
						v:EmitSound( Sound( "physics/glass/glass_sheet_break" .. math.random( 1, 3 ) .. ".wav" ) );
						v:SetColor( 255, 255, 255, 255 );
						
					end
					
					if( v:IsPlayer() and v:Alive() ) then
						
						v:Freeze( false );
						v:GetActiveWeapon():SetColor( 255, 255, 255, 255 );
						v:TakeDamage( 200, self, self );
						umsg.Start( "FrozenOverlayOff", v ); umsg.End();
						
					elseif( v:GetClass() == "cube_boot" ) then
						
						v:Remove();
						
					end
					
				end
				
			end
			
		end );
		
	end
	
end
