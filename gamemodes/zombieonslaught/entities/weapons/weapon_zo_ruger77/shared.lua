if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Ruger 77"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "B"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_ruger77", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "zo_base"
	
SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel	= "models/weapons/w_shot_xm1014.mdl"

SWEP.IronSightsPos = Vector (5.1476, -4.3763, 2.1642)
SWEP.IronSightsAng = Vector (-0.1387, 0.6955, 0)

SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound("Weapon_Scout.Single")
SWEP.Primary.Damage			= 90
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 8.5
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.700

SWEP.Primary.ClipSize		= 4
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "Buckshot"

SWEP.Primary.ShellType      = SHELL_50CAL

function SWEP:Deploy()

	self.Weapon:SetNWBool( "Reloading", false )

	if SERVER then
		self.Weapon:ToggleIronsights( false )
		self.Owner:SetCurrentAmmo( self.Primary.AmmoType )
	end	

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	
	return true
	
end  

function SWEP:CanPrimaryAttack()

	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then
		
		self.Weapon:EmitSound( self.Primary.Empty, 100, math.random(90,110) )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return false
		
	end

	if self.Weapon:Clip1() <= 0 then
	
		if SERVER then
			self.Weapon:ToggleIronsights( false )
		end
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
		
		return false
		
	end
	
	return true
	
end

function SWEP:SecondaryAttack()

	if self.Owner:KeyDown(IN_SPEED) and self.Owner:GetVelocity():Length() != 0 then return end
	
	if self.Weapon:GetNWBool( "Reloading", false ) then return end

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )

	if SERVER then
		self.Weapon:ToggleIronsights( !self.Owner:GetNWBool( "Ironsights", false ) )
	end

end

function SWEP:Reload()

	if self.Weapon:GetNWBool( "Reloading", false ) then return end
	
	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then return end
	
	if self.Weapon:Clip1() < self.Primary.ClipSize then
	
		if SERVER then
			self.Weapon:ToggleIronsights( false )
		end
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
		
	end
	
	return true
	
end

function SWEP:Think()

	if SERVER and self.Owner:KeyDown(IN_SPEED) and self.Owner:GetVelocity():Length() != 0 then
		self.Weapon:ToggleIronsights( false )
	end

	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		if self.Weapon:GetVar( "ReloadTimer", 0 ) < CurTime() then
			
			// Finsished reload
			if self.Weapon:Clip1() >= self.Primary.ClipSize then
			
				self.Weapon:SetNWBool( "Reloading", false )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
				
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				
				return
				
			end
			
			// Next cycle
			self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.4 )
			self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
			
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
			
		end
	end
end