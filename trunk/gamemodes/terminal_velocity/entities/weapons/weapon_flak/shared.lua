
AddCSLuaFile( "shared.lua" )

if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "rpg"
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false

	SWEP.PrintName = "Flak Cannon"
	SWEP.IconLetter = "3"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "HL2MPTypeDeath"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	end
	
	killicon.AddFont( "sent_flak", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "weapon_flak", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.ViewModel		= "models/weapons/v_rpg.mdl"
SWEP.WorldModel		= "models/weapons/w_rocket_launcher.mdl"
SWEP.AnimPrefix		= "rpg"
SWEP.PlaySound      = true
SWEP.Rotation       = 0

SWEP.Primary.Sound          = Sound( "weapons/ar2/ar2_altfire.wav" )
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.800
SWEP.Primary.Hull           = 20
SWEP.Primary.Damage         = 40

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

function SWEP:PrimaryAttack()

	self.Weapon:ShootFlak()

	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

end

function SWEP:Think()

end

function SWEP:SecondaryAttack()

end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				

end

function SWEP:ShootFlak()

	self.Weapon:ShootEffects()

	if CLIENT then return end

	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 90000

	local htr = {}
	htr.start = pos
	htr.endpos = pos + aim
	htr.filter = self.Owner
	htr.mins = Vector( -self.Primary.Hull, -self.Primary.Hull, -self.Primary.Hull )
	htr.maxs = Vector( self.Primary.Hull, self.Primary.Hull, self.Primary.Hull )

	local htrace = util.TraceHull( htr )
	local ent = htrace.Entity
	
	if ValidEntity( ent ) and ent:IsPlayer() and ent:Team() != self.Owner:Team() then
	
		self.Weapon:FlakExplode( ent:GetPos() + VectorRand() * 250 )
	
	else
	
		local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
		local length = tr.HitPos:Distance( self.Owner:GetShootPos() ) * math.Rand( 0.6, 1.0 )
		local pos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * length + VectorRand() * 100
		
		self.Weapon:FlakExplode( pos )
	
	end
	
end

function SWEP:FlakExplode( pos )

	local ed = EffectData()
	ed:SetOrigin( pos )
	util.Effect( "flak_explosion", ed, true, true )
	
	WorldSound( table.Random( GAMEMODE.FlakExplosion ), pos, 100, math.random(90,110) )
	WorldSound( table.Random( GAMEMODE.FlakAmbient ), pos, 100, math.random(90,110) )
	
	util.ScreenShake( pos, math.Rand(3,6), math.Rand(3,6), math.Rand(3,6), 1000 ) 
	util.BlastDamage( self.Weapon, self.Owner, pos, 500, self.Primary.Damage )

end

function SWEP:DrawHUD()
	
	local w, h = ScrW(), ScrH()
	local wh, lh, sh = w * 0.5, h * 0.5, 5
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 90000
	
	local htr = {}
	htr.start = pos
	htr.endpos = pos + aim
	htr.filter = self.Owner
	htr.mins = Vector( -self.Primary.Hull, -self.Primary.Hull, -self.Primary.Hull )
	htr.maxs = Vector( self.Primary.Hull, self.Primary.Hull, self.Primary.Hull )

	local htrace = util.TraceHull( htr )
	local ent = htrace.Entity
	
	if ValidEntity( ent ) and ent:IsPlayer() and ent:Team() != self.Owner:Team() then
	
		surface.SetDrawColor( 255, 0, 0, 255 )
	
	else
	
		surface.SetDrawColor( 255, 255, 255, 255 )
	
	end
	
	surface.DrawLine( wh - sh, lh - sh, wh + sh, lh - sh ) 
	surface.DrawLine( wh - sh, lh + sh, wh + sh, lh + sh ) 
	surface.DrawLine( wh - sh, lh - sh, wh - sh, lh + sh ) 
	surface.DrawLine( wh + sh, lh - sh, wh + sh, lh + sh )
	
end

