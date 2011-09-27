if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then

	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= false

end

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.CanReload = true
SWEP.ReloadActionSet = false
SWEP.MaxEnergy = 40
SWEP.HoldType = "pistol"

SWEP.ShootSound = Sound("weapons/pistol/pistol_fire2.wav")
SWEP.EmptySound = Sound( "buttons/combine_button1.wav" )




/*-------------------------------------
	SWEP:Initialize()
-------------------------------------*/
function SWEP:SetupDataTables()
	self:DTVar( "Int" , 0 , "Energy" )
end

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )


	self.dt.Energy = self.MaxEnergy
	self.Ironsights = false

	self.NextAmmoRegeneration = CurTime()
	self.NextIdleTime = CurTime()
	
	self.ReloadSound  = CreateSound(self, "items/suitcharge1.wav")

	
	if CLIENT then
	
		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels

	end

end



/*-------------------------------------
	SWEP:CanAttack()
-------------------------------------*/
function SWEP:CanAttack(num)
	num = num or 0
    if( self.dt.Energy > num ) then
        return true
    end
    
	
	self:EmitSound( self.EmptySound, 60 )
	
	self:SetNextPrimaryFire( CurTime() + 0.4 )
	self:SetNextSecondaryFire( CurTime() + 0.4)
	
	self.NextAmmoRegeneration = CurTime() + 0.85
		
    return false

end

/*-------------------------------------
	SWEP:PrimaryAttack()
-------------------------------------*/
function SWEP:PrimaryAttack()
	if !self:CanAttack() then return false end

	self:TakeAmmo( 1 )

	// delay ammo regeneration so we don't have
	// infinite ammo while shooting
	self.NextAmmoRegeneration = CurTime() + 0.85

	// shoot bullet
	self:ShootBullet(15,1,0.02)
	
	// shoot effects
	self:ShootEffects()
	

end

/*-------------------------------------
	SWEP:SecondaryAttack()
-------------------------------------*/
function SWEP:SecondaryAttack()

	// bail if we can't fire
	if( !self:CanAttack() ) then return false end

	self:TakeAmmo( 1 )
		
	// delay ammo regeneration so we don't have
	// infinite ammo while shooting
	self.NextAmmoRegeneration = CurTime() + 0.85

	// shoot bullet
	self:ShootBullet(15,1,0.02)

	// shoot effects
	self:ShootEffects()

end

/*-------------------------------------
	SWEP:Reload()
-------------------------------------*/
function SWEP:Reload()
end

/*-------------------------------------
	SWEP:Think()
-------------------------------------*/
function SWEP:Think()

	local amnt = 1


	if( self.NextIdleTime <= CurTime() ) then

		self:SendWeaponAnim( ACT_VM_IDLE )
		self.NextIdleTime = CurTime() + self:SequenceDuration()

	end

	if self.CanReload and self.Owner:KeyDown(IN_RELOAD) then

		if self.Ironsights then
			self:SetIronsights(false)
		end

		if self.dt.Energy < self.MaxEnergy then
			amnt = 2
			self:SetNextPrimaryFire( CurTime() + 0.85 )
			self:SetNextSecondaryFire( CurTime() + 0.85 )
			//self.Owner:SetWalkSpeed(self.Owner:GetPlayerClass().WalkSpeed/3)
			//self.Owner:SetRunSpeed(self.Owner:GetPlayerClass().RunSpeed/3)
			self.ReloadSound:Play()
		else
			//self.Owner:SetWalkSpeed(self.Owner:GetPlayerClass().WalkSpeed)
			//self.Owner:SetRunSpeed(self.Owner:GetPlayerClass().RunSpeed)
			self.ReloadSound:Stop()
		end
		
	elseif self.Ironsights then

		//self.Owner:SetWalkSpeed(self.Owner:GetPlayerClass().WalkSpeed/2)
		//self.Owner:SetRunSpeed(self.Owner:GetPlayerClass().RunSpeed/2)

	else

		//self.Owner:SetWalkSpeed(self.Owner:GetPlayerClass().WalkSpeed)
		//self.Owner:SetRunSpeed(self.Owner:GetPlayerClass().RunSpeed)
		self.ReloadSound:Stop()

	end

	if self.dt.Energy < self.MaxEnergy then
		amnt = 2
	end

	// regenerate energy
	if( self.NextAmmoRegeneration <= CurTime() ) then
		self.dt.Energy = math.min( self.MaxEnergy, self.dt.Energy + amnt )
		self.NextAmmoRegeneration = CurTime() + 0.2

	end

	
end

/*-------------------------------------
	SWEP:ShootEffects()
-------------------------------------*/
function SWEP:ShootEffects(kick)
	
	// sound & animation
	self:EmitSound( self.ShootSound, 85, math.random( 100, 110 ) )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )



	// some view punching to make it not so static.
	kick = kick or Angle(0.5,0.5,0.5)
	self.Owner:ViewPunch( Angle( math.Rand( -kick.p, kick.p ), math.Rand( -kick.y, kick.y ), math.Rand( -kick.r, kick.r ) ) )


	// handle weapon idle times

	self.NextIdleTime = CurTime() + self:SequenceDuration()

	--[[
	local effect = EffectData()
		effect:SetOrigin( self.Owner:GetShootPos() )
		effect:SetEntity( self.Weapon )
		effect:SetAttachment( 1 )
	util.Effect( "NomadMuzzle", effect )
	--]]
end

	
/*-------------------------------------
	SWEP:TakeAmmo()
-------------------------------------*/
function SWEP:TakeAmmo( amt )
	if SERVER then
   		self.dt.Energy = math.max( 0, self.dt.Energy - amt )
   	end

end

/*-------------------------------------
	SWEP:ShootBullet()
-------------------------------------*/
function SWEP:ShootBullet( damage, num_bullets, aimcone )

	if SERVER then self.Owner:LagCompensation( true ) end

	local bullet = {
		Num			= num_bullets,
        Src			= self.Owner:GetShootPos(),
        Dir			= self.Owner:GetAimVector(),
        Spread		= Vector( aimcone, aimcone, 0 ),
        Tracer		= 1,
        Force		= 10,
        Damage		= damage,
        AmmoType	= "Pistol",
        TracerName	= "cb_guntrace",
        Attacker	= self.Owner,
        Inflictor	= self,
        Hull		= HULL_TINY_CENTERED
	}
	self.Weapon:FireBullets( bullet )
	
	if SERVER then self.Owner:LagCompensation( false ) end

end

/*-------------------------------------
	SWEP:SetIronsights()
-------------------------------------*/
function SWEP:SetIronsights( b )

	self.Ironsights = b

end

/*-------------------------------------
	SWEP:Holster()
-------------------------------------*/
function SWEP:Holster()
	
	//if SERVER then
		self.ReloadSound:Stop()
	//end

	if self.Ironsights then
		self:SetIronsights(false)
	end

	return true
	
end

/*-------------------------------------
	SWEP:OnRemove()
-------------------------------------*/
function SWEP:OnRemove()

	//if SERVER then
		self.ReloadSound:Stop()
	//end

	if self.Ironsights then
		self:SetIronsights(false)
	end

	if CLIENT then
		self:RemoveModels()
	end

end
