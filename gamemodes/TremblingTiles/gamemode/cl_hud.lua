function GM:HUDShouldDraw( name )
	
	local nodraw = {
		
		"CHudHealth",
		"CHudSecondaryAmmo",
		"CHudAmmo",
		"CHudBattery",
		"CHudWeaponSelection"
		
	}
	
	for _, v in pairs( nodraw ) do
	
		if( v == name ) then 
		
			return false;
			
		end
	
	end
	
	return true;

end

local RenderPowerupTab = { };

local function msgSyncRenderPowerup( um )
	
	local indx = um:ReadShort();
	local dura = um:ReadShort();
	local ent = um:ReadEntity();
	
	table.insert( RenderPowerupTab, { indx, CurTime() + dura, ent } );
	
end
usermessage.Hook( "msgSyncRenderPowerup", msgSyncRenderPowerup );

local function msgResetRenderPowerup( um )
	
	RenderPowerupTab = { };
	
end
usermessage.Hook( "msgResetRenderPowerup", msgResetRenderPowerup );

function GM:PostDrawOpaqueRenderables()
	
	render.SetStencilEnable( true );
	
	for k, v in pairs( RenderPowerupTab ) do
		
		if( CurTime() > v[2] ) then
			
			table.remove( RenderPowerupTab, k );
			break;
			
		end
		
		if( matRenderTranslateTab[ v[1] ] == matBlack ) then
			
			break;
			
		end
		
		render.ClearStencil();

		render.SetStencilFailOperation( STENCILOPERATION_INCR );
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP );
		render.SetStencilPassOperation( STENCILOPERATION_KEEP );
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER );
		render.SetStencilReferenceValue( 1 );

		if( v[3] and v[3]:IsValid() and v[3]:Alive() ) then
			
			v[3]:SetModelScale( Vector( 1.1, 1.1, 1.01 ) );
			v[3]:DrawModel();
			v[3]:SetModelScale( Vector( 1, 1, 1 ) );
			
		end

		render.SetStencilReferenceValue( 2 );

		v[3]:DrawModel();

		render.SetStencilReferenceValue( 1 );
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL );
		render.SetMaterial( matRenderTranslateTab[ v[1] ] );
		render.DrawScreenQuad();
		
	end

	render.SetStencilEnable( false )
	
end

function GM:HUDWeaponPickedUp( wep ) end