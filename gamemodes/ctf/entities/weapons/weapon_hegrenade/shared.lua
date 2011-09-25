SWEP.CustomSecondaryAmmo = true
SWEP.Base				= "gmdm_csbase"
SWEP.HoldType			= "grenade"
SWEP.PrintName			= "HE Frag Grenade"	
SWEP.Slot				= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= true
SWEP.ViewModel			= "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.ViewModelFlip			= true

SWEP.RunArmOffset 			= Vector( 0, 0, 0 );
SWEP.RunArmAngle			= Angle( 0, 0, 0 );

if( CLIENT ) then
	SWEP.IconLetter			= "h";
	killicon.AddFont( "weapon_hegrenade", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 )  );
	killicon.AddFont( "grenade_frag", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 )  );
end


function SWEP:Precache()
	util.PrecacheModel("models/weapons/w_eq_fraggrenade_thrown.mdl")
end

function SWEP:Initialize( )
	self:GMDMInit()
	self:SetWeaponHoldType( "grenade" )	
end

function SWEP:FirstTimePickup( Owner )
	Owner:AddCustomAmmo( "FragGrenades", 3 )	
end

function SWEP:HasUsableAmmo( )
	return self.Owner:GetCustomAmmo( "FragGrenades" ) > 0
end

function SWEP:PrimaryAttack()
	-- nothing
end

function SWEP:SecondaryAttack()
	-- nothing
end

function SWEP:Deploy()
	if( self:CustomAmmoCount() > 0 ) then
		self.Weapon:SendWeaponAnim(	ACT_VM_DRAW	)
	else
		self.Weapon:SendWeaponAnim(	ACT_VM_THROW )
	end
	
	self.Weapon:SetNetworkedBool( "Throwing", false );
	self.Weapon:SetNetworkedBool( "PlayDeploy", false );
	
	return true
end

function SWEP:Think()

	if( self.Weapon:GetNetworkedBool( "PlayDeploy", false ) == true and CurTime() >= self.Weapon:GetNetworkedFloat( "DeployAnim" ) ) then
		if( self:CustomAmmoCount() > 0 ) then
			self.Weapon:SendWeaponAnim(	ACT_VM_DRAW	)
		end
		
		self.Weapon:SetNetworkedBool( "PlayDeploy", false );
	elseif( self.Owner:KeyDown( IN_ATTACK ) == true and self.Weapon:GetNetworkedBool( "Throwing" ) == true and CurTime() >= ( self.Weapon:GetNetworkedFloat( "MinThrowTime" ) + 5.0 ) ) then
		util.BlastDamage( self.Weapon, self.Owner, self.Owner:GetPos(), 300, 270 );
		
		local effectdata = EffectData();
		effectdata:SetStart( self:GetPos() );
		effectdata:SetOrigin( self:GetPos() );
		effectdata:SetScale( 1 );
		
		util.Effect( "Explosion", effectdata ); 
		self.Weapon:SetNetworkedBool( "Throwing", false );

	elseif( self.Weapon:GetNetworkedBool( "Throwing" ) == false and self.Owner:KeyDown( IN_ATTACK ) and self.Owner:GetCustomAmmo( "FragGrenades" ) > 0 and CurTime() >= self.Weapon:GetNetworkedFloat( "DeployAnim" ) ) then
		self.Weapon:SetNetworkedBool( "Throwing", true );
		self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_HIGH );
		self.Weapon:SetNetworkedFloat( "FuseStart", CurTime() );
		
		if( self.Owner:GetViewModel() ) then
			self.Weapon:SetNetworkedFloat( "MinThrowTime", CurTime() + self.Owner:GetViewModel():SequenceDuration() );
		end
	elseif( self.Weapon:GetNetworkedBool( "Throwing" ) == true and self.Owner:KeyDown( IN_ATTACK ) == false and CurTime() >= self.Weapon:GetNetworkedFloat( "MinThrowTime" ) ) then
		self.Weapon:SendWeaponAnim( ACT_VM_THROW )
		local nadeTimer = 5 - (CurTime() - self.Weapon:GetNetworkedFloat( "MinThrowTime" ) )
		self:ThrowHigh( nadeTimer );
		
		self.Weapon:SetNetworkedBool( "Throwing", false );
	end
end

function SWEP:ThrowHigh( timerz )
	if (SERVER) then
	
		self.Owner:SetAnimation( PLAYER_ATTACK1 );

		local ply = self.Owner
		local grenadeobj = ents.Create("grenade_frag")
		
		grenadeobj:SetPos( ply:GetShootPos() );
		grenadeobj:SetAngles( ply:GetAimVector() );
		grenadeobj:SetKeyValue( "timer", timerz );
		
		grenadeobj:SetOwner( ply );
		grenadeobj:Spawn();
		
		grenadeobj:SetPhysicsAttacker( self.Owner );

		local phys = grenadeobj:GetPhysicsObject();
		
		if( phys and phys:IsValid() ) then
			local Force = ply:GetAimVector() * 4300
			phys:ApplyForceCenter( Force );
		end
		
		if( self:CustomAmmoCount() > 0 and self.Owner:GetViewModel() ) then
			self.Weapon:SetNetworkedFloat( "DeployAnim", CurTime() + self.Owner:GetViewModel():SequenceDuration() );
			self.Weapon:SetNetworkedBool( "PlayDeploy", true );
		end
		
		self.Owner:TakeCustomAmmo( "FragGrenades", 1 )
		self:NoteGMDMShot( )
	end
end 


function SWEP:CustomAmmoCount()

	if ( !ValidEntity( self.Owner ) ) then return 0 end
	return self.Owner:GetCustomAmmo( "FragGrenades" )
	
end 