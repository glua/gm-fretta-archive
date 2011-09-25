
AddCSLuaFile( "shared.lua" )

if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "python"
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false

	SWEP.PrintName = "Twin Machine Gun"
	SWEP.IconLetter = "/"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "HL2MPTypeDeath"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	end
	
	killicon.AddFont( "weapon_twinmachinegun", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pist_elite.mdl"
SWEP.AnimPrefix		= "python"
SWEP.Side           = 1
SWEP.EdgeLength     = 15

SWEP.Primary.Sound          = Sound( "Weapon_SMG1.Single" )
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.100
SWEP.Primary.Damage         = 3

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pist_elite.mdl"

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random( 90, 110 ) )

	self.Weapon:ShootBullet( self.Primary.Damage, self.Primary.NumShots, 15 )
	self.Weapon:ShootBullet( self.Primary.Damage, self.Primary.NumShots, -15 )

end

function SWEP:SecondaryAttack()

end

function SWEP:ShootEffects()

	self.Owner:MuzzleFlash()			

end

function SWEP:ShootBullet( damage, num_bullets, offset )

	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	
	if tr.Entity:IsPlayer() and tr.Entity:Team() != self.Owner:Team() then
		offset = offset / 1.2
	end
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos() + self.Owner:GetRight() * offset
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( 0, 0, 0 )		
	bullet.Tracer	= 1									
	bullet.Force	= 10								
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.HullSize = 2
	
	self.Weapon:SetNWInt( "BulletOffset", offset )
	self.Weapon:ShootEffects()
	
	self.Owner:FireBullets( bullet )
	
end

function SWEP:GetTracerOrigin()

	local ply = self:GetOwner()
	
	if self.Side == 1 then
		self.Side = -1
	else
		self.Side = 1
	end

	return ply:EyePos() + ply:EyeAngles():Right() * ( self.Side * -15 )

end

function SWEP:DrawHUD()

	local w, h = ScrW(), ScrH()
	local wh, lh, sh, dh = w * 0.5, h * 0.5, 5
	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	
	if tr.Entity:IsPlayer() and tr.Entity:Team() != self.Owner:Team() then
	
		self.EdgeLength = math.Approach( self.EdgeLength, 12, 0.2 )
		surface.SetDrawColor( 255, 0, 0, 255 )
		
	else
	
		self.EdgeLength = math.Approach( self.EdgeLength, 15, 0.2 )
		surface.SetDrawColor( 255, 255, 255, 255 )
		
	end
	
	local dh = self.EdgeLength
	
	// left side
	surface.DrawLine( wh - dh, lh - sh, wh + sh - dh, lh - sh ) 
	surface.DrawLine( wh - dh, lh + sh, wh + sh - dh, lh + sh ) 
	surface.DrawLine( wh - dh, lh - sh, wh - dh, lh + sh ) 
	
	// right side
	surface.DrawLine( wh + dh, lh - sh, wh - sh + dh, lh - sh ) 
	surface.DrawLine( wh + dh, lh + sh, wh - sh + dh, lh + sh ) 
	surface.DrawLine( wh + dh, lh - sh, wh + dh, lh + sh ) 
	
end

