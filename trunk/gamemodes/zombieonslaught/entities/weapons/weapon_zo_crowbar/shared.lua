
if SERVER then
	
	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 50
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Crowbar"
	SWEP.IconLetter = "6"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "HL2MPTypeDeath"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end

	
end

SWEP.Base = "claw_base"
	
SWEP.HoldType = "melee"

SWEP.ViewModel	= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.Sound			= Sound("Weapon_Crowbar.Single")
SWEP.Primary.Hit            = Sound("physics/flesh/flesh_impact_bullet1.wav")
SWEP.Primary.HitWorld       = Sound("weapons/crowbar/crowbar_impact1.wav")
SWEP.Primary.Damage			= 40
SWEP.Primary.HitForce       = 500
SWEP.Primary.Delay			= 1.00
SWEP.Primary.Automatic		= true

function SWEP:Deploy()

	return true
	
end  

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:MeleeTrace( self.Primary.Damage )
	
end

function SWEP:MeleeTrace( dmg )
	
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	
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

	if not ValidEntity( ent ) then 
		
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
		return 
		
	else
	
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		
		ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
		ent:TakeDamage( dmg, self.Owner, self.Weapon )
		
		if !ent:IsPlayer() and not string.find( ent:GetClass(), "npc" ) then 
		
			ent:EmitSound( self.Primary.HitWorld, 100, math.random(90,110) )
			
			local phys = ent:GetPhysicsObject()
			
			if ValidEntity( phys ) then
			
				ent:SetPhysicsAttacker( self.Owner )
				phys:Wake()
				phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * self.Primary.HitForce )
				
			end
			
			return 
			
		end
		
	end
	
	if ent:Team() == TEAM_DEAD then return end
	
	local ed = EffectData()
	ed:SetEntity( ent )
	ed:SetOrigin( ent:GetPos() + Vector(0,0,40) )
	util.Effect( "bodyshot", ed, true, true )

end

function SWEP:GetViewModelPosition( pos, ang )

	local Offset = Vector (-2.5252, -2.602, -6.0112)
	local Ang = Vector (0, 0, -12.2141)
	
	ang:RotateAroundAxis( ang:Right(), Ang.x )
	ang:RotateAroundAxis( ang:Up(), Ang.y )
	ang:RotateAroundAxis( ang:Forward(), Ang.z )
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	pos = pos + Offset.x * Right 
	pos = pos + Offset.y * ang:Forward() 
	pos = pos + Offset.z * Up 
	
	return pos, ang
	
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