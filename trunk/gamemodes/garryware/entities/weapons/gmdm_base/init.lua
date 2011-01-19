////////////////////////////////////////////////
-- -- Garry's Mod Deathmatch Weapon Base      --
-- by SteveUK                                 --
//--------------------------------------------//
////////////////////////////////////////////////


AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')


////////////////////////////////////////////////

function SWEP:OnRestore()

end

function SWEP:AcceptInput( name, activator, caller )
	return false
end

function SWEP:KeyValue( key, value )

end

function SWEP:OnRemove()
end

function SWEP:Equip( NewOwner )

end

SWEP.EquipAmmo = SWEP.Equip

function SWEP:GetCapabilities()
	return CAP_WEAPON_RANGE_ATTACK1 | CAP_INNATE_RANGE_ATTACK1 | CAP_WEAPON_RANGE_ATTACK2 | CAP_INNATE_RANGE_ATTACK2
	
end

function SWEP:NPCShoot_Primary( ShootPos, ShootDir )
	self:PrimaryAttack()

end

function SWEP:NPCShoot_Secondary( ShootPos, ShootDir )
	self:PrimaryAttack()

end

function SWEP:Deploy()

	-- If it's silenced, we need to play a different anim.
	if( self.SupportsSilencer and self:GetNetworkedBool( "Silenced" ) == true ) then
		self:SendWeaponAnim( ACT_VM_DRAW_SILENCED )
	else
		self:SendWeaponAnim( ACT_VM_DRAW )
	end
	
	-- Quick switch.
	return true
end 

////////////////////////////////////////////////
////////////////////////////////////////////////