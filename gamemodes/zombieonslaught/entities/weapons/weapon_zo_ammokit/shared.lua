
if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Ammo Kit"
	SWEP.IconLetter = "W"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.Base = "claw_base"
	
SWEP.HoldType = "slam"

SWEP.ViewModel	= "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.Primary.SelfGive		= Sound("buttons/weapon_confirm.wav")
SWEP.Primary.PlyGive        = Sound("weapons/c4/c4_disarm.wav")
SWEP.Primary.Damage			= 0
SWEP.Primary.HitForce       = 0
SWEP.Primary.Delay			= 15.0
SWEP.Primary.Automatic		= true

function SWEP:PrimaryAttack()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetVar( "AnimTime", CurTime() + self.Primary.Delay )
	
	self.Weapon:MeleeTrace()
	
end

function SWEP:Deploy()

	if self.Weapon:GetVar( "AnimTime", 0 ) > CurTime() then
		self.Weapon:SendWeaponAnim(	ACT_VM_SECONDARYATTACK )
	else
		self.Weapon:SendWeaponAnim(	ACT_VM_DRAW )
	end
	
	return true
	
end

function SWEP:MeleeTrace( dmg )
	
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 40
	local ent = self.Owner:TraceHullAttack( pos, pos + aim, Vector(-16,-16,-16), Vector(16,16,16), 0, DMG_CLUB, 0, false )

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	
	if not ent or not ent:IsValid() or not ent:IsPlayer() then 
		
		self.Owner:EmitSound( self.Primary.SelfGive, 100, math.random(90,110) )
		self.Owner:SupplyAmmo( 0.5 )
		return 
		
	else
		
		ent:SupplyAmmo( 1.0 )
		
		self.Owner:EmitSound( self.Primary.PlyGive, 100, math.random(90,110) )
		self.Owner:AddSupport()
		self.Owner:AddBones( 1 )
		
	end

end

function SWEP:Think()	

	if self.Weapon:GetVar( "AnimTime", 0 ) > 0 and self.Weapon:GetVar( "AnimTime", 0 ) < CurTime() then
	
		self.Weapon:SetVar( "AnimTime", 0 )
		self.Weapon:SendWeaponAnim(	ACT_VM_DRAW	)

	end

end

function SWEP:DrawHUD()

	local w,h = ScrW(),ScrH()
	
	surface.SetDrawColor(255, 255, 255, 255)
	local wh, lh, sh = w*.5, h*.5, 5
	surface.DrawLine(wh - sh, lh - sh, wh + sh, lh - sh) //top line
	surface.DrawLine(wh - sh, lh + sh, wh + sh, lh + sh) //bottom line
	surface.DrawLine(wh - sh, lh - sh, wh - sh, lh + sh) //left line
	surface.DrawLine(wh + sh, lh - sh, wh + sh, lh + sh) //right line
	
end