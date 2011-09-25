//Almost completely written by Rambo_6 - I take no credit. It's a slighly modified manspuncher.
if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "rpg"
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Knockback Cannon"
	SWEP.IconLetter = "3"
	SWEP.Slot = 5
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "HL2MPTypeDeath"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.ViewModel		= "models/weapons/v_RPG.mdl"
SWEP.WorldModel		= "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.Sound			= Sound("weapons/ar2/npc_ar2_altfire.wav")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.780

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	if SERVER then
		self:SetWeaponHoldType( self.HoldType )
	end
	
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
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

	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(110,130) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )	
	
end

function SWEP:SecondaryAttack()

end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	local scale = aimcone
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = aimcone * 1.1
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( aimcone / 2.6, 0, 2 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= 100							
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "punch_tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		if CLIENT then return end
		self.Owner:ViewPunch( Angle( -1, 0, 0))
		if tr.Entity:IsPlayer() then
			tr.Entity:ViewPunch( Angle( -1, 0, 0))
			local vel = self.Owner:GetAimVector() * 50 * tr.Entity:Health()
			tr.Entity:SetVelocity(tr.Entity:GetVelocity() + Vector(0,0,250) + vel )
		end
	end
	
	self.Owner:FireBullets( bullet )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
end

if CLIENT then

	SWEP.CrossRed = CreateClientConVar( "crosshair_r", 255, true, false )
	SWEP.CrossGreen = CreateClientConVar( "crosshair_g", 255, true, false )
	SWEP.CrossBlue = CreateClientConVar( "crosshair_b", 255, true, false )
	SWEP.CrossAlpha = CreateClientConVar( "crosshair_a", 255, true, false )
	SWEP.CrossScale = CreateClientConVar( "crosshair_scale", 1, true, false )

end

SWEP.CrosshairScale = 1
function SWEP:DrawHUD()

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	
	local scale = self.Primary.Cone
	
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = scale * 1.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( scale / 2.6, 0, 2 )
	end
	
	//scale = math.Clamp( ( 10 + ( scale * ( 260 * (ScrH()/720) ) ) ) * self.CrossScale:GetFloat(), 0, (ScrH()/2) - 100 )
	//self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 )
	
	// CAN'T GET THIS TO WORK NICELY
	
	scale = scale * scalebywidth * self.CrossScale:GetFloat()
	
	local dist = math.abs(self.CrosshairScale - scale)
	self.CrosshairScale = math.Approach(self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05)
	
	local gap = 40 * self.CrosshairScale
	local length = gap + 20 * self.CrosshairScale
	
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine(x - length, y, x - gap, y)
	surface.DrawLine(x + length, y, x + gap, y)
	surface.DrawLine(x, y - length, x, y - gap)
	surface.DrawLine(x, y + length, x, y + gap)
	
end

