ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.Types = {}
ENT.Types[ "gta_m4_silenced" ] = Model( "models/weapons/w_rif_m4a1.mdl" )
ENT.Types[ "gta_xm1014" ] = Model( "models/weapons/w_shot_xm1014.mdl" )
ENT.Types[ "gta_scout" ] = Model( "models/weapons/w_snip_scout.mdl" ) 
ENT.Types[ "gta_m249" ] = Model( "models/weapons/w_mach_m249para.mdl" )

function ENT:SetActiveTime( t )
	self.Entity:SetNetworkedFloat( "PickupTime", t )
end

function ENT:GetActiveTime()
	return self.Entity:GetNetworkedFloat( "PickupTime", 0 )
end
