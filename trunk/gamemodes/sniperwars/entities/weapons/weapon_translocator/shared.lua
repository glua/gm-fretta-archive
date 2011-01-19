if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "slam"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Translocator"
	SWEP.IconLetter = "H"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	
end

SWEP.Base = "sniper_base"

SWEP.ViewModel	= "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.SprintPos = Vector(0,0,0)
SWEP.SprintAng = Vector(0,0,0)

SWEP.Primary.Sound			= Sound("ambient/machines/teleport3.wav")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 1.500

SWEP.Primary.ClipSize		= 100
SWEP.Primary.Automatic		= false

SWEP.LoadTime = 0

function SWEP:TeleportTrace()
	
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start + self.Owner:GetAimVector() * 3000
	tr.filter = self.Owner
	tr = util.TraceLine( tr )

	return tr.HitPos + tr.HitNormal * 150
	
end
	
function SWEP:Deploy()

	if SERVER then
		self.Weapon:SetViewModelPosition()
		self.Weapon:SetZoomMode(1)
		self.Owner:DrawViewModel( true )
	end	
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
	
end 

function SWEP:Think()	

	if self.Owner:KeyDown( IN_SPEED ) then
		self.LastRunFrame = CurTime() + 0.3
	end
	
	if self.LoadTime < CurTime() and self.Weapon:Clip1() < 100 then
	
		self.LoadTime = CurTime() + 1.5
		self.Weapon:SetClip1( self.Weapon:Clip1() + 10 )
		
	end
	
end

function SWEP:Reload()

end

function SWEP:CanPrimaryAttack()

	if self.Owner:KeyDown(IN_SPEED) or self.LastRunFrame > CurTime() then
		return false
	end

	if self.Weapon:Clip1() < 100 then
		return false
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self.Weapon:EmitSound( self.Primary.Sound )
	self.Weapon:TakePrimaryAmmo( 100 )
	
	self.LoadTime = CurTime() + 0.5
	
	if SERVER then
	
		local ed = EffectData()
		ed:SetEntity( self.Owner:GetPos() )
		util.Effect( "teleport_flash", ed, true, true )
		
		self.Owner:SetPos( self.Weapon:TeleportTrace() )
	
	end

end

function SWEP:SecondaryAttack()
	
end

function SWEP:DrawHUD()
	
	local w = ScrW()
	local h = ScrH()
	
	local wh, lh, sh = w*.5, h*.5, 4
		
	surface.SetDrawColor( CrossRed:GetInt(), CrossGreen:GetInt(), CrossBlue:GetInt(), CrossAlpha:GetInt() )
	surface.DrawLine(wh - sh, lh - sh, wh + sh, lh - sh) //top line
	surface.DrawLine(wh - sh, lh + sh, wh + sh, lh + sh) //bottom line
	surface.DrawLine(wh - sh, lh - sh, wh - sh, lh + sh) //left line
	surface.DrawLine(wh + sh, lh - sh, wh + sh, lh + sh) //right line
	
end


