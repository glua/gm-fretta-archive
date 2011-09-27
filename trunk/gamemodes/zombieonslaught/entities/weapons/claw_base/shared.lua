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
	
	SWEP.PrintName = "Claws"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	end
	
	surface.CreateFont( "csd", 28, 400, true, false, "ZombieCrosshair" )
	
end

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
	
SWEP.HoldType = "slam"

SWEP.Primary.Voice          = Sound("npc/zombie/zo_attack1.wav")
SWEP.Primary.Sound			= Sound("npc/zombie/claw_miss1.wav")
SWEP.Primary.Hit            = Sound("npc/zombie/claw_strike1.wav")
SWEP.Primary.Damage			= 50
SWEP.Primary.HitForce       = 100
SWEP.Primary.Delay			= 0.15
SWEP.Primary.FreezeTime     = 0
SWEP.Primary.Automatic		= false

SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip    = 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()

	if SERVER then
		self.Owner:DrawWorldModel( false )
	end
	
	self.Weapon:SetVar( "NextHit", 0 )

	return true
	
end  

function SWEP:Think()	

	if self.Weapon:GetVar( "NextHit", 0 ) > 0 and self.Weapon:GetVar( "NextHit", 0 ) < CurTime() then
	
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
		self.Weapon:SetVar( "NextHit", 0 )
		self.Weapon:MeleeTrace( self.Primary.Damage )
		
		if SERVER then
			self.Owner:SetMoveType( MOVETYPE_WALK )
		end
		
	end
end

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()

	return true
	
end

function SWEP:PrimaryAttack()

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Voice, 100, math.random(90,100) )
	
	if self.Primary.FreezeTime > 0 then
	
		if SERVER then
			self.Owner:SetMoveType( MOVETYPE_NONE )
		end
		
		self.Weapon:SetVar( "NextHit", CurTime() + self.Primary.FreezeTime )
		
	else
	
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
		self.Weapon:MeleeTrace( self.Primary.Damage )
		
	end
	
end

function SWEP:MeleeTrace( dmg )
	
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
		
		ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
		ent:TakeDamage( dmg, self.Owner, self.Weapon )
		
		if !ent:IsPlayer() then 
			
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
	util.Effect( "playerhit", ed, true, true )

end

function SWEP:CanSecondaryAttack()

	return false

end

function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()
	
	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	
	if not tr.Entity or not tr.Entity:IsPlayer() then return end
	
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	
	draw.SimpleText( self.IconLetter, "ZombieCrosshair", x, y, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
	
end
