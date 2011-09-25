include( "shared.lua" );

ENT.LastDLight = 0
local smGlo = Material("sprites/light_glow02_add")

function ENT:Draw()

	-- effects from instagib ctf by capsadmin and zpankt
	if( self:GetNetworkedBool( "stolen", false ) == false ) then
		
		local inval = 4 - CurTime()
		local speed = 2
		local scale = 1
		local divider = 5
		
		self.Entity:SetModelScale(Vector( math.sin( inval * speed )  / divider + scale, math.sin( inval * speed )  / divider + scale, math.sin( inval * speed )  / divider + scale))
		self.Entity:SetAngles(Angle(0,CurTime() * 3 ,0))
		
		local cPos = self.Entity:GetPos()
		local pSin = math.sin(CurTime() * 3)
		render.SetMaterial(smGlo)
		render.DrawSprite( cPos,150 + pSin * 10,150 + pSin * 10, self:GetColor() )
	end
	
	self:DrawModel()
end

function ENT:DrawHUD()

	local ownerTeam = self:GetNetworkedInt( "team", 1 );
	local localPlayer = LocalPlayer();
	local localTeam = LocalPlayer():Team();
	
	local screenpos = self:GetPos():ToScreen();
	local carrier = self:GetNetworkedEntity( "carrier" );
	local dropped = self:GetNetworkedBool( "dropped", false );
	local stolen = self:GetNetworkedBool( "stolen", false );
			
	if( LocalPlayer():IsObserver() and IsValid( LocalPlayer():GetObserverTarget() ) and LocalPlayer():GetObserverTarget():IsPlayer() and LocalPlayer():GetObserverTarget() != LocalPlayer() ) then // you see the flag positions through the spectator's eyes
		localPlayer = LocalPlayer():GetObserverTarget();
		localTeam = LocalPlayer():GetObserverTarget():Team();
	end
	
	if( localTeam != ownerTeam ) then // not ours
		if( dropped ) then
			
			local dropped_flag = GetGlobalEntity( "droppedflag_" .. tostring( self:GetNetworkedInt( "team" ) ) );
				
			if( dropped_flag and dropped_flag:IsValid() ) then
				screenpos = ( dropped_flag:GetPos() ):ToScreen();
			end
				
		elseif( stolen and carrier and carrier:IsValid() ) then
			screenpos = ( carrier:GetPos() + Vector( 0, 0, 76 ) ):ToScreen();
				
			if( carrier == localPlayer ) then
				screenpos.x = 20 + 18 * screenScale
				screenpos.y = ScrH()-45 - (10+screenScale);
				screenpos.visible = true;
					
				GAMEMODE:SimpleTextShadow( "Carrying enemy flag", "TrebBoldLarge", screenpos.x + 36 * screenScale, ScrH()-45 - (73+screenScale), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			end
		end
	else // assume it's ours
		if( dropped ) then
			local dropped_flag = GetGlobalEntity( "droppedflag_" .. tostring( self:GetNetworkedInt( "team" ) ) );
					
			if( dropped_flag and dropped_flag:IsValid() ) then
				screenpos = ( dropped_flag:GetPos() ):ToScreen();
			end
		end
	end
	
	if( screenpos.visible ) then
		local team_col = self:GetTeamColor();
			
		draw.RoundedBox( 2, screenpos.x - 18 * screenScale, screenpos.y - 66 * screenScale, 36 * screenScale, 36 * screenScale, Color( 0, 0, 0, 150 ) );

		surface.SetDrawColor( team_col.r, team_col.g, team_col.b, 100 );
		surface.DrawRect( screenpos.x - 16 * screenScale, screenpos.y - 64 * screenScale, 32 * screenScale, 32 * screenScale );	
			
		if( localTeam != ownerTeam && dropped ) then
			local countdown = self:GetNetworkedFloat( "returntime" ) - CurTime();
			GAMEMODE:SimpleTextShadow( tostring( math.Round( math.Clamp( countdown, 0, 30 ) ) ), "TrebBoldLarge", screenpos.x, screenpos.y - 48 * screenScale, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif( stolen and !dropped ) then
			GAMEMODE:SimpleTextShadow( "X", "TrebBoldLarge", screenpos.x, screenpos.y - 48 * screenScale, Color( 150, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
		end
	end
	
end

function ENT:GetColor()
	return team.GetColor( self:GetNetworkedInt( "team", 1 ) );
end

function ENT:GetTeamColor()
	return team.GetColor( self:GetNetworkedInt( "team", 1 ) );
end

function ENT:Think()

	if( self:GetNetworkedBool( "stolen", false ) == false ) then
		local teamNo = self:GetNetworkedInt( "team", 1 );
		
		if( teamNo > 0 and CurTime() > self.LastDLight + 0.9 ) then
			
			local dlight = DynamicLight( self:EntIndex() )

			if ( dlight ) then
			
				local teamColor = team.GetColor( teamNo );
				
				dlight.Pos = self:GetPos();
				
				dlight.r = teamColor.r;
				dlight.g = teamColor.g;
				dlight.b = teamColor.b;
				
				dlight.Brightness = 6;
				dlight.Size = 100;
				dlight.DieTime = CurTime() + 1
				
				self.LastDLight = CurTime();
			
			end 
		end
	end
	
end
