function DoRandomTileFall()
	
	local tiles = ents.GetAllAliveTiles();
	
	if( #tiles > 0 ) then
		
		local ent = table.Random( tiles );
		
		ent:EmitSound( table.Random( ent.ActivateSounds ), 66, math.random( 70, 130 ) );
		ent:SetColor( 255, 0, 0, 255 );
		ent.Dropped = true;
		
		timer.Simple( 1, function()
			
			ent:EmitSound( table.Random( ent.FallSounds ), 33, math.random( 70, 130 ) );
			ent:Drop();
			
		end );
		
	end
	
end

function ents.GetAllAliveTiles()
	
	local tab = { };
	
	for _, v in pairs( ents.FindByClass( "til_tile" ) ) do
		
		if( !v.Dropped ) then
			
			table.insert( tab, v );
			
		end
		
	end
	
	return tab;
	
end
