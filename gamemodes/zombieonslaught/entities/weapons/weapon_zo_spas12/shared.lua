if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "shotgun"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "SPAS-12"
	SWEP.Slot = 2
	SWEP.Slotpos = 2
	SWEP.IconLetter = "k"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_spas12", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "zo_base"

SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.IronSightsPos = Vector (5.7266, -2.9373, 3.3522)
SWEP.IronSightsAng = Vector (0.1395, -0.0055, -0.4603)
SWEP.IronsightsFOV = 60

SWEP.Primary.Sound			= Sound( "Weapon_Shotgun.Double" )
SWEP.Primary.Pump           = Sound( "Weapon_M3.Pump" )
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 13
SWEP.Primary.Recoil			= 13.5
SWEP.Primary.Cone			= 0.090
SWEP.Primary.Delay			= 0.600

SWEP.Primary.ClipSize		= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.AmmoType		= "Buckshot"

SWEP.Primary.ShellType      = SHELL_SHOTGUN

function SWEP:Deploy()

	self.Weapon:SetNWBool( "Reloading", false )
	self.Weapon:SetVar( "PumpTime", 0 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

	if SERVER then
		self.Weapon:ToggleIronsights( false )
		self.Owner:SetCurrentAmmo( self.Primary.AmmoType )
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:CanPrimaryAttack()

	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then
		
		self.Weapon:EmitSound( self.Primary.Empty, 100, math.random(90,110) )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return false
		
	end

	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		self.Weapon:SetNWBool( "Reloading", false )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
		
		return false
	
	end

	if self.Weapon:Clip1() <= 0 then
	
		if SERVER then
			self.Weapon:ToggleIronsights( false )
		end
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:SetVar( "PumpTime", CurTime() + 0.5 )
	
	if SERVER then
		self.Weapon:ToggleIronsights( false )
	end
	
	if IsFirstTimePredicted() then
	
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		
		if SERVER then
		
			local scale = 0.50
			if self.Owner:KeyDown(IN_DUCK) then
				scale = 0.25
			elseif self.Owner:KeyDown(IN_SPEED) then
				scale = 0.75
			end
			
			local pang, yang = math.Rand( -1 * scale, -1 ) * self.Primary.Recoil, math.Rand( -1 * ( scale / 3 ), ( scale / 3 ) ) * self.Primary.Recoil
			self.Owner:ViewPunch( Angle( pang, yang, 0) )
			self.Owner:AddCustomAmmo( self.Primary.AmmoType, -1 )
			
		end
		
	end
	
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	
end

function SWEP:SecondaryAttack()

	if self.Owner:KeyDown(IN_SPEED) and self.Owner:GetVelocity():Length() != 0 then return end
	
	if self.Weapon:GetNWBool( "Reloading", false ) then return end

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )

	if SERVER then
		self.Weapon:ToggleIronsights( !self.Owner:GetNWBool( "Ironsights", false ) )
	end

end

function SWEP:Reload()

	if self.Weapon:GetNWBool( "Reloading", false ) then return end
	
	if self.Owner:GetNWInt( self.Primary.AmmoType, 0 ) < 1 then return end
	
	if self.Weapon:Clip1() < self.Primary.ClipSize then
	
		if SERVER then
			self.Weapon:ToggleIronsights( false )
		end
		
		self.Weapon:SetNWBool( "Reloading", true )
		self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		
	end
	
	return true
	
end

function SWEP:PumpIt()

	self.Weapon:SetNWBool( "Reloading", false )
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
	self.Weapon:EmitSound( self.Primary.Pump )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if SERVER then
	
		local ed = EffectData()
		ed:SetOrigin( self.Owner:GetShootPos() )
		ed:SetEntity( self.Weapon )
		ed:SetAttachment( self.Weapon:LookupAttachment( "2" ) )
		ed:SetScale( ( self.Primary.ShellType or SHELL_9MM ) )
		util.Effect( "weapon_shell", ed, true, true )
	
	end
	
end

function SWEP:Think()

	if SERVER and self.Owner:KeyDown(IN_SPEED) and self.Owner:GetVelocity():Length() != 0 then
		self.Weapon:ToggleIronsights( false )
	end
	
	if self.Weapon:GetVar( "PumpTime", 0 ) != 0 and self.Weapon:GetVar( "PumpTime", 0 ) < CurTime() then
		self.Weapon:SetVar( "PumpTime", 0 )
		self.Weapon:PumpIt()
	end

	if self.Weapon:GetNWBool( "Reloading", false ) then
	
		if self.Weapon:GetVar( "ReloadTimer", 0 ) < CurTime() then
			
			// Finsished reload
			if self.Weapon:Clip1() >= self.Primary.ClipSize then
			
				self.Weapon:SetNWBool( "Reloading", false )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
				
				self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
				
				return
				
			end
			
			// Next cycle
			self.Weapon:SetVar( "ReloadTimer", CurTime() + 0.5 )
			self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			
			// Add ammo
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
			
		end
	end
end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	local scale = aimcone
	
	if self.Owner:KeyDown(IN_SPEED) and self.Owner:GetVelocity():Length() != 0 then
		scale = aimcone * 1.5
	elseif self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = aimcone * 1.2
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = aimcone / 1.2
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= math.Round(damage * 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		if tr.Entity:IsValid() and ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() ) and SERVER then
			if tr.HitGroup == 1 then
				local ed = EffectData()
				ed:SetNormal(tr.HitNormal)
				ed:SetOrigin(tr.HitPos)
				util.Effect("headshot", ed, true, true)
			else
				local ed = EffectData()
				ed:SetOrigin(tr.HitPos)
				ed:SetNormal(tr.HitNormal)
				util.Effect("bodyshot", ed, true, true)
			end
			util.Decal( "Blood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
		end
	end
	
	self.Owner:FireBullets( bullet )
	
end

SWEP.CrosshairScale = 1
function SWEP:DrawHUD()

	if self.Owner:GetNWBool( "Ironsights", false ) then return end

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	local scale = self.Primary.Cone
	
	if self.Owner:KeyDown(IN_SPEED) and self.Owner:GetVelocity():Length() != 0 then
		scale = self.Primary.Cone * 1.5
	elseif self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = self.Primary.Cone * 1.2
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = self.Primary.Cone / 1.2
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