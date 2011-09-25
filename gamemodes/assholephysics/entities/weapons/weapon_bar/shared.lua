if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "melee"
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false

	SWEP.PrintName = "Crowbar"
	SWEP.IconLetter = "6"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "HL2MPTypeDeath"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
	killicon.AddFont( "weapon_bar", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.ViewModel		= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel		= "models/weapons/w_crowbar.mdl"

SWEP.Primary.Swing			= Sound( "weapons/iceaxe/iceaxe_swing1.wav" )
SWEP.Primary.FleshHit       = Sound("physics/flesh/flesh_impact_bullet1.wav")
SWEP.Primary.Hit            = { "weapons/crowbar/crowbar_impact1.wav", "weapons/crowbar/crowbar_impact2.wav" }
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.100
SWEP.Primary.Delay			= 0.400
SWEP.Primary.Damage         = 35
SWEP.Primary.HitForce       = 10000

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

function SWEP:Initialize()

	if SERVER then
		self:SetWeaponHoldType( self.HoldType )
	end
	
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
	
end  

function SWEP:SetROF( num )
	self.Primary.Delay = num
end

function SWEP:Think()	

end

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()
	
	return true
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:MeleeTrace( self.Primary.Damage, self.Primary.HitForce )
	
end

function SWEP:MeleeTrace( dmg, force )
	
	self.Weapon:EmitSound( self.Primary.Swing, 100, math.random(90,110) )
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
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
		
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		return 
		
	else
	
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		
		ent:TakeDamage( dmg, self.Owner, self.Weapon )
		
		if !ent:IsPlayer() then 
		
			ent:EmitSound( table.Random( self.Primary.Hit ), 100, math.random(90,110) )
			
			local phys = ent:GetPhysicsObject()
			
			if ValidEntity( phys ) then
				phys:ApplyForceCenter( self.Owner:GetAimVector() * ( force * math.Rand( 1.0, 1.5 ) ) )  
			end
			
			return 
			
		end
		
	end
	
	ent:EmitSound( self.Primary.FleshHit, 100, math.random(90,110) )

end

function SWEP:SecondaryAttack()

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

