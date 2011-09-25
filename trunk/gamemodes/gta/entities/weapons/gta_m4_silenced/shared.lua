if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "ar2"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "M4A1"
	SWEP.IconLetter = "w"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_m4_silenced", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "gta_base"

SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModel = "models/weapons/v_rif_m4a1.mdl"

SWEP.IronSightsPos = Vector( 6.024, 0.4309, 0.8493 )
SWEP.IronSightsAng = Vector( 3.028, 1.3759, 3.5968 )

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_M4A1.Silenced" )
SWEP.Primary.Recoil         = 3.0
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.100
SWEP.Primary.ShellType      = SHELL_762NATO

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true

function SWEP:Deploy()

	if SERVER then
		self.Weapon:ToggleIronsights( false )
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW_SILENCED )
	
	return true
	
end  

function SWEP:Reload()
	
	if SERVER then
		self.Weapon:ToggleIronsights( false )
	end	

	self.Weapon:DefaultReload( ACT_VM_RELOAD_SILENCED )
	
end

function SWEP:CanPrimaryAttack()

	if self.Weapon:Clip1() <= 0 then
	
		self.Weapon:ToggleIronsights( false )
		self.Weapon:DefaultReload( ACT_VM_RELOAD_SILENCED )
		return false
		
	end
	
	return true
	
end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_SILENCED ) 
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = aimcone * 2
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		scale = math.Clamp( aimcone / 1.2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= math.Round(damage * 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		self:BulletCallback(  attacker, tr, dmginfo, 0 )
	end
	
	self.Owner:FireBullets( bullet )
	
end