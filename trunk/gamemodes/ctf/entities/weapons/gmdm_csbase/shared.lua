-- firemode enum
AF_AUTOMATIC = 1
AF_SEMIAUTOMATIC = 2
AF_BURSTFIRE = 3

if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	
	SWEP.ViewModelFOV		= 70;

	surface.CreateFont( "csd", 64 * ( 1280 / ScrW() ), 500, true, true, "HVACSKillIcons" );
	surface.CreateFont( "Day of Defeat Logo", 58, 500, true, true, "HVADODKillIcons" );
end

SWEP.MaxRicochet = 0;
SWEP.Base						= "gmdm_base";
SWEP.Author						= "SteveUK";
SWEP.Contact					= "stephen.swires@gmail.com";
SWEP.Purpose					= "CCTF Weapon";
SWEP.Instructions				= "To defeat the cyberdemon, shoot at it until it dies.";

SWEP.Category					= "Combat CTF";

SWEP.HoldType					= "ar2"

SWEP.IsCSWeapon					= true;
SWEP.ViewModel					= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_usp.mdl"

SWEP.ViewModelFlip		= true;
SWEP.CSMuzzleFlashes	= true;

SWEP.Primary.Sound				= Sound( "Weapon_AK47.Single" );
SWEP.Primary.Recoil				= 0.75;
SWEP.Primary.Damage				= 50;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.Delay				= 0.4;

SWEP.Primary.PlayFinalShot		= false
SWEP.Primary.FinalShotSound		= Sound( "Weapon_Garand.ClipDing" );
SWEP.ReloadEmptyOnly			= false

SWEP.SilencedSound				= Sound( "Weapon_M4A1.Silenced" );
SWEP.SilencedAccuracy			= 2;
SWEP.SilencedDamage				= 0.7;

SWEP.Primary.BurstShots			= 0;
SWEP.Primary.BurstDelay			= 0.08;

SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "smg1";

SWEP.Secondary.Ammo				= "none";

-- firemodes
SWEP.MultipleFiremodes			= false;
SWEP.DefaultFiremode			= AF_AUTOMATIC;
SWEP.SupportedFiremodes			= { AF_AUTOMATIC, AF_BURSTFIRE };

SWEP.FiremodeSwitchSound		= Sound( "Weapon_SMG1.Special1" );
SWEP.PlaySwitchAnimation		= false;
SWEP.SwitchAnimation			= ACT_VM_DEPLOY;

SWEP.Primary[ AF_AUTOMATIC ] 					= {}
SWEP.Primary[ AF_AUTOMATIC ].FireModeName 		= "Automatic";
SWEP.Primary[ AF_AUTOMATIC ].Automatic 			= true;
SWEP.Primary[ AF_AUTOMATIC ].BurstShots			= 0;

SWEP.Primary[ AF_SEMIAUTOMATIC ] 				= {}
SWEP.Primary[ AF_SEMIAUTOMATIC ].FireModeName 	= "Semi-Automatic";
SWEP.Primary[ AF_SEMIAUTOMATIC ].Automatic 		= false;
SWEP.Primary[ AF_SEMIAUTOMATIC ].BurstShots		= 0;

SWEP.Primary[ AF_BURSTFIRE ]					= {}
SWEP.Primary[ AF_BURSTFIRE ].Automatic			= false;
SWEP.Primary[ AF_BURSTFIRE ].BurstShots			= 2;
SWEP.Primary[ AF_BURSTFIRE ].FireModeName 		= "Burst Fire";

SWEP.VMPlaybackRate				= 1.0

SWEP.HasIronsights				= true; -- HVA Specific
SWEP.IronsightsFOV				= 45; -- HVA Specific
SWEP.IronsightAccuracy			= 5; -- what to divide spread by to increase accuracy
SWEP.StopIronsightsAfterShot	= false;
SWEP.IronsightFOVSpeed			= 0.25;
SWEP.IronsightDelayFOV			= false;

SWEP.SprayAccuracy				= 0.75;
SWEP.SprayTime					= 0.1;

SWEP.PlayIdleAnim				= true;

SWEP.ReloadSpeedMultiplier		= 1.0;
SWEP.ImpactEffects = false;

SWEP.PenetrationMax = 32;
SWEP.PenetrationMaxWood = 64;

SWEP.Firemode = -1;

SWEP.BurstQueue = 0;
SWEP.BurstAmount = 0;

function SWEP:Deploy()
	if( self.SupportsSilencer and self:GetNetworkedBool( "Silenced" ) == true ) then
		self:SendWeaponAnim( ACT_VM_DRAW_SILENCED )
	else
		self:SendWeaponAnim( ACT_VM_DRAW )
	end

	if( self.MultipleFiremodes and self.Firemode == -1 and SERVER ) then
		self:InstallFiremode( self.DefaultFiremode );
	end
	
	self:SetIronsights( false );
	
	if( IsValid(self.Owner) and self.Owner:GetViewModel() ) then
		self.NextIdleTime = CurTime() + self.Owner:GetViewModel():SequenceDuration();
	end

	self.BurstQueue = 0
	self.BurstAmount = 0
end

function SWEP:Holster()	
	self:SetIronsights( false );

	return true
end

function SWEP:InstallFiremode( fm )
	if( self.Primary[ fm ] and fm != self.Firemode) then
		for k, v in pairs( self.Primary[fm] ) do
			self.Primary[ k ] = v;
		end
		
		if( SERVER ) then
			self.Weapon:SetNetworkedInt( "Firemode", fm );
			
			if( self.Owner and self.Owner:IsValid() ) then
				self.Owner:EmitSound( self.FiremodeSwitchSound );
			end
		end
		
		if( self.PlaySwitchAnimation ) then
			self.Weapon:SendWeaponAnim( self.SwitchAnimation );
		end
		
		self.Firemode = fm;
	end
end

function SWEP:SelectFiremode( )

	if( CLIENT ) then return end 
	
	local current = self.Firemode;
	local available = self.SupportedFiremodes;
	local cavailable = #available;
	
	local idealFiremode = 1;
	
	if( cavailable > 1 ) then
		for k, v in pairs( available ) do
			if( v == current and k < cavailable ) then
				idealFiremode = k+1;
			end
		end
	end
	
	self:InstallFiremode( available[ idealFiremode ] );
end

function SWEP:Initialize()

	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType );
		self:SetNPCMinBurst( self.Primary.ClipSize );
		self:SetNPCMaxBurst( self.Primary.ClipSize );
		self:SetNPCFireRate( self.Primary.Delay );
		
		if( self.MultipleFiremodes ) then
			self:InstallFiremode( self.DefaultFiremode );
		end
	end
	
	self.Weapon:SetNetworkedBool( "Ironsights", false );
	
	local printname = self.PrintName or self:GetClass()
	--pickup:SimpleAdd( self:GetClass(), printname, self.WorldModel, self.Primary.Ammo, self.Primary.DefaultClip/2, false )
	
end

function SWEP:Reload()
	if( self.Weapon:Clip1() < self.Primary.ClipSize ) then		
		local timenow = CurTime();
		
		if( self.ReloadEmptyOnly and self.Weapon:Clip1() > 0 ) then return end
		if( self.SupportsSilencer and self.Weapon:GetNetworkedBool( "Silenced", false ) ) then
			self.Weapon:DefaultReload( ACT_VM_RELOAD_SILENCED );
		else
			self.Weapon:DefaultReload( ACT_VM_RELOAD );
		end
		
		self:SetIronsights( false );
		self.Owner:SetFOV( 0, 0.25 );
		
		if( self.ReloadSpeedMultiplier != 1.0 ) then
			local diff = self.Owner:GetViewModel():SequenceDuration();
			
			local newtime = diff/self.ReloadSpeedMultiplier;
			
			self.Owner:GetViewModel():SetPlaybackRate( self.ReloadSpeedMultiplier );
			self.Weapon:SetNextPrimaryFire( CurTime())
			self.Weapon:SetNextSecondaryFire( CurTime() )
		end
	end
end

function SWEP:GetStanceAccuracyBonus( )

	if( self.Owner:IsNPC() ) then
		return 0.8;
	end
	
	local LastAccuracy = self.LastAccuracy or 0;
	local Accuracy = 1.0;
	local LastShoot = self.LastAttack;
	
	local speed = self.Owner:GetVelocity():Length()
	-- 200 walk, 500 sprint, 705 noclip
	local speedperc = math.Clamp( math.abs( speed / 705 ), 0, 1 );	
	
	if( self.Weapon:GetNetworkedBool( "Ironsights", false ) == true ) then
		Accuracy = Accuracy * self.IronsightAccuracy;
	end
	
	if( self.Weapon:GetNetworkedBool( "Silenced", false ) == true ) then
		Accuracy = Accuracy * self.SilencedAccuracy;
	end
	
	if( CurTime() <= LastShoot + self.SprayTime ) then
		if( SERVER ) then
			Accuracy = Accuracy * self.SprayAccuracy;
		else
			Accuracy = Accuracy * ( self.SprayAccuracy / 1.25 ); -- exaggerate the spray accuracy on the client
		end
	end
	
	if( speed > 10 ) then -- moving
		Accuracy = Accuracy * ( ( ( 1 - speedperc ) + 0.1 ) / 1.5 );
	end
	
	if( self.Owner:KeyDown( IN_DUCK ) == true ) then -- ducking moving forward
		Accuracy = Accuracy * 1.50;
	end

	if( self.Owner:KeyDown( IN_LEFT ) or self.Owner:KeyDown( IN_RIGHT ) ) then -- just strafing
		Accuracy = Accuracy * 0.95;
	end
	
	if( LastAccuracy != 0 ) then
		if( Accuracy > LastAccuracy ) then
			Accuracy = math.Approach( self.LastAccuracy, Accuracy, FrameTime() * 2 )
		else
			Accuracy = math.Approach( self.LastAccuracy, Accuracy, FrameTime() * -4 )
		end
	end
	
	self.LastAccuracy = Accuracy;
	return Accuracy;
	
end

SWEP.LastAttack = 0;
SWEP.NextFiremodeSwitch = 0;

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if( self.MultipleFiremodes == true and self.Owner and self.Owner:IsPlayer() and self.Owner:KeyDown( IN_USE ) and CurTime() >= self.NextFiremodeSwitch ) then
		self:SelectFiremode();
		self.NextFiremodeSwitch = CurTime() + 0.15;
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
		return;
	elseif( self.Owner and self.Owner:IsPlayer() and self.Owner:KeyDown( IN_USE ) ) then
		return; -- stop firing bullets when they mean to change firemodes
	end

	if( self.Weapon:Clip1() <= 0 ) then
		self:Reload()
		return;
	end	
	
	if( !self:CanShootWeapon() ) then return end
	
	if( self.HasIronsights == false ) then
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay ); -- only disallow secondary attack if we don't have ironsights on our weapon
	end
	
	local DeltaAttack = CurTime() - self.LastAttack;

	if( self.Primary.BurstShots > 0 ) then
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay + ((self.Primary.BurstShots + 1 ) * self.Primary.BurstDelay) )
	else
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	end
	
	if ( !self:CanPrimaryAttack() ) then
		return;
	end
	
	local sound = self.Primary.Sound;
	
	if( self.SupportsSilencer == true and self.Weapon:GetNetworkedBool( "Silenced" ) == true ) then
		sound = self.SilencedSound;
	end
	
	// Play shoot sound
	if IsFirstTimePredicted() then
		self.Weapon:EmitSound( sound )
	end

	local fDamage, fRecoil, iBullets, fAimCone = 0, 0, self.Primary.NumShots, 0;
	
	// Shoot the bullet
	fDamage = ( self.Primary.Damage * math.random( 1.0, 1.25 ) ) * math.Clamp( self:GetStanceAccuracyBonus(), 0.8, 1.3 );
	fRecoil = ( self.Primary.Recoil / self:GetStanceAccuracyBonus() )
	fAimCone = (self.Primary.Cone / self:GetStanceAccuracyBonus())
	
	if( self.Weapon:GetNetworkedBool( "Silenced" ) == true ) then
		fDamage = fDamage * self.SilencedDamage;
	end
		
	self:GMDMShootBullet( fDamage, nil, -fRecoil, 0, iBullets, fAimCone )
	
	if( self.Primary.BurstShots > 0 && self.BurstQueue == 0 && IsFirstTimePredicted() ) then
		self.BurstQueue = CurTime() + self.Primary.BurstDelay
		self.BurstAmount = self.Primary.BurstShots
	end
	
	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if( bIron ) then
		if( self.StopIronsightsAfterShot == true ) then
			self:SetIronsights( false )
		end
		
		self.Owner:GetViewModel():SetPlaybackRate( self.VMPlaybackRate )  
	end
		
	// Remove 1 bullet from our clip
	self:TakePrimaryAmmo( 1 )
	
	if( IsFirstTimePredicted() and self.Weapon:Clip1() == 0 and self.Primary.PlayFinalShot ) then
		self.Weapon:EmitSound( self.Primary.FinalShotSound );
	end
	
	if ( self.Owner:IsNPC() ) then return end
	
	// Punch the player's view
	if IsFirstTimePredicted() then
		math.randomseed(CurTime())
		self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
	end

	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
	self.LastAttack = CurTime();
	
	if( self.Owner and self.Owner:GetViewModel() ) then
		self.NextIdleTime = CurTime() + self.Owner:GetViewModel():SequenceDuration();
	end
end

function SWEP:SecondaryAttack()
	
	if ( !self.IronSightsPos ) then return end
	if ( self.Owner:KeyDown( IN_SPEED ) ) then return end

	if( self.SupportsSilencer == true and self.Owner and self.Owner:IsPlayer() and self.Owner:KeyDown( IN_USE ) ) then
		local silenced = self.Weapon:GetNetworkedBool( "Silenced", false )
		
		if( !silenced ) then
			self.Weapon:SendWeaponAnim( ACT_VM_ATTACH_SILENCER )
		else
			self.Weapon:SendWeaponAnim( ACT_VM_DETACH_SILENCER )
		end
		
		self.Weapon:SetNetworkedBool( "Silenced", !silenced )
		
		if( self.Owner and self.Owner:GetViewModel() ) then
			self.NextIdleTime = CurTime() + self.Owner:GetViewModel():SequenceDuration();
			self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration());
		end
		
		return
	end
	
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	
	self:SetIronsights( bIronsights )
	
	self.NextSecondaryAttack = CurTime() + 0.3
	
end

function SWEP:SetFOV( fov, delay, ironsightcheck )

	if not ironsightcheck then
		ironsightcheck = false
	end
	
	if( self.Owner and self.Weapon and self.Owner:IsPlayer() ) then
	
		if( ironsightcheck == true and self.Weapon:GetNetworkedBool( "Ironsights" )	 == false ) then
			return
		end
		
		local active = self.Owner:GetActiveWeapon()
		
		if( active and active:IsValid() ) then
			if( active == self.Weapon ) then
				self.Owner:SetFOV( fov, delay );
			end
		end
	end
end

function SWEP:SetIronsights( b )

	if( SERVER ) then
		if( self.HasIronsights == true and self.Owner ) then
			if( b == true ) then
				if( self.IronsightDelayFOV ) then
					local delay = self.ScopeTime or 0.25;
					timer.Simple( delay, self.SetFOV, self, self.IronsightsFOV, 0, true );
				else
					self.Owner:SetFOV( self.IronsightsFOV, self.IronsightFOVSpeed );
				end
				
				--GAMEMODE:SetPlayerSpeed( self.Owner, GAMEMODE.PlayerWalkSpeed * self.IronsightWalkSpeed, GAMEMODE.PlayerRunSpeed * self.IronsightRunSpeed );
			else
				self.Owner:SetFOV( 0, 0.2 );
				--GAMEMODE:SetPlayerSpeed( self.Owner, GAMEMODE.PlayerWalkSpeed * self.WalkSpeed, GAMEMODE.PlayerRunSpeed * self.RunSpeed );
			end
		end
		
		if( self.Weapon ) then
			self.Weapon:SetNetworkedBool( "Ironsights", b )
		end
	end
	
end


local IRONSIGHT_TIME = 0.25

SWEP.RunArmOffset = Vector (-6.3159, -4.3201, 0.3808)
SWEP.RunArmAngle = Vector (-11.5989, -66.0094, -5.4286)


/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	--if( !self:CanShootWeapon() ) then return self.BaseClass.GetViewModelPosition( pos, ang )	 end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )	
	
	local vel = self.Owner:GetVelocity()
				
	if( self.LastOffset and !bIron ) then
		if( vel.z == 0 and self.LastOffset != 0 ) then
			if( !self.LastRestoreOffset ) then
				self.LastRestoreOffset = self.LastOffset;
			end
			
			local offset = math.Approach( self.LastRestoreOffset, 0, -0.85);
			pos.z = pos.z - offset
			
			self.LastRestoreOffset = offset
			
			if( offset == 0 ) then
				self.LastOffset = 0;
				self.LastRestoreOffset = nil;
			end
		else
			local offset = math.Clamp( vel.z / 90, -3, 2 )
			pos.z = pos.z - offset
				
			self.LastOffset = offset
			self.LastOffTime = CurTime()		
		end
	else
		self.LastOffset = 0;
	end

	
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
	
		local bUseVector = false
		
		if( !self.RunArmAngle.pitch ) then
			bUseVector = true
		end
		
		// Rotate the viewmodel to self.RunArmAngle
		if( bUseVector == true ) then -- using ironsights designer probably so make it support that
			ang:RotateAroundAxis( ang:Right(), 		self.RunArmAngle.x * DashDelta )
			ang:RotateAroundAxis( ang:Up(), 		self.RunArmAngle.y * DashDelta )
			ang:RotateAroundAxis( ang:Forward(), 	self.RunArmAngle.z * DashDelta )
			
			pos = pos + self.RunArmOffset.x * ang:Right() * DashDelta 
			pos = pos + self.RunArmOffset.y * ang:Forward() * DashDelta 
			pos = pos + self.RunArmOffset.z * ang:Up() * DashDelta 
		else
			ang:RotateAroundAxis( Right,	self.RunArmAngle.pitch * DashDelta )
			ang:RotateAroundAxis( Down,  	self.RunArmAngle.yaw   * DashDelta )
			ang:RotateAroundAxis( Forward,  self.RunArmAngle.roll  * DashDelta )

			// Offset the viewmodel to self.RunArmOffset
			pos = pos + ( Down * self.RunArmOffset.x + Forward * self.RunArmOffset.y + Right * self.RunArmOffset.z ) * DashDelta			
		end
		
		if( self.DashEndTime ) then
			return pos, ang
		end
	
	end


	if( !self.IronSightsPos or !self.HasIronsights ) then return pos, ang end
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.1
			self.BobScale 	= 0.3
		else 
			self.SwayScale 	= 2.5
			self.BobScale 	= 2.0
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

	local Offset	= self.IronSightsPos
	
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

	
end


SWEP.NextIdleTime = 0

function SWEP:Think()
	
	if( CLIENT and self.MultipleFiremodes and self.Firemode != self.Weapon:GetNetworkedInt( "Firemode", 1 ) ) then
		self:InstallFiremode( self.Weapon:GetNetworkedInt( "Firemode", 1 ) ); -- sync up
	end
	
	if( self:CanShootWeapon() and CurTime() >= self.NextIdleTime and self.PlayIdleAnim ) then

		local silenced = self.Weapon:GetNetworkedBool( "Silenced", false )
		
		if( !silenced ) then
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		else
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE_SILENCED )
		end
		
		if( self.Owner and self.Owner:GetViewModel() ) then
			self.NextIdleTime = CurTime() + self.Owner:GetViewModel():SequenceDuration();
		else
			self.NextIdleTime = CurTime() + 0.5	
		end

	end
	
	if( self.Weapon:GetNetworkedBool( "Ironsights" ) == true and self.Owner:KeyDown( IN_SPEED ) ) then
		self:SetIronsights( false )
	end

	if self.BurstQueue > 0 && CurTime() >= self.BurstQueue then
		if self.BurstAmount == 0 || self.Weapon:Clip1() <= 0 then 
			self.BurstQueue = 0
		else
			if IsFirstTimePredicted() then
				self.BurstAmount = self.BurstAmount - 1
			end

			self:SetNextPrimaryFire(CurTime())
			self:PrimaryAttack()
	
			self.BurstQueue = CurTime() + 0.05
		end
	end
end

function SWEP:DrawHUD()
	-- nothing

	self:DrawCrosshairHUD()
	
end

function SWEP:AdjustMouseSensitivity( default )

	if( self.Weapon:GetNetworkedBool( "Ironsights" ) == true ) then
		return 0.75;
	end
	
	return 1.0;
	
end