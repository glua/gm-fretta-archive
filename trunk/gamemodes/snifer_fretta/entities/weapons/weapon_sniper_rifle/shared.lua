

// Variables that are used on both client and server

SWEP.Author         = "Dave"
SWEP.Contact        = "dave@sp4m.net"
SWEP.Purpose        = "Shooting people"
SWEP.Instructions   = "Pull trigger to become murderer"

SWEP.ViewModelFOV   = 62
SWEP.ViewModelFlip  = true
SWEP.ViewModel      = "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel     = "models/weapons/w_snip_awp.mdl"
SWEP.AnimPrefix     = "python"
self.HoldType			= "crossbow"


SWEP.Spawnable          = false
SWEP.AdminSpawnable     = true

SWEP.Primary.ClipSize       = -1                 // Size of a clip
SWEP.Primary.DefaultClip    = -1                // Default number of bullets in a clip
SWEP.Primary.Automatic      = false             // Automatic/Semi Auto
SWEP.Primary.Ammo           = "None"

SWEP.Secondary.ClipSize     = -1                 // Size of a clip
SWEP.Secondary.DefaultClip  = -1                // Default number of bullets in a clip
SWEP.Secondary.Automatic    = false             // Automatic/Semi Auto
SWEP.Secondary.Ammo         = "None"



/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
    self.zooming = false
    self.zoom = 0.0
	self:SetWeaponHoldType( self.HoldType )
end

/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end


/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
    self.Weapon:EmitSound("Weapon_AWP.Single")
    self:ShootBullet(1000, 1, (1.0 - self.zoom) * 0.25) // super-accurate super-damage super-shot of super-justice
    self.Owner:ViewPunch(Angle(-10, 0, 0)) // recoil
    self.Weapon:SetNextPrimaryFire(CurTime() + 1.2) // wait 1.2s between shots
end


/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/

function SWEP:SecondaryAttack()
    self.Weapon:EmitSound("weapons/zoom.wav")
    if CLIENT and (not IsFirstTimePredicted()) then return end
    self.zooming = not self.zooming
end

/*---------------------------------------------------------
   Name: SWEP:CheckReload( )
   Desc: CheckReload
---------------------------------------------------------*/
function SWEP:CheckReload()

end

/*---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
---------------------------------------------------------*/
function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
end


/*---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
---------------------------------------------------------*/
function SWEP:Think()
    local end_zoom
    if self.zooming then
        end_zoom = 1.0
    else
        end_zoom = 0.0
    end
    local halflife = 0.05
    local time = CurTime()
    if not self.last_time then self.last_time = time end
    local t = math.pow(0.5, (time - self.last_time) / halflife)
    self.last_time = time
    self.zoom = (self.zoom * t) + (end_zoom * (1.0 - t))
end


/*---------------------------------------------------------
   Name: SWEP:Holster( weapon_to_swap_to )
   Desc: Weapon wants to holster
   RetV: Return true to allow the weapon to holster
---------------------------------------------------------*/
function SWEP:Holster( wep )
    return true
end

/*---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
---------------------------------------------------------*/
function SWEP:Deploy()
    self.zooming = false
    self.zoom = 0.0
    return true
end


/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootEffects()

    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )      // View model animation
    self.Owner:MuzzleFlash()                                // Crappy muzzle light
    self.Owner:SetAnimation( PLAYER_ATTACK1 )               // 3rd Person Animation

end


/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootBullet( damage, num_bullets, aimcone )

    local bullet = {}
    bullet.Num      = num_bullets
    bullet.Src      = self.Owner:GetShootPos()          // Source
    bullet.Dir      = self.Owner:GetAimVector()         // Dir of bullet
    bullet.Spread   = Vector( aimcone, aimcone, 0 )     // Aim Cone
    bullet.Tracer   = 1                                 // Show a tracer on every x bullets
    bullet.Force    = 10                                 // Amount of force to give to phys objects
    bullet.Damage   = damage
    bullet.AmmoType = "Pistol"

    self.Owner:FireBullets( bullet )

    self:ShootEffects()

end


/*---------------------------------------------------------
   Name: ContextScreenClick(  aimvec, mousecode, pressed, ply )
---------------------------------------------------------*/
function SWEP:ContextScreenClick( aimvec, mousecode, pressed, ply )
end


/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function SWEP:OnRemove()
end


/*---------------------------------------------------------
   Name: OwnerChanged
   Desc: When weapon is dropped or picked up by a new player
---------------------------------------------------------*/
function SWEP:OwnerChanged()
end


/*---------------------------------------------------------
   Name: Ammo1
   Desc: Returns how much of ammo1 the player has
---------------------------------------------------------*/
function SWEP:Ammo1()
    return self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )
end


/*---------------------------------------------------------
   Name: Ammo2
   Desc: Returns how much of ammo2 the player has
---------------------------------------------------------*/
function SWEP:Ammo2()
    return self.Owner:GetAmmoCount( self.Weapon:GetSecondaryAmmoType() )
end

/*---------------------------------------------------------
   Name: SetDeploySpeed
   Desc: Sets the weapon deploy speed.
         This value needs to match on client and server.
---------------------------------------------------------*/
function SWEP:SetDeploySpeed( speed )
    self.m_WeaponDeploySpeed = tonumber( speed )
end
