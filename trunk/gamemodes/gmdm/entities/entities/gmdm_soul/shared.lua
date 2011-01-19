ENT.Type = "anim"

local PickupTypes = {}

PickupTypes[0] = { name="gmdm_smg", 
					nicename="smg",
					ammogive="Pistol",
					ammoamount="128" }
					
PickupTypes[1] = { name="gmdm_flamethrower", 
					nicename="flamethrower",
					ammogive="SMG1",
					ammoamount="25" }


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:SetActiveTime( t )
	self.Entity:SetNetworkedFloat( 0, t )
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:GetActiveTime()
	return self.Entity:GetNetworkedFloat( 0 )
end


function ENT:SetPickupType( name )

	for k, v in pairs(PickupTypes) do
	
		if ( v.name == name ) then
			self.Entity:SetNetworkedInt( 0, k )
		return end
	
	end
	
	Msg("Warning: gm_pickup - unhandled pickup type "..name.."\n")
	self.Entity:SetNetworkedInt( 0, 0 )

end


function ENT:GetPickupName()
	return PickupTypes[ self:GetPickupType() ].name
end

function ENT:GetPickupType()
	return self.Entity:GetNetworkedInt( 0 )
end

function ENT:GetNiceName()
	return "" .. PickupTypes[ self:GetPickupType() ].nicename
end

function ENT:DoAmmoGive( ply )

	ply:GiveAmmo( PickupTypes[ self:GetPickupType() ].ammoamount, PickupTypes[ self:GetPickupType() ].ammogive )
	
end


