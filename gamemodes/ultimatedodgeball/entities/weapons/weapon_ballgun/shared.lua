
if SERVER then

	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if ( CLIENT ) then
	
	SWEP.SwayScale			= 1.25				
	SWEP.BobScale			= 1.25				

	SWEP.ViewModelFOV		= 55
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0

	SWEP.PrintName			= "Ball Launcher"			
	SWEP.IconLetter			= "C"
	SWEP.DrawAmmo 			= true
	SWEP.DrawCrosshair 		= false

	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		
	end    
	
end

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.ShootSound = Sound("weapons/grenade_launcher1.wav")

function SWEP:Initialize()

    if (SERVER) then
		self.Weapon:SetWeaponHoldType( "rpg" )
	end
	
end 

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
end  

function SWEP:DrawHUD()

	local w,h = ScrW(),ScrH()
	
	surface.SetDrawColor(255, 255, 255, 255)
	local wh, lh, sh = w*.5, h*.5, 10
	surface.DrawLine(wh - sh, lh - sh, wh + sh, lh - sh) //top line
	surface.DrawLine(wh - sh, lh + sh, wh + sh, lh + sh) //bottom line
	surface.DrawLine(wh - sh, lh - sh, wh - sh, lh + sh) //left line
	surface.DrawLine(wh + sh, lh - sh, wh + sh, lh + sh) //right line
	
end

function SWEP:SetFireDelay( del )
	self.Weapon:SetNWFloat("Delay",del)
end

function SWEP:SetMaxAmmo( amt )
	self.Weapon:SetNWInt("MaxAmmo",amt)
	self.Weapon:SetClip1(amt)
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Weapon:GetNWFloat("Delay",0.5) )
	
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:EmitSound( self.ShootSound, 100, math.random(90,110) )
	
	if SERVER then
	
		local ball = ents.Create( self.Owner:GetBallType().Class )
		ball:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 25 )
		ball:SetOwner( self.Owner )
		ball:Spawn()
		
	end

end

function SWEP:Think()

	if self.Weapon:Clip1() < 1 then
	
		self.Weapon:SetNextPrimaryFire( CurTime() + 1.7 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:SetClip1( self.Weapon:GetNWInt( "MaxAmmo", 2 ) )
		
	end
end
 
function SWEP:SecondaryAttack()
	
end

