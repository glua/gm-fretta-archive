local meta = FindMetaTable( "Player" )
if (!meta) then return end 

meta.OldMsg = meta.PrintMessage;


function meta:GetCustomAmmo( name )			return self:GetNWInt( "ammo_" .. name, 0 ) end
function meta:SetCustomAmmo( name, num )	return self:SetNWInt( "ammo_" .. name, num ) end
function meta:TakeCustomAmmo( name, num )	return self:SetCustomAmmo( name, self:GetCustomAmmo( name ) - num ) end
function meta:AddCustomAmmo( name, num )	return self:SetCustomAmmo( name, self:GetCustomAmmo( name ) + num ) end


function meta:Recoil( pitch, yaw )

	// On the client it can sometimes process the same usercmd twice
	// This function returns true if it's the first time we're doing this usercmd
	if ( !SinglePlayer() && !IsFirstTimePredicted() && SERVER ) then return end

	// People shouldn't really be playing in SP
	// But if they are they won't get recoil because the weapons aren't predicted
	// So the clientside stuff never fires the recoil
	if ( SERVER && SinglePlayer() ) then 
	
		// Please don't call SendLua in multiplayer games. This uses a lot of bandwidth
		self:SendLua( "LocalPlayer():Recoil("..pitch..","..yaw..")" )
		return 
		
	end
	
	self.LastShoot = 0.5
	self.LastShootSize = math.abs(yaw) + math.abs(pitch)
	
	self.RecoilYaw = self.RecoilYaw or 0
	self.RecoilPitch = self.RecoilPitch or 0
	
	self.RecoilYaw = self.RecoilYaw 		+ yaw
	self.RecoilPitch = self.RecoilPitch 	+ pitch

end

function meta:PrintMessage( typem, message )
	
	if( typem == HUD_PRINTCENTER and SERVER ) then -- override PRINTCENTER behaviour
		
		-- add our player
		local rp = RecipientFilter();
		rp:AddPlayer( self );
			
		-- send our user message
		umsg.Start( "gmdm_printcenter", rp );
		umsg.String( message );
		umsg.End();
		
	elseif( typem == HUD_PRINTCENTER and CLIENT ) then
		GAMEMODE:AddCenterMessage( message );
	else
		self:OldMsg( typem, message );
	end
	
end

meta.LastDLight = 0;
function meta:TeamDynamicLight( teama )
	
	local teamNo = self:Team();
	
	if( teama ) then
		teamNo = teama;
	end
	
	if( teamNo > 0 and CurTime() > self.LastDLight + 0.01 ) then
			
		local dlight = DynamicLight( self:EntIndex() )

		if ( dlight ) then
			
			local teamColor = team.GetColor( teamNo );
				
			dlight.Pos = self:GetPos() + Vector( 0, 0, 12 );
				
			dlight.r = teamColor.r;
			dlight.g = teamColor.g;
			dlight.b = teamColor.b;
			
			dlight.Brightness = 5;
			dlight.Size = 300;
			dlight.DieTime = CurTime() + 0.0011
				
			self.LastDLight = CurTime();
		
		end 
	end
	
end

function meta:Think()

end