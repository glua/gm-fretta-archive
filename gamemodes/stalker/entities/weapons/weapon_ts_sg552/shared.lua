if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "ar2"

end

if ( CLIENT ) then

	SWEP.ViewModelFOV = 70
	
	SWEP.PrintName = "SG-552"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.IconLetter = "A"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_ts_sg552", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "ts_base"

SWEP.ViewModel			= "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_sg552.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_SG552.Single" )
SWEP.Primary.Zoom           = Sound( "weapons/sniper/sniper_zoomout.wav" )
SWEP.Primary.Damage			= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.4
SWEP.Primary.Cone			= 0.008
SWEP.Primary.Delay			= 0.180

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.AmmoType		= "Rifle"

SWEP.Primary.ShellType      = SHELL_556

SWEP.ZoomFOV = 50
SWEP.Zoom = false

function SWEP:Reload()
	
	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then return end

	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	
	if SERVER then
		self.Owner:SetFOV( 0, 0.3 )
		self.Zoom = false
	end
	
end

function SWEP:CanPrimaryAttack()

	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then
		
		self.Weapon:EmitSound( self.Primary.Empty, 100, math.random(100,110) )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return false
		
	end

	if self.Weapon:Clip1() <= 0 then
	
		if SERVER then
			self.Owner:SetFOV( 0, 0.3 )
			self.Zoom = false
		end
	
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		return false
		
	end
	
	return true
	
end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
	
	if SERVER then
	
		self.Zoom = !self.Zoom
		
		if !self.Zoom then
			self.Owner:SetFOV( 0, 0.3 )
			self.Owner:EmitSound( self.Primary.Zoom, 100, 150 )
		else
			self.Owner:SetFOV( self.ZoomFOV, 0.3 )
			self.Owner:EmitSound( self.Primary.Zoom )
		end
		
	end

end