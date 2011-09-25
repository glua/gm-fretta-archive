
AddCSLuaFile( "shared.lua" )

if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false

	SWEP.PrintName = "Mini Nukes"
	SWEP.IconLetter = "4"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "HL2MPTypeDeath"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	end
	
	killicon.AddFont( "sent_dropbomb", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "weapon_dropbomb", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= ""

SWEP.Primary.Sound          = Sound("buttons/button4.wav")
SWEP.Primary.Reload         = Sound("buttons/button5.wav")
SWEP.Primary.Drop           = Sound("npc/scanner/cbot_discharge1.wav")
SWEP.Primary.DropWait       = 0.5
SWEP.Primary.Delay			= 6.0

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

function SWEP:PrimaryAttack()

	if self.Delay and self.Delay > CurTime() then return end
	
	self.Weapon:EmitSound( self.Primary.Sound, 100, 120 )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay + self.Primary.DropWait )
	self.Delay = CurTime() + self.Primary.DropWait
	self.ReloadTime = CurTime() + self.Primary.Delay - self.Primary.DropWait
	
end

function SWEP:Think()

	if CLIENT then return end
	
	if self.Delay and self.Delay < CurTime() then
	
		self.Weapon:DropBomb()
		self.Owner:EmitSound( self.Primary.Drop, 100, 120 )
		self.Delay = nil
	
	end
	
	if self.ReloadTime and self.ReloadTime < CurTime() then
	
		self.Owner:EmitSound( self.Primary.Reload, 100, 80 )
		self.ReloadTime = nil
	
	end

end

function SWEP:SecondaryAttack()

end

function SWEP:DropBomb()

	local ent = ents.Create( "sent_dropbomb" )
	ent:SetOwner( self.Owner )
	ent:SetPos( self.Owner:GetPos() + self.Owner:GetUp() * -10 )
	ent:SetAngles( self.Owner:GetAimVector():Angle() + Angle(90,0,0) )
	ent:Spawn()
	
end

function SWEP:DrawHUD()
	
	local w, h = ScrW(), ScrH()
	local wh, lh, sh = w * 0.5, h * 0.5, 5
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.DrawLine( wh - sh, lh - sh, wh + sh, lh - sh ) 
	surface.DrawLine( wh - sh, lh + sh, wh + sh, lh + sh ) 
	surface.DrawLine( wh - sh, lh - sh, wh - sh, lh + sh ) 
	surface.DrawLine( wh + sh, lh - sh, wh + sh, lh + sh )
	
end
