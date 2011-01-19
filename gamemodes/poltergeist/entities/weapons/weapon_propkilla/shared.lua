if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "ar2"
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Laser"
	SWEP.IconLetter = "t"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 50, 200, 50, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.ViewModel		= "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_famas.mdl"

SWEP.Primary.Sound			= Sound("weapons/ar1/ar1_dist1.wav")
SWEP.Primary.Burst          = Sound("Weapon_AR2.Single")
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.450

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
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
	self.Weapon:SetVar( "FireTime", -1 )
	
	return true
	
end  

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()
	
	return true
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
	
	local damage = self.Weapon:DamageScale( 150, 50 )
	
	self.Weapon:ShootBullets( damage, self.Primary.NumShots, self.Primary.Cone, "beam_tracer" )	
	
end

function SWEP:SecondaryAttack()

	self.Weapon:SetVar( "FireTime", CurTime() + 2.0 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 2.0 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 5.0 )

end

function SWEP:Think()	

	if self.Weapon:GetVar( "FireTime", 0 ) > CurTime() then
	
		if self.Weapon:GetVar( "BurstTime", 0 ) < CurTime() then
	
			local damage = self.Weapon:DamageScale( 30, 10 )
			
			self.Weapon:ShootBullets( 25, self.Primary.NumShots, self.Primary.Cone, "blast_tracer" )	
			self.Weapon:EmitSound( self.Primary.Burst, 100, math.random(120,140) )
			self.Weapon:SetVar( "BurstTime", CurTime() + 0.08 )
			
		end
	
	elseif self.Weapon:GetVar( "FireTime", 0 ) != -1 then
	
		self.Weapon:SetVar( "FireTime", -1 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:SetNextSecondaryFire( CurTime() + 3 )
	
	end

end

function SWEP:DamageScale( damagemax, damagemin )

	return math.Clamp( damagemax * ( team.NumPlayers( TEAM_GHOST ) / #player.GetAll() ), damagemin, damagemax )

end

function SWEP:ShootBullets( damage, numbullets, aimcone, tracer )

	local scale = aimcone
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = aimcone * 1.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( aimcone / 2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= damage * 3							
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= tracer
	bullet.Callback = function ( attacker, tr, dmginfo )
	
	end
	
	self.Owner:FireBullets( bullet )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
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
		scale = math.Clamp( scale / 2, 0, 10 )
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

