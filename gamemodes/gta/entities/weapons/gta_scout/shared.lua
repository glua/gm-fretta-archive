if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Steyr Scout"
	SWEP.IconLetter = "n"
	
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "gta_scout", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "gta_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel	= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"

SWEP.IronSightsPos = Vector( 5.0124, -8.9394, 2.1298 )
SWEP.IronSightsAng = Vector( 0, 0, -0.3972 )

SWEP.ZoomModes = { 0, 40, 5 }
SWEP.ZoomSpeeds = { 0.25, 0.40, 0.40 }

SWEP.Primary.Sound			= Sound( "Weapon_Scout.Single" )
SWEP.Primary.Zoom           = Sound( "weapons/g3sg1/g3sg1_slide.wav" )
SWEP.Primary.Recoil         = 4.0 
SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.001
SWEP.Primary.Delay			= 1.220
SWEP.Primary.ShellType      = SHELL_338MAG

SWEP.Primary.ClipSize		= 10
SWEP.Primary.Automatic		= false

function SWEP:Deploy()

	if SERVER then
		self.Weapon:ToggleIronsights( false )
		self.Weapon:SetZoomMode( 1 )
		self.Owner:DrawViewModel( true )
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
	
end  

function SWEP:Reload()

	if self.Weapon:GetZoomMode() != 1 and SERVER then
		self.Weapon:ToggleIronsights( false )
		self.Weapon:SetZoomMode( 1 )
		self.Owner:DrawViewModel( true )
	end	
	
	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	
end

function SWEP:ShootBullets( damage, numbullets, aimcone )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	local scale = aimcone
	
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = aimcone * 2
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		scale = math.Clamp( aimcone / 1.2, 0, 10 )
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
		if tr.HitWorld and SERVER then
			WorldSound( Sound( table.Random( GAMEMODE.Ricochet ) ), tr.HitPos, 100, math.random(90,110) )
		end
		self:BulletCallback(  attacker, tr, dmginfo, 0 )
	end
	
	self.Owner:FireBullets( bullet )
	
end

function SWEP:CanPrimaryAttack()

	if self.Weapon:Clip1() <= 0 then
	
		if SERVER then
			self.Weapon:ToggleIronsights( false )
			self.Weapon:SetZoomMode( 1 )
			self.Owner:DrawViewModel( true )
		end
	
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.75 )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if IsFirstTimePredicted() and ValidEntity( self.Owner ) then
		
		if SERVER then
		
			if self.Weapon:GetZoomMode() != 1 then
			
				self.Weapon:ToggleIronsights( false )
				self.Weapon:SetZoomMode( 1 )
				self.Owner:DrawViewModel( true )
				
			end	
			
			local scale = 0.50
			if self.Owner:KeyDown(IN_DUCK) then
				scale = 0.25
			elseif self.Owner:KeyDown(IN_SPEED) then
				scale = 0.75
			end
			
			local pang, yang = math.Rand( -1 * scale, 0 ) * self.Primary.Recoil, math.Rand( -1 * ( scale / 3 ), ( scale / 3 ) ) * self.Primary.Recoil
			self.Owner:ViewPunch( Angle( pang, yang, 0) )
			
			self.Eject = CurTime() + 0.5
			
		end
		
	end
	
end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
	self.Weapon:EmitSound( self.Primary.Zoom, 100, self.Weapon:GetZoomMode() * 25 + 100 )

	if SERVER then
	
		if self.Weapon:GetZoomMode() == 1 then
		
			self.Weapon:ToggleIronsights( !self.Owner:GetNWBool( "Ironsights", false ) )
			self.MoveTime = CurTime() + 0.35
			
		else
		
			self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
			
		end
	end
end

function SWEP:Think()

	if CLIENT then return end

	if self.Eject and self.Eject < CurTime() then
	
		self.Eject = nil
	
		local ed = EffectData()
		ed:SetOrigin( self.Owner:GetShootPos() )
		ed:SetEntity( self.Weapon )
		ed:SetAttachment( self.Weapon:LookupAttachment( "2" ) )
		ed:SetScale( self.Primary.ShellType )
		util.Effect( "weapon_shell", ed, true, true )
	
	end
	
	if self.MoveTime and self.MoveTime < CurTime() then
	
		self.MoveTime = nil
		self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
		self.Owner:DrawViewModel( false )
		
	end

end

function SWEP:AdjustMouseSensitivity()

	local num = self.Weapon:GetNWInt("Mode",1)
	local scale = self.ZoomModes[num] / 100
	
	if scale == 0 then
		return nil
	end

	return scale
	
end

function SWEP:GetZoomMode()
	return self.Weapon:GetNWInt( "Mode", 1 )
end

function SWEP:SetZoomMode( num )

	if num > #self.ZoomModes then
	
		num = 1
		
		if SERVER then
			self.Weapon:ToggleIronsights( false )
			self.Owner:DrawViewModel( true )
		end
		
	end
	
	self.Weapon:SetNWInt( "Mode", num )
	self.Owner:SetFOV( self.ZoomModes[num], self.ZoomSpeeds[num] )

end

function SWEP:DrawHUD()

	local vm = self.Owner:GetViewModel()
	if vm:IsValid() then
		vm:SetMaterial( "" )
	end
	
	local mode = self.Weapon:GetNWInt( "Mode", 1 )
	
	if mode != 1 then
	
		local w = ScrW()
		local h = ScrH()
		local wr = ( h / 3 ) * 4

		surface.SetTexture( surface.GetTextureID( "gmod/scope" ) )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawTexturedRect( ( w / 2 ) - wr / 2, 0, wr, h )
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, ( w / 2 ) - wr / 2, h )
		surface.DrawRect( ( w / 2 ) + wr / 2, 0, w - ( ( w / 2 ) + wr / 2 ), h )
		surface.DrawLine( 0, h * 0.50, w, h * 0.50 )
		surface.DrawLine( w * 0.50, 0, w * 0.50, h )
		
	end
	
end
