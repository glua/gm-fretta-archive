if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Bomb"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
	killicon.AddFont( "sent_dynamite", "CSKillIcons", "C", Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType = "slam"
SWEP.ViewModel				= "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel				= "models/weapons/w_eq_fraggrenade.mdl"

SWEP.Primary.Sound          = Sound( "bombtag/kamikaze.wav" )
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )
	
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )

	return true
	
end  

function SWEP:Think()	

	if self.Weapon:GetVar( "YellTime", -1 ) != -1 and self.Weapon:GetVar( "YellTime", -1 ) < CurTime() and SERVER then
	
		self.Weapon:SetVar( "YellTime", -1 )
		self.Owner:EmitSound( self.Primary.Sound )
	
	end

	if self.Weapon:GetVar( "ExplodeTime", -1 ) != -1 and self.Weapon:GetVar( "ExplodeTime", -1 ) < CurTime() and SERVER then
	
		self.Weapon:SetVar( "ExplodeTime", -1 )
		
		if ValidEntity( self.Owner:GetBomb() ) then
			self.Owner:GetBomb():Remove()
			self.Owner:SetBomb()
		end
		
		local ed = EffectData()
		ed:SetOrigin( self.Owner:GetPos() )
		util.Effect( "Explosion", ed, true, true )
		
		util.BlastDamage( self.Weapon, self.Owner, self.Owner:GetPos(), 250, 70 )
	
	end
	
end

function SWEP:Reload()
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 10 )
	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
	self.Weapon:SetVar( "ExplodeTime", CurTime() + 5 )
	self.Weapon:SetVar( "YellTime", CurTime() + 2.5 )
	
end

function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()

end

