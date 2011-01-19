
if (SERVER) then
   AddCSLuaFile ("shared.lua")
end

SWEP.Base	   = "gmdm_base"
SWEP.PrintName = "SWARE Projectile Crowbar"
SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel		= "models/weapons/v_crowbar.mdl"		
SWEP.WorldModel		= "models/weapons/w_crowbar.mdl"

SWEP.HoldType = "pistol"

SWEP.ShootSound = Sound ("weapons/slam/throw.wav")

SWEP.RunArmAngle  = Angle( 70, 0, 0 )
SWEP.RunArmOffset = Vector( 25, 4, 0 )
SWEP.Delay = 0.3
SWEP.TickDelay = 0.1

SWEP.ProjectileEntity = "swent_crowbar"
SWEP.ProjectileForce = 100000

function SWEP:ThrowCrowbar(shotPower)
	local tr = self.Owner:GetEyeTrace()

	if (not SERVER) then return end

	local ent = ents.Create ( self.ProjectileEntity )	

	local Forward = self.Owner:EyeAngles():Forward()
	ent:SetPos( self.Owner:GetShootPos() + Forward * 16 )
	ent:SetAngles(self.Owner:EyeAngles())
	ent:Spawn()
	ent:SetOwner(self.Owner)
	ent:Activate()
	
	local trail_entity = util.SpriteTrail( ent,  --Entity
											0,  --iAttachmentID
											Color( 255, 255, 255, 92 ),  --Color
											false, -- bAdditive
											0.7, --fStartWidth
											1.2, --fEndWidth
											0.4, --fLifetime
											1 / ((0.7+1.2) * 0.5), --fTextureRes
											"trails/physbeam.vmt" ) --strTexture
	
	local phys = ent:GetPhysicsObject()
	phys:ApplyForceCenter (self.Owner:GetAimVector():GetNormalized() * shotPower)
end


SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.TickDelay )
	
	if ( not self:CanShootWeapon() ) then return end
	
	self.Weapon:EmitSound(self.ShootSound)
	
	if (CLIENT) then return end
	
	self:ThrowCrowbar( self.ProjectileForce )
	self.Owner:StripWeapon( "sware_crowbar" )
end


SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:SecondaryAttack()
end
