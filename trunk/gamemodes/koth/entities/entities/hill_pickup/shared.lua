
ENT.Type = "anim"
ENT.Base = "base_anim"

PickupTypes = {}
PickupTypes[1] = { Name="kh_smg", NiceName="SMG", Model="models/weapons/w_smg1.mdl" }
PickupTypes[2] = { Name="kh_shotgun", NiceName="Shotgun", Model="models/weapons/w_shotgun.mdl" }
PickupTypes[3] = { Name="kh_radcannon", NiceName="Radiation Cannon", Model="models/weapons/w_rocket_launcher.mdl" }
PickupTypes[4] = { Name="kh_plasmarifle", NiceName="Palsma Rifle", Model="models/weapons/w_irifle.mdl" }
PickupTypes[5] = { Name="kh_betsy", NiceName="Bouncing Betsy", Model="models/items/grenadeammo.mdl" }
PickupTypes[6] = { Name="kh_tesla", NiceName="Tesla Cannon", Model="models/weapons/w_physics.mdl" }

function ENT:SetActiveTime( t )
	self.Entity:SetNetworkedFloat( 0, t )
end

function ENT:GetActiveTime()
	return self.Entity:GetNetworkedFloat( 0 )
end
