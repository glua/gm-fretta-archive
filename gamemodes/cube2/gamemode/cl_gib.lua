StartFlashEffect = 0;

local function msgResetRagBone( um )
	
	local ent = um:ReadEntity();
	
	function ent.BuildBonePositions( entity )
		
		local matrix = entity:GetBoneMatrix( 6 ); -- dummy
		matrix:Scale( Vector( 1, 1, 1 ) );
		entity:SetBoneMatrix( 6, matrix );
		
	end
	
end
usermessage.Hook( "msgResetRagBone", msgResetRagBone );

local function msgRemoveRagBone( um )
	
	local bone = um:ReadShort();
	local ent = um:ReadEntity();
	
	function ent.BuildBonePositions( entity )
		
		local matrix = entity:GetBoneMatrix( bone );
		matrix:Scale( Vector( 0, 0, 0 ) );
		entity:SetBoneMatrix( bone, matrix );
		
	end
	
end
usermessage.Hook( "msgRemoveRagBone", msgRemoveRagBone );

local function msgRemoveRagBones( um )
	
	local ent = um:ReadEntity();
	local amt = um:ReadShort();
	local funcTab = { };
	
	for _ = 1, amt do
		
		local bone = um:ReadShort();
		
		local function boned()
			
			local matrix = ent:GetBoneMatrix( bone );
			matrix:Scale( Vector( 0, 0, 0 ) );
			ent:SetBoneMatrix( bone, matrix );
			
		end
		table.insert( funcTab, boned );
		
	end
	
	function ent.BuildBonePositions( entity )
		
		for _, v in pairs( funcTab ) do
			
			v();
			
		end
		
	end
	
end
usermessage.Hook( "msgRemoveRagBones", msgRemoveRagBones );

local function msgDecapFX( um )
	
	local effectdata = EffectData();
	effectdata:SetOrigin( um:ReadVector() );
	
	for _ = 1, 4 do
		
		util.Effect( "BloodImpact", effectdata );
		
	end
	
end
usermessage.Hook( "msgDecapFX", msgDecapFX );

local function msgGibFX( um )
	
	local root = um:ReadVector();
	
	for i = 1, 6 do
		
		local effectdata = EffectData();
		effectdata:SetOrigin( um:ReadVector() + Vector( 0, 0, 12 * i ) );
		
		for _ = 1, 4 do
			
			util.Effect( "BloodImpact", effectdata );
			
		end
		
	end
	
end
usermessage.Hook( "msgGibFX", msgGibFX );

local function msgGibDrops( um )
	
	local ent = um:ReadShort();
	
	local ed = EffectData();
	ed:SetMagnitude( ent );
	util.Effect( "cube_gib_blood", ed );
	
end
usermessage.Hook( "msgGibDrops", msgGibDrops );

local function drawIce()
	
	local t = FrozenOverlay;
	
	if( t ) then
		
		DrawMaterialOverlay( "cube/ice_overlay.vmt", 0.1 );
		
	end
	
end
hook.Add( "RenderScreenspaceEffects", "drawIce", drawIce );

local function flashFlameRender()
	
	if( not LocalPlayer():Alive() ) then return end
	if( CurTime() < 10 ) then return end
	
	local timeSince = CurTime() - StartFlashEffect;
	local mul = 0;
	
	if( timeSince >= 0 and timeSince < 3 ) then
		
		mul = timeSince / 3;
		
	elseif( timeSince >= 3 and timeSince < 10 ) then
		
		mul = 1;
		
	end
	
	local tab = {}
	tab[ "$pp_colour_addr" ] = 0;
	tab[ "$pp_colour_addg" ] = 0;
	tab[ "$pp_colour_addb" ] = 0;
	tab[ "$pp_colour_brightness" ] = 0;
	tab[ "$pp_colour_contrast" ] = ( mul * 2 ) + 1;
	tab[ "$pp_colour_colour" ] = 1;
	tab[ "$pp_colour_mulr" ] = 0;
	tab[ "$pp_colour_mulg" ] = 0;
    tab[ "$pp_colour_mulb" ] = 0;
	
    DrawColorModify( tab );
	
end
hook.Add( "RenderScreenspaceEffects", "flashFlameRender", flashFlameRender );