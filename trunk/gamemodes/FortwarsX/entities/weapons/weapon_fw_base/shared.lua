
//Stole most of this from garry :D

if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true
	
	// This is the font that's used to draw the death icons
	surface.CreateFont( "csd", ScreenScale( 30 ), 500, true, true, "CSKillIcons" )
	surface.CreateFont( "csd", ScreenScale( 60 ), 500, true, true, "CSSelectIcons" )
	
	AccessorFunc( SWEP, "Accuracy", "Accuracy", FORCE_NUMBER )
	SWEP:SetAccuracy( 0 )

end


SHELL_9MM = 1 -- pistol shells  
SHELL_57 = 2 -- bigger pistol shells? maybe for desert eagle?  
SHELL_556 = 3 -- AK47, etc. shells  
SHELL_762NATO = 4 -- M4, etc. shells  
SHELL_SHOTGUN = 5 -- all shotguns  
SHELL_338MAG = 6 -- AWP/scout shells  
SHELL_50CAL = 7 -- this is the default hl2 rifle shell. it looks roughly like a 50 caliber shell.  

SWEP.Author			= "Dlaor"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Primary.Sound			= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType )
	end
	
	self.Weapon:SetNetworkedBool( "Ironsights", false )
	
end

function SWEP:IsRunning()
	return ( self.Owner:KeyDown( IN_SPEED ) and self.Owner:GetVelocity():Length() > 2 )
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	self:SetIronsights( false )
	self:PlayIdle( -1 )
end

function SWEP:Think()
	
	if ( self:IsRunning() ) then
		self:SetIronsights( false )
	end
	
	if ( CLIENT ) then
		self:SetAccuracy( self:GetAccuracy() + ( self.Owner:GetVelocity():Length() / 4000 ) )
		self:SetAccuracy( self:GetAccuracy() - ( self:GetAccuracy() / 8 ) )
	end
end

function SWEP:Deploy()
	self:PlayIdle( 1 )
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if ( !self:CanPrimaryAttack() or self:IsRunning() ) then return end
	
	// Play shoot sound
	self.Weapon:EmitSound( self.Primary.Sound )
	
	// Shoot the bullet
	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	if ( CLIENT ) then self:SetAccuracy( self:GetAccuracy() + ( self.Primary.Recoil / 20 ) ) end
	
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,0.1) * self.Primary.Recoil, math.Rand(-0.16,0.16) * self.Primary.Recoil, 0 ) )
	
	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end

function SWEP:PlayIdle( time )
	timer.Create( "IDLE", time, 1, function()
		if ( time > -1 and ValidEntity( self.Weapon ) and self.Owner:GetActiveWeapon() == self.Weapon ) then
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		end
	end )
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:CSShootBullet( dmg, recoil, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01
	
	if ( self.Owner:GetVelocity():Length() > 20 ) then
		cone = cone + 0.025
	end
	
	if ( !self.Owner:IsOnGround() ) then
		cone = cone + 0.04
	end
	
	if ( self.Owner:Crouching() or self.Weapon:GetNetworkedBool( "Ironsights", false ) ) then
		cone = cone / 2
	end

	local bullet = {}
	bullet.Num 		  = numbul
	bullet.Src 		  = self.Owner:GetShootPos()		// Source
	bullet.Dir 		  = self.Owner:GetAimVector()		// Dir of bullet
	bullet.Spread 	  = Vector( cone, cone, 0 )			// Aim Cone
	bullet.Tracer	  = 2								// Show a tracer on every x bullets 
	//bullet.TracerName = "LaserTracer"					// Tracer name
	bullet.Force	  = dmg								// Amount of force to give to phys objects
	bullet.Damage	  = dmg / 3							// Lessen damage
	
	self.Owner:FireBullets( bullet )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	self:PlayIdle( 1 )
	
	if ( !CLIENT ) then return end
	
	local ed = EffectData()  //Rambo_6's bullet shell effect!
	ed:SetEntity( self.Weapon )  
	ed:SetAttachment( self.Weapon:LookupAttachment( "2" ) ) -- what attachment should the bullet come from?  
	ed:SetScale( self.Primary.ShellType or 1 )  
	util.Effect( "weapon_shell", ed, true, true )  

end


/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	// try to fool them into thinking they're playing a Tony Hawks game
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-14, 14), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-9, 9), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	
end

local IRONSIGHT_TIME = 0.25
SWEP.RunArmAngle  = Angle( -15, 0, 0 )
SWEP.RunArmOffset = Vector( 0, 0, 1 )

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end
	
	if ( !self:IsRunning() ) then

		local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
		
		if ( bIron != self.bLastIron ) then
		
			self.bLastIron = bIron 
			self.fIronTime = CurTime()
			
			if ( bIron ) then 
				self.SwayScale 	= 0.3
				self.BobScale 	= 0.1
			else 
				self.SwayScale 	= 1.0
				self.BobScale 	= 1.0
			end
		
		end
		
		local fIronTime = self.fIronTime or 0

		if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
			return pos, ang 
		end
		
		local Mul = 1.0
		
		if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
		
			Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
			
			if (!bIron) then Mul = 1 - Mul end
		
		end

		local Offset = self.IronSightsPos
		
		if ( self.IronSightsAng ) then
		
			ang = ang * 1
			ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
			ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
			ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
		
		end
		
		local Right 	= ang:Right()
		local Up 		= ang:Up()
		local Forward 	= ang:Forward()

		pos = pos + Offset.x * Right * Mul
		pos = pos + Offset.y * Forward * Mul
		pos = pos + Offset.z * Up * Mul
		
		return pos, ang
		
	else
	
		local Owner = self.Owner
		if (!Owner) then return pos, ang end

			local Down = ang:Up() * -1
			local Right = ang:Right()
			local Forward = ang:Forward()
		
			// Offset the viewmodel to self.RunArmOffset
			pos = pos + ( Down * self.RunArmOffset.x + Forward * self.RunArmOffset.y + Right * self.RunArmOffset.z )
			
			// Rotate the viewmodel to self.RunArmAngle
			ang:RotateAroundAxis( Right,	self.RunArmAngle.pitch )
			ang:RotateAroundAxis( Down,  	self.RunArmAngle.yaw )
			ang:RotateAroundAxis( Forward,  self.RunArmAngle.roll )

		return pos, ang
		
	end
	
end


/*---------------------------------------------------------
	SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end


SWEP.NextSecondaryAttack = 0
/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if ( !self.IronSightsPos or self:IsRunning() ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
end
/*---------------------------------------------------------
	DrawHUD
	
	Just a rough mock up showing how to draw your own crosshair.
	
---------------------------------------------------------*/

function SWEP:DrawHUD()
	
	if ( self.Weapon:GetNetworkedBool( "Ironsights", false ) or self:IsRunning() ) then return end
	
	local x = ScrW() / 2
	local y = ScrH() / 2
	local scale = 10 * self.Primary.Cone
	
	scale = scale + self:GetAccuracy()
	
	if ( self.Owner:Crouching() ) then
		scale = scale / 2
	end
	
	surface.SetDrawColor( 0, 255, 0, 255 )
	
	// Draw an awesome crosshair
	local gap = 40 * scale
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
	
	surface.SetDrawColor( 0, 255, 0, 25 )
	
	local time = CurTime() * -180
	
	//Some fancy rotating lines just to make it look different than Garry's crosshairs
	DrawRotLine( x, y, time,       length, gap ) 
	DrawRotLine( x, y, time + 90,  length, gap )
	DrawRotLine( x, y, time + 180, length, gap )
	DrawRotLine( x, y, time + 270, length, gap )

end

function DrawRotLine( x, y, time, length, gap )
	surface.DrawLine(
		x + ( math.sin( math.rad( time ) ) * length ),
		y + ( math.cos( math.rad( time ) ) * length ),
		x + ( math.sin( math.rad( time ) ) * gap ),
		y + ( math.cos( math.rad( time ) ) * gap )
	)
end

/*---------------------------------------------------------
	onRestore
	Loaded a saved game (or changelevel)
---------------------------------------------------------*/
function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
	
end
