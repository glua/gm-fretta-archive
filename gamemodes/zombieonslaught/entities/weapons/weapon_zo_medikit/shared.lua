
if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "slam"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Medikit"
	SWEP.IconLetter = "F"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.Base = "claw_base"

SWEP.ViewModel	= "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_package.mdl" 

SWEP.Primary.Sound			= Sound("items/nvg_off.wav")
SWEP.Primary.Hit            = Sound("physics/flesh/flesh_impact_bullet1.wav")
SWEP.Primary.Damage			= 0
SWEP.Primary.HitForce       = 0
SWEP.Primary.Delay			= 25.0
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
	
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 50
	
	local tr = {}
	tr.start = pos
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mins = Vector(-16,-16,-16)
	tr.maxs = Vector(16,16,16)

	local trace = util.TraceHull( tr )
	local ent = trace.Entity

	if not ValidEntity( ent ) or not ent:IsPlayer() then 
		
		self.Owner:Heal( 10 )
		self.Owner:NeutralizePoison()
		return 
		
	else
		
		ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
		ent:Heal( 20 )
		
		local pts = 1	
		
		if ent:Health() < 20 then
			pts = pts + 1
		end
		
		if ent:IsPoisoned() then
			pts = pts + 1
			self.Owner:AddSupport()
			ent:NeutralizePoison()
		end
		
		self.Owner:AddSupport()
		self.Owner:AddBones( pts )
		
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