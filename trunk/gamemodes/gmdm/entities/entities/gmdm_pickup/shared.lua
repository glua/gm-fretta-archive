ENT.Type = "anim"
ENT.PickupInfo = {};
					
function ENT:SetActiveTime( t )
	self.Entity:SetNetworkedFloat( 0, t )
end


function ENT:GetActiveTime()
	return self.Entity:GetNetworkedFloat( 0 )
end

function ENT:GetPickupType()
	return self.Entity:GetNetworkedInt( "pickup" )
end

function ENT:SetPickupType( name )

	local pid, pickupinfo = pickup:GetPickupByName( name );
	
	if( pickupinfo ) then
		self.Entity:SetNetworkedInt( "pickup", pid )
		self.Entity:SetModel( pickupinfo.model );
		self.PickupInfo = pickupinfo;
		return;
	end
	
	Msg("Error: gmdm_pickup - unhandled pickup type "..name.."\n" )
	self.Entity:Remove() --surely?

end


function ENT:GetPickupName()
	if( SERVER ) then
		return self.PickupInfo.name
	else
		return pickup:GetPickupByIndex( self:GetPickupType() ).name
	end
end



function ENT:GetNiceName()
	if( SERVER ) then
		return self.PickupInfo.nicename
	else
		return pickup:GetPickupByIndex( self:GetPickupType() ).nicename
	end
end

function ENT:DoAmmoGive( ply )

	if ( self.PickupInfo.customammo ) then
		
		ply:AddCustomAmmo( self.PickupInfo.customammo, self.PickupInfo.ammoamount )
		return 
		
	end

	ply:GiveAmmo( self.PickupInfo.ammoamount, self.PickupInfo.ammogive )
	
end


