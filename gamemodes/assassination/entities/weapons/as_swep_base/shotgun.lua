SWEP.SingleReload				= false; -- shotgun style reload
SWEP.ReloadDelay				= 0.3;
SWEP.ReloadThenPump				= true;
SWEP.NeedsPumpAfterReload		= false; // needed for HL2 shotgun

function SWEP:NeedsPump()
	return self.Weapon:GetNWBool( "NeedsPump", false );
end

function SWEP:Pump()
	self.Weapon:SetNWBool( "NeedsPump", false );
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP );
	
	if( self.Owner and self.Owner:GetViewModel() ) then
		self.NextIdleTime = CurTime() + self.Owner:GetViewModel():SequenceDuration();
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() );
	else
		self.NextIdleTime = CurTime() + 0.5	
	end
	
	if( self.PumpSound ) then
		self.Weapon:EmitSound( self.PumpSound );
	end
end

function SWEP:ShotgunReloadStart()

	if( CurTime() < self.NextPrimaryFire or 0 ) then return end
	
	if( self.Weapon:GetNetworkedBool( "reload", false ) == false and self.Owner:GetAmmoCount( self.Primary.Ammo ) >= 0 and self.Weapon:Clip1() < self.Primary.ClipSize ) then
		self.BurstQueue = 0;
		self.BurstAmount = 0;
		
		self:SetIronsights( false );
		self.Weapon:SetNetworkedBool( "reload", true );
		
		if( self.Weapon:Clip1() > 0 ) then
			self.Weapon:SetNetworkedFloat( "nextreload", CurTime() );
			self.Weapon:SetNetworkedBool( "chambered", true );
		else
			self.Weapon:SetNetworkedFloat( "nextreload", CurTime() + self.ReloadDelay );
			self.Weapon:SetNetworkedBool( "chambered", false );
		end
	end
end

function SWEP:ShotgunReloadThink( )

	// unironsight if sprinting
	if( self.Weapon:GetNetworkedBool( "Ironsights" ) == true and self.Owner:KeyDown( IN_SPEED ) ) then
		self:SetIronsights( false );
		
	// interrupt reload with primary fire
	elseif( self.Owner and self.Owner:IsPlayer() and self.Owner:KeyPressed( IN_ATTACK ) and self.Weapon:Clip1() > 0 and self.Weapon:GetNetworkedBool( "reload", false ) == true ) then
		self.Weapon:SetNetworkedBool( "finishreload", true ); -- reload interrupt
		self.Weapon:SetNextPrimaryFire( CurTime() + self.ReloadDelay );
		
	// end of reload sequence
	elseif( self.Weapon:GetNetworkedBool( "finishreload", false ) == true and CurTime() >= self.Weapon:GetNetworkedFloat( "nextreload", 0 ) ) then
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH );
		self.Weapon:SetNetworkedBool( "reload", false );
		self.Weapon:SetNetworkedBool( "finishreload", false );
		self.Weapon:SetNextPrimaryFire( CurTime() + self.ReloadDelay );

		if( self.Owner and self.Owner:GetViewModel() ) then
			self.NextIdleTime = CurTime() + self.Owner:GetViewModel():SequenceDuration();
		else
			self.NextIdleTime = CurTime() + 0.5	
		end
	
		self.Weapon:SetNWBool( "NeedsPump", self.NeedsPumpAfterReload );
		self.Owner:SetAnimation( PLAYER_RELOAD );
		
	// feed it a shell
	elseif( self.Weapon:GetNetworkedBool( "reload", false ) == true and CurTime() >= self.Weapon:GetNetworkedFloat( "nextreload", 0 ) ) then
		
		local chambered = self.Weapon:GetNetworkedBool( "chambered", false );
		local clipsize = self.Primary.ClipSize;
		
		if( chambered ) then
			clipsize = clipsize + 1;
		end
		
		if( self.Weapon:Clip1() >= clipsize ) then
			self.Weapon:SetNetworkedBool( "reload", false );
			return;
		end
		
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD );
		self.Owner:SetAnimation( PLAYER_RELOAD );
	
		if( self.ReloadSound ) then
			self.Weapon:EmitSound( self.ReloadSound );
		end
		
		self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
		self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		
		self.Weapon:SetNetworkedFloat( "nextreload", CurTime() + self.ReloadDelay );
		
		if( self.Weapon:Clip1() >= clipsize ) then
			if( self.ReloadThenPump == true ) then
				self.Weapon:SetNetworkedBool( "finishreload", true );
				self.Weapon:SetNextPrimaryFire( CurTime() + self.ReloadDelay );
			else
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH );
				self.Owner:SetAnimation( PLAYER_RELOAD );
			end
		end
	end
	
end

function SWEP:ReloadThink()

	if( self.Weapon:GetNetworkedBool( "reload", false ) == true ) then
		if( CurTime() >= self.Weapon:GetNetworkedFloat( "reloadfinishtime" ) ) then
			self.Weapon:FinishReload();
		end
	end
	
end

function SWEP:CustomReload( seq )

	if( CurTime() < self.NextPrimaryFire ) then return end
	if( self.Weapon:Clip1() >= self.Primary.ClipSize ) then return end
	
	local speed = self.Primary.ReloadSpeed or 1;
	
	if( self.Primary.ReloadSound ) then
		self.Weapon:EmitSound( self.Primary.ReloadSound )
	end
	
	self.Weapon:SetNetworkedBool( "reload", true );
	self.Weapon:SendWeaponAnim( seq );
	
	local vm = self.Owner:GetViewModel();
	local delay = CurTime() + ( 3 / speed );
	
	if( vm && speed != 1 ) then
		vm:SetPlaybackRate( speed );
	end
	
	if( vm and vm:IsValid() ) then
		delay = CurTime() + ( vm:SequenceDuration() / speed );
	end
	
	self.BurstQueue = 0;
	self.BurstAmount = 0;
		
	self.Weapon:SetNetworkedFloat( "reloadfinishtime", delay );
	self.Weapon:SetNextPrimaryFire( delay );
	
	self.Owner:SetAnimation( PLAYER_RELOAD );
	self:SetIronsights( false );
end

function SWEP:DoAmmo()

	self.Weapon:SetNetworkedBool( "reload", false );
	
	if( self.Weapon:Clip1() > 0 ) then
		self.Weapon:SetClip1( self.Primary.ClipSize + 1 )
	else
		self.Weapon:SetClip1( self.Primary.ClipSize )
	end
	
end

function SWEP:FinishReload()

	self.Weapon:DoAmmo( );
end
