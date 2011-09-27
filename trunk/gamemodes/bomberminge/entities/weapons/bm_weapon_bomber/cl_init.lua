include("shared.lua")

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end
function SWEP:Reload() end

usermessage.Hook("ChangeWeaponHoldType", function(msg)
	local ent, t
	ent = msg:ReadEntity()
	t = msg:ReadString()
	
	if ValidEntity(ent) and ent.SetWeaponHoldType then
		ent:SetWeaponHoldType(t)
	end
end

