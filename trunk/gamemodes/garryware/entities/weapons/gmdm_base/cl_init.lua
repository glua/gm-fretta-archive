////////////////////////////////////////////////
-- -- Garry's Mod Deathmatch Weapon Base      --
-- by SteveUK                                 --
//--------------------------------------------//
////////////////////////////////////////////////

include('shared.lua')
include('cl_hud.lua')

SWEP.PrintName			= "Garry's Mod Deathmatch Weapon"			
SWEP.Slot				= 3	
SWEP.SlotPos			= 6
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.WepSelectIcon			= surface.GetTextureID( "weapons/swep" )

function SWEP:PrintWeaponInfo( x, y, alpha )
end

function SWEP:FreezeMovement()
	return false
end

function SWEP:OnRestore()
end

function SWEP:OnRemove()
end

function SWEP:DrawWorldModel()

	if ( self.Owner ) then
		self.Weapon:DrawModel()
	return end

end


function SWEP:DrawWorldModelTranslucent()

	if ( self.Owner ) then
		self.Weapon:DrawModel()
	return end
	

end

SWEP.RunArmAngle  = Angle( 10, -70, 0 )
SWEP.RunArmOffset = Vector( 10, 16, 16 )

function SWEP:GetViewModelPosition( pos, ang )

	local Owner = self.Owner
	if (not Owner) then return pos, ang end
	
	local DashDelta = 0
	
	-- If we're running, or have just stopped running, lerp between the anims.
	-- Disabled noshoot on sprint. Use it on reload key pressed (NOT ONLY on reloading action !).
	-- if ( self.Owner:KeyDown( IN_SPEED ) ) then
	if ( self.Owner:KeyDown( IN_RELOAD ) ) then
		
		if (not self.DashStartTime) then
			self.DashStartTime = CurTime()
			
		end
		
		DashDelta = math.Clamp( ((CurTime() - self.DashStartTime) / 0.1) ^ 1.2, 0, 1 )
		
	else
	
		if ( self.DashStartTime ) then
			self.DashEndTime = CurTime()
		end
	
		if ( self.DashEndTime ) then
		
			DashDelta = math.Clamp( ((CurTime() - self.DashEndTime) / 0.1) ^ 1.2, 0, 1 )
			DashDelta = 1 - DashDelta
			if ( DashDelta == 0 ) then self.DashEndTime = nil end
		
		end
	
		self.DashStartTime = nil
	
	end
	
	if ( DashDelta ) then
		local Down = ang:Up() * -1
		local Right = ang:Right()
		local Forward = ang:Forward()
	
		-- Offset the viewmodel to self.RunArmOffset
		pos = pos + ( Down * self.RunArmOffset.x + Forward * self.RunArmOffset.y + Right * self.RunArmOffset.z ) * DashDelta
		
		-- Rotate the viewmodel to self.RunArmAngle
		ang:RotateAroundAxis( Right,	self.RunArmAngle.pitch * DashDelta )
		ang:RotateAroundAxis( Down,  	self.RunArmAngle.yaw   * DashDelta )
		ang:RotateAroundAxis( Forward,  self.RunArmAngle.roll  * DashDelta )
	
	end

	return pos, ang

end

////////////////////////////////////////////////
////////////////////////////////////////////////