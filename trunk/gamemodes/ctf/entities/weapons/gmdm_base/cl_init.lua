
include('shared.lua')
include('cl_hud.lua')
// Variables that are only ever used on the client

SWEP.PrintName			= "GMDM Weapon"			
SWEP.Slot				= 3		// Slot in the weapon selection menu
SWEP.SlotPos			= 6		// Position in the slot
SWEP.DrawAmmo			= true	// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 	// Should draw the default crosshair

SWEP.Spawnable			= true	// Is spawnable via GMOD's spawn menu
SWEP.AdminSpawnable		= true	// Is spawnable by admins

SWEP.WepSelectIcon			= surface.GetTextureID( "weapons/swep" )	// Weapon Selection Menu texture


function SWEP:GMDMInit()

	// Nothing.
	self.Weapon:SetRenderBoundsWS( self.Weapon:GetPos() - Vector()*256, self.Weapon:GetPos() + Vector()*256 )
	
end

function SWEP:SetWeaponHoldType( t )
	// Just a fake function so we can define 
	// weapon holds in shared files without errors
end

function SWEP:PrintWeaponInfo( x, y, alpha )
end


/*---------------------------------------------------------
   Name: SWEP:FreezeMovement()
   Desc: Return true to freeze moving the view
---------------------------------------------------------*/
function SWEP:FreezeMovement()
	return false
end

/*---------------------------------------------------------
   Name: OnRestore
   Desc: Called immediately after a "load"
---------------------------------------------------------*/
function SWEP:OnRestore()
end

/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function SWEP:OnRemove()
end

/*---------------------------------------------------------
   Name: SWEP:ViewModelDrawn()
   Desc: Called straight after the viewmodel has been drawn
---------------------------------------------------------*/
function SWEP:DrawWorldModel()

	if ( self.Owner ) then
		self.Weapon:DrawModel()
	return end
	
	GAMEMODE:DrawPickupWorldModel( self.Weapon, false )

end


function SWEP:DrawWorldModelTranslucent()

	if ( self.Owner ) then
		self.Weapon:DrawModel()
	return end
	
	GAMEMODE:DrawPickupWorldModel( self.Weapon, true )

end

SWEP.RunArmAngle  = Angle( 10, -70, 0 )
SWEP.RunArmOffset = Vector( 10, 16, 16 )

function SWEP:GetViewModelPosition( pos, ang )

	local Owner = self.Owner
	if (!Owner) then return pos, ang end
	
	local DashDelta = 0
	
	// If we're running, or have just stopped running, lerp between the 
	if ( self.Owner:KeyDown( IN_SPEED ) ) then
		
		if (!self.DashStartTime) then
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
	
		// Offset the viewmodel to self.RunArmOffset
		pos = pos + ( Down * self.RunArmOffset.x + Forward * self.RunArmOffset.y + Right * self.RunArmOffset.z ) * DashDelta
		
		// Rotate the viewmodel to self.RunArmAngle
		ang:RotateAroundAxis( Right,	self.RunArmAngle.pitch * DashDelta )
		ang:RotateAroundAxis( Down,  	self.RunArmAngle.yaw   * DashDelta )
		ang:RotateAroundAxis( Forward,  self.RunArmAngle.roll  * DashDelta )
	
	end

	return pos, ang

end