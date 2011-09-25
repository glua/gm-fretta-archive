-- firemode enum
AF_AUTOMATIC = 1
AF_SEMIAUTOMATIC = 2
AF_BURSTFIRE = 3

-- Bullet types (for the shell effect)
SHELL_NONE = 0
SHELL_9MM = 1
SHELL_57 = 2
SHELL_556 = 3
SHELL_762NATO = 4
SHELL_12GAUGE = 5
SHELL_338MAG = 6
SHELL_50CAL = 7

if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	AddCSLuaFile( "firemodes.lua" );
	AddCSLuaFile( "cl_init.lua" );
	AddCSLuaFile( "cl_viewmodel.lua" );
	AddCSLuaFile( "bullets.lua" );
	AddCSLuaFile( "recoil.lua" );
	AddCSLuaFile( "shotgun.lua" );
	AddCSLuaFile( "animations.lua" );
	
	SWEP.HoldType				= "pistol";
end

include( "firemodes.lua" );
include( "bullets.lua" );
include( "recoil.lua" );
include( "shotgun.lua" );
include( "animations.lua" );

SWEP.Base						= "weapon_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_SMG1.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_SMG1.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_SMG1.Single" );
SWEP.Primary.Recoil				= 1.95;
SWEP.Primary.Damage				= 35;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.Automatic			= true;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.08;
SWEP.Primary.Ammo				= "pistol"; 
SWEP.Primary.DefaultClip		= 500;
SWEP.Primary.Bullets			= 1;
SWEP.Primary.BurstShots			= 0;
SWEP.Primary.BurstDelay			= 0.15;

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;
SWEP.PlayIdleAnim				= true;
SWEP.VMPlaybackRate				= 1.0; // during ironsights

SWEP.RequiresPump				= false; // shotguns: requires pumping before shooting?
SWEP.AutomaticPump				= true; // set to false if primary attack should pump the shotgun instead of doing it automatically

SWEP.RunArmAngle  				= Angle( 0, -50, 12 );
SWEP.RunArmOffset 				= Vector( 4, 1, 10 );

SWEP.IronSightsPos  			= Vector( 0, 0, 0 );
SWEP.IronSightAng				= Vector( 0, 0, 0 );
SWEP.IronsightAccuracy			= 2.5;
SWEP.IronsightTime				= 0.35;

SWEP.ShellType					= SHELL_NONE;

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
	self.NextIdleTime = 0;
	self.BurstQueue = 0;
	self.fIronTime = 0;
	
	if( self.RequiresPump ) then
		self.Weapon:SetNWBool( "NeedsPump", false );
	end
	
end

function SWEP:Deploy()

	// If it's silenced, we need to play a different anim
	if( self.SupportsSilencer and self:GetNetworkedBool( "Silenced" ) == true ) then
		self:SendWeaponAnim( ACT_VM_DRAW_SILENCED )
	else
		self:SendWeaponAnim( ACT_VM_DRAW )
	end

	// Set the firemode
	if( self.MultipleFiremodes and ( !self.Firemode || self.Firemode == -1 ) and SERVER ) then
		self:InstallFiremode( self.DefaultFiremode );
	end
	
	self:SetIronsights( false );
	self.NextPrimaryFire = 0;
	
	// Set the idle time
	if( IsValid(self.Owner) and self.Owner:GetViewModel() ) then
		self.NextIdleTime = CurTime() + self.Owner:GetViewModel():SequenceDuration();
	end

	self.BurstQueue = 0
	self.BurstAmount = 0
	
	// Quick switch
	return true
end

function SWEP:Holster()	
	self:SetIronsights( false );
	self.Weapon:SetNetworkedBool( "reload", false );

	return true
end


function SWEP:PrimaryAttack()

	
	if ( !self:CanPrimaryAttack() ) then return end
	
	if( self.MultipleFiremodes == true and self.Owner and self.Owner:IsPlayer() and self.Owner:KeyDown( IN_USE ) and CurTime() >= ( self.NextFiremodeSwitch or 0 ) ) then
		self:SelectFiremode();
		self.NextFiremodeSwitch = CurTime() + 0.15;
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
		return;
	elseif( self.Owner and self.Owner:IsPlayer() and self.Owner:KeyDown( IN_USE ) ) then
		return; -- stop firing bullets when they mean to change firemodes
	end
	
	if( self:NeedsPump() ) then
		self:Pump();
		return;
	end
	
	if( !self.CanRunAndShoot && self.Weapon:GetNetworkedBool( "RunningAnims", false ) == true ) then return end
	
	if( ( ( CLIENT && IsFirstTimePredicted() ) || SERVER ) and ValidEntity( self.Owner ) ) then
	
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self.NextPrimaryFire = CurTime() + self.Primary.Delay;
	
		local silenced = self.Weapon:GetNetworkedBool( "Silenced", false )
		
		if( silenced ) then
			self.Weapon:EmitSound( self.SilencedSound );
		else
			self.Weapon:EmitSound( self.Primary.Sound );
		end
		
		self:ShootBullets( self.Primary.Damage, self.Primary.Bullets, self.Primary.Cone, silenced );
		self:TakePrimaryAmmo( 1 );
		self.Weapon:Recoil( -self.Primary.Recoil, 0 );
		
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
			
		
		if( IsFirstTimePredicted() and self.Weapon:Clip1() == 0 and self.Primary.PlayFinalShot ) then
			self.Weapon:EmitSound( self.Primary.FinalShotSound );
		end
			
		if( self.RequiresPump ) then
			self.Weapon:SetNWBool( "NeedsPump", true );
		end
		
		if( self.Owner and self.Owner:IsPlayer() and self.Owner:GetViewModel() ) then
			self.NextIdleTime = CurTime() + self.Owner:GetViewModel():SequenceDuration();
		else
			self.NextIdleTime = CurTime() + self.Primary.Delay;
		end

		
	end
	

	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
	self.LastAttack = CurTime();
	self:EjectShell( self.ShellType );
	
end

function SWEP:EjectShell( shell_type, attachment )
	
	if( SERVER ) then
		local ed = EffectData()
		ed:SetOrigin( self.Owner:GetShootPos() )
		ed:SetEntity( self.Weapon )
		ed:SetAttachment( self.Weapon:LookupAttachment( attachment or "2" ) )
		ed:SetScale( shell_type or SHELL_762NATO )
		
		util.Effect( "weapon_shell", ed, true, true )
	end
	
end

function SWEP:Reload()
	if( self.Weapon:GetNetworkedBool( "RunningAnims", false ) || self.Weapon:GetNetworkedBool( "reload", false ) ) then return true end
	
	if( self.SingleReload ) then
		self.Weapon:ShotgunReloadStart();
		return;
	end
	
	if( self.Weapon:Clip1() < self.Primary.ClipSize ) then		
		if( self.ReloadEmptyOnly and self.Weapon:Clip1() > 0 ) then return true end
	end
	
	if( self.SupportsSilencer and self.Weapon:GetNetworkedBool( "Silenced", false ) ) then
		self.Weapon:CustomReload( ACT_VM_RELOAD_SILENCED );
	else
		self.Weapon:CustomReload( ACT_VM_RELOAD );
	end
	
	return true
end

function SWEP:HandleReload( seq )
	if( self.Weapon:Clip1() > 0 ) then
		return self.Weapon:DefaultReloadEx( seq, self.Primary.ClipSize + 1, 0 );
	else
		return self.Weapon:DefaultReloadEx( seq, self.Primary.ClipSize, 0 );
	end
end

function SWEP:Think()
	self.Weapon:DoRecoilThink();
	
	if( !ValidEntity( self.Owner ) || !self.Owner:IsPlayer() ) then return end
	
	if( self.SingleReload ) then
		self.Weapon:ShotgunReloadThink( )
	else
		self.Weapon:ReloadThink();	
	end
		
	if( !self.Weapon.CanRunAndShoot ) then
		local running = self.Weapon:GetNetworkedBool( "RunningAnims", false );
		
		if( ( self.Owner:KeyDown( IN_SPEED ) && !running ) || self.Owner:GetMoveType() == MOVETYPE_LADDER ) then
			self.Weapon:SetNetworkedBool( "RunningAnims", true );
		elseif( !self.Owner:KeyDown( IN_SPEED ) && running && self.Owner:GetMoveType() != MOVETYPE_LADDER ) then
			self.Weapon:SetNetworkedBool( "RunningAnims", false );
		end
	end
	
	if( self.Weapon:GetNetworkedBool( "Ironsights" ) == true and self.Weapon:GetNetworkedBool( "RunningAnims", false ) ) then
		self:SetIronsights( false )
	end
	
	if( self.Weapon:GetNetworkedBool( "reload", false ) == true ) then
		return;
	end	
	
	if( CLIENT and self.MultipleFiremodes and self.Firemode != self.Weapon:GetNetworkedInt( "Firemode", 1 ) ) then
		self:InstallFiremode( self.Weapon:GetNetworkedInt( "Firemode", 1 ) ); -- sync up
	end
	
	if( /*self:CanPrimaryAttack() and*/ CurTime() >= self.NextIdleTime and self.PlayIdleAnim ) then
		self:IdleThink();
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

function SWEP:IdleThink()
	
	if( self:NeedsPump() and self.RequiresPump ) then
		self:Pump()
		return;
	end
	
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

function SWEP:GetAccuracyModifier( )

	if( self.Owner:IsNPC() ) then
		return 0.8;
	end
	
	local LastAccuracy = self.LastAccuracy or 0;
	local Accuracy = 1.0;
	local LastShoot = self.LastAttack or 0;
	
	local speed = self.Owner:GetVelocity():Length()
	local speedperc = math.Clamp( math.abs( speed / 300 ), 0, 1 );	
	
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
		//Accuracy = Accuracy * ( ( ( 1 - speedperc ) + 0.1 ) / 1.5 );
		Accuracy = Accuracy / 2.5;
	end
	
	if( self.Owner:KeyDown( IN_DUCK ) == true ) then -- ducking moving forward
		Accuracy = Accuracy * 1.50;
	end

	if( self.Owner:KeyDown( IN_LEFT ) or self.Owner:KeyDown( IN_RIGHT ) ) then -- just strafing
		Accuracy = Accuracy * 0.95;
	end
	
	if( LastAccuracy != 0 ) then
		if( Accuracy > LastAccuracy ) then
			Accuracy = math.Approach( self.LastAccuracy, Accuracy, FrameTime() )
		else
			Accuracy = math.Approach( self.LastAccuracy, Accuracy, FrameTime() * -2 )
		end
	end
	
	self.LastAccuracy = Accuracy;
	return Accuracy * 2.5;
	
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

function SWEP:IsIronsighted() -- fully
	if( self.fIronTime != 0 && self.Weapon:GetNetworkedBool( "Ironsights", false ) == true && CurTime() >= self.fIronTime + self.IronsightTime ) then
		return true;
	end
	
	return false;
end

function SWEP:IsIronsighting() -- partially and fully
	return self.Weapon:GetNetworkedBool( "Ironsights", false );
end

function SWEP:SetIronsights( b )

	if( self.HasIronsights == true and self.Owner and b != self.Weapon:GetNetworkedBool( "Ironsights", false ) ) then
		if( SERVER ) then
			if( b == true ) then
				if( self.IronsightDelayFOV ) then
					local delay = self.IronsightTime or 0.25;
					timer.Simple( delay, self.SetFOV, self, self.IronsightsFOV, 0, true );
				else
					self.Owner:SetFOV( self.IronsightsFOV, self.IronsightTime );
				end
			else
				self.Owner:SetFOV( 0, self.IronsightTime );
				self.fIronTime = 0;
			end
		end
		
		self.Weapon:SetNetworkedBool( "Ironsights", b )
		self.fIronTime = CurTime();
	end

end

function SWEP:ToggleIronsights( )
	local is = self.Weapon:GetNetworkedBool( "Ironsights" )
	self.Weapon:SetIronsights( !is );
end

function SWEP:SecondaryAttack()
	if( !self.CanRunAndShoot && self.Weapon:GetNetworkedBool( "RunningAnims", false ) == true )then return end

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
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )

	if SERVER then
		self.Weapon:ToggleIronsights( !self.Owner:GetNWBool( "Ironsights", false ) )
	end
end




