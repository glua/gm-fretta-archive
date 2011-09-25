if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

	resource.AddFile("materials/gmod/scope.vtf")
	resource.AddFile("materials/gmod/scope.vmt")
	resource.AddFile("materials/gmod/scope-refract.vtf")
	resource.AddFile("materials/gmod/scope-refract.vmt")
end

if ( CLIENT ) then
	SWEP.PrintName		= "COD4ish" --Weapons are kinda like COD4, but hey, no one sees this shit anyway.. Or do you? O_o
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "70"
	SWEP.Instructions	= ""
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
end

SWEP.Category = "BlackOps"

SWEP.HoldType			= "ar2"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.ViewModelFlip		= false

SWEP.Drawammo = true
SWEP.DrawCrosshair = true
SWEP.UseCustomCrosshair	= true
SWEP.AccurateCrosshair = true

SWEP.Primary.Sound		= Sound( "Weapon_AK47.Single" )
SWEP.Primary.Recoil		= 1.20
SWEP.Primary.DamageMin		= 8
SWEP.Primary.DamageMax		= 18
SWEP.Primary.BulletForce	= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.03
SWEP.Primary.ClipSize		= 60
SWEP.Primary.Delay		= 0.085
SWEP.Primary.DefaultClip	= 180
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "smg1"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

//SWEP.IronSightsPos = Vector
//SWEP.IronSightsAng = Vector
//SWEP.RunArmAngle = Vector
//SWEP.RunArmOffset = Vector

SWEP.CanSprintAndShoot = false
SWEP.CanIronSight = true

SWEP.SprayTime = 0.2
SWEP.SprayAccuracy = 0.5

SWEP.AllowRicochet = true
SWEP.AllowPenetration = true

SWEP.PenetrationMax = 32
SWEP.PenetrationMaxWood = 128
SWEP.MaxRicochet = 5
SWEP.ImpactEffects = true

SWEP.RunBob = 2.0
SWEP.RunSway = 2.0
SWEP.IronBob = 0.1
SWEP.IronSway = 0.3

function SWEP:Initialize()

	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType )
		self:SetNPCMinBurst( 30 )
		self:SetNPCMaxBurst( 30 )
		self:SetNPCFireRate( 0.01 )
	end
	
	self.Weapon:SetNetworkedBool( "Ironsights", false )
	
end

if not SWEP.IronSightsPos then
	SWEP.IronSightsPos = Vector(0,0,0)
	SWEP.IronSightsAng = Vector(0,0,0)
end
if not SWEP.ironpos then
	SWEP.ironpos = Vector(0,0,0)
	SWEP.ironang = Vector(0,0,0)
end

local IRONSIGHT_TIME = 0.15

function SWEP:GetViewModelPosition( pos, ang )

	local DashDelta = 0
	
	if ( (self.Owner:KeyDown( IN_SPEED ) ) and self.RunArmAngle and self.RunArmOffset) then
		
		if !self.InSpeed then
			self.InSpeed = true
			self.SwayScale 	= self.RunSway
			self.BobScale 	= self.RunBob
		end
		
		if (!self.DashStartTime) then
			self.DashStartTime = CurTime()
		end
		
		DashDelta = math.Clamp( ((CurTime() - self.DashStartTime) / 0.1) ^ 1.2, 0, 1 )
		
	else
	
		if self.InSpeed then
			self.InSpeed = false
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end

		if ( self.DashStartTime ) then
			self.DashEndTime = CurTime()
		end
	
		if ( self.DashEndTime ) then
		
			DashDelta = math.Clamp( ((CurTime() - self.DashEndTime) / 0.1) ^ 1.2, 0, 1 )
			DashDelta = 1 - DashDelta
			if ( DashDelta == 0 ) then self.DashEndTime = nil end
		
		end
		self.DashStartTime = nil
	end
	
	if ( DashDelta ) then
			local Offset = self.RunArmOffset
			
			if ( self.RunArmAngle ) then
				ang = ang * 1
				ang:RotateAroundAxis( ang:Right(), 		self.RunArmAngle.x * DashDelta )
				ang:RotateAroundAxis( ang:Up(), 		self.RunArmAngle.y * DashDelta )
				ang:RotateAroundAxis( ang:Forward(), 	self.RunArmAngle.z * DashDelta )
			end
			
			local Right 	= ang:Right()
			local Up 		= ang:Up()
			local Forward 	= ang:Forward()
			
			pos = pos + Offset.x * Right * DashDelta
			pos = pos + Offset.y * Forward * DashDelta
			pos = pos + Offset.z * Up * DashDelta
	end

	if (self.IronSightsPos and !self.Owner:KeyDown( IN_SPEED )) then
		local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
		if ( bIron != self.bLastIron ) then
			self.bLastIron = bIron 
			self.fIronTime = CurTime()	
			if ( bIron ) then 
				self.SwayScale 	= self.IronSway
				self.BobScale 	= self.IronBob
			else 
				self.SwayScale 	= 1.0
				self.BobScale 	= 1.0
			end
		end

		local fIronTime = self.fIronTime or 0
		
		if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
			return pos, ang 
		end
		local Mul = 1.0
		
		if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
			Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
			if (!bIron) then Mul = 1 - Mul end
		end
		
		if(DashDelta==0) then
			local Offset = self.IronSightsPos
			
			if ( self.IronSightsAng ) then
				ang = ang * 1
				ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
				ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
				ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
			end
			
			local Right 	= ang:Right()
			local Up 		= ang:Up()
			local Forward 	= ang:Forward()
			
			pos = pos + Offset.x * Right * Mul
			pos = pos + Offset.y * Forward * Mul
			pos = pos + Offset.z * Up * Mul
		end
	end
	
	return pos, ang
end

function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

	if b == true then
		self.Owner:SetFOV(65,0.15)
	else
		self.Owner:SetFOV(0,0.15)
	end

end

function SWEP:SecondaryAttack()

	if ( !self:CanShootWeapon() and !self.CanIronSight) then return end

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )

	if SERVER then
		bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
		self:SetIronsights( bIronsights )
	end
	if ( CLIENT || SinglePlayer()) then
		self.Weapon:EmitSound(Sound("npc/metropolice/gear"..math.random(1,6)..".wav"),30,math.random(75,100)) --Sexy ironsight sound
	end

end

function SWEP:PrimaryAttack()
	if ( !self:CanShootWeapon() ) then return end
	if ( !self:CanPrimaryAttack() ) then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:ShootBullet( self.Primary.NumShots, self.Primary.Cone/self:GetStanceAccuracyBonus() )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if IsFirstTimePredicted() and self.Owner:IsValid() then --Predict that motha' fucka'

 		//local eyeang = self.Owner:EyeAngles()
 		//eyeang.pitch = eyeang.pitch - self.Primary.Recoil

 		//self.Owner:SetEyeAngles( eyeang )

		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )

		//self.Owner:ViewPunch( Angle( -self.Primary.Recoil, 0, 0 ) )

		if self.Weapon:GetNetworkedBool( "Ironsights", false ) == false then
			self.Owner:ViewPunch( Angle( -self.Primary.Recoil, math.Rand(-1,1)*self.Primary.Recoil, 0))
		else
			self.Owner:ViewPunch( Angle( -self.Primary.Recoil/2, math.Rand(-1,1)*self.Primary.Recoil/2, 0))
		end
	end
	
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end

function SWEP:ShootBullet( num_bullets, aimcone )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	--[[local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetShootPos() )
		effectdata:SetEntity( self.Weapon )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetNormal( self.Owner:GetAimVector() )
		effectdata:SetAttachment( 1 )
	util.Effect( "gunsmoke", effectdata )]] --Was ugly
	
	if !IsFirstTimePredicted() then return end

	local bullet = {}
	bullet.Num 			= num_bullets
	bullet.Src 			= self.Owner:GetShootPos()
	bullet.Dir 			= self.Owner:GetAimVector()
	bullet.Spread 		= Vector( aimcone, aimcone, 0 )
	bullet.Tracer		= 5
	bullet.Force		= self.Primary.BulletForce
	bullet.Damage		= math.random(self.Primary.DamageMin,self.Primary.DamageMax)
	bullet.AmmoType 	= self.Primary.Ammo
	--bullet.Callback    	= function( a, b, c ) return self:RicochetCallback_Redirect( a, b, c ) end
	
	self.Owner:FireBullets( bullet )
end

--[[function SWEP:BulletPenetrate( bouncenum, attacker, tr, dmginfo, isplayer )

	
	--if( !SERVER ) then return end
	// Don't go through metal
	if ( ( tr.MatType == MAT_METAL and self.AllowRicochet == true ) or tr.MatType == MAT_SAND ) then return false end

	// Don't go through more than 3 times
	if ( bouncenum > 3 ) then return false end
	
	// Direction (and length) that we are gonna penetrate
	local PeneDir = tr.Normal * self.PenetrationMax;
	
	if( tr.MatType == MAT_DIRT or tr.MatType == MAT_WOOD or tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH ) then -- dirt == plaster, and wood should be easier to penetrate so increase the distance
		PeneDir = tr.Normal * self.PenetrationMaxWood;
	end
		
		
	local PeneTrace = {}
	   PeneTrace.endpos = tr.HitPos
	   PeneTrace.start = tr.HitPos + PeneDir
	   PeneTrace.mask = MASK_SHOT
	   PeneTrace.filter = { self.Owner }
	   
	local PeneTrace = util.TraceLine( PeneTrace ) 
	
	// Bullet didn't penetrate.
	if ( PeneTrace.StartSolid || PeneTrace.Fraction >= 1.0 || tr.Fraction <= 0.0 ) then return false end
	
	-- Damage multiplier depending on surface
	local fDamageMulti = 0.5;
	
	if( tr.MatType == MAT_CONCRETE ) then
		fDamageMulti = 0.3;
	elseif( tr.MatType == MAT_WOOD ) then
		fDamageMulti = 0.8;
	elseif( tr.MatType == MAT_FLESH || tr.MatType == MAT_ALIENFLESH ) then
		fDamageMulti = 0.9;
	end
		
	// Fire bullet from the exit point using the original tradjectory
	local bullet = 
	{	
		Num 		= 1,
		Src 		= PeneTrace.HitPos,
		Dir 		= tr.Normal,	
		Spread 		= Vector( 0, 0, 0 ),
		Tracer		= 1,
		TracerName 	= "rico_trace",
		Force		= 5,
		Damage		= (dmginfo:GetDamage()*0.9),
		AmmoType 	= "Pistol",
		HullSize	= 2
	}
	
	bullet.Callback    = function( a, b, c ) if( self.RicochetCallback ) then return self:RicochetCallback( bouncenum+1, a, b, c ) end end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( PeneTrace.HitPos )
	effectdata:SetNormal ( PeneTrace.Normal )
	util.Effect( "Impact", effectdata, true, true ) 
		
	timer.Simple( 0.05, attacker.FireBullets, attacker, bullet, true )
	attacker:SetNetworkedInt( "BulletType", 1 ); -- 1 = wallbang

	return true

end

function SWEP:RicochetCallback( bouncenum, attacker, tr, dmginfo )

	if( !self ) then return end
	
	local DoDefaultEffect = false;
	if ( !tr.HitWorld ) then DoDefaultEffect = true end
	if ( tr.HitSky ) then return end
	
	// Can we go through whatever we hit?
	if ( self.AllowPenetration == true and self:BulletPenetrate( bouncenum, attacker, tr, dmginfo ) ) then
		return { damage = false, effects = false }
	end
	
	if ( tr.MatType != MAT_METAL ) then

		 if ( tr.MatType != MAT_FLESH and self.ImpactEffects ) then			
			if ( SERVER ) then
				util.ScreenShake( tr.HitPos, 100, 0.2, 1, 128 )
			end
		end

	return end
	
	if( self.AllowRicochet == false ) then return { damage = true, effects = DoDefaultEffect } end
	
	if ( bouncenum > self.MaxRicochet ) then return end
	
	// Bounce vector (Don't worry - I don't understand the maths either :x)
	local DotProduct = tr.HitNormal:Dot( tr.Normal * -1 )
	local Dir = ( 2 * tr.HitNormal * DotProduct ) + tr.Normal
	Dir:Normalize()
	
	local bullet = 
	{	
		Num 		= 1,
		Src 		= tr.HitPos,
		Dir 		= Dir,	
		Spread 		= Vector( 0.05, 0.05, 0 ),
		Tracer		= 1,
		TracerName 	= "rico_trace",
		Force		= 5,
		Damage		= (dmginfo:GetDamage()/1.5),
		AmmoType 	= "Pistol",
		HullSize	= 2
	}
		
	-- BLaNK
	-- Added conditional to stop errors when bullets ricoshet after weapon switch.
	bullet.Callback    = function( a, b, c ) if( self.RicochetCallback ) then return self:RicochetCallback( bouncenum+1, a, b, c ) end end
	
	timer.Simple( 0.05, attacker.FireBullets, attacker, bullet, true )
	attacker:SetNetworkedInt( "BulletType", 2 ); -- 2 = ricochet
	WorldSound("weapons/fx/rics/ric"..math.random(1,5)..".wav",tr.HitPos)
	
	return { damage = true, effects = DoDefaultEffect }
		
end

function SWEP:RicochetCallback_Redirect( a, b, c )
	return self:RicochetCallback( 0, a, b, c )
end]]

function SWEP:Reload()
	if self.Owner:GetActiveWeapon():Clip1() == self.Primary.ClipSize then return end
	if self.Reloading || self.Owner:GetAmmoCount(self.Primary.Ammo) == 0 then return end
	if self.Weapon:Clip1() < self.Primary.ClipSize then
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
		self:SetIronsights( false )
	end
end

function SWEP:Deploy()

	self:SetIronsights( false )

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
end 

function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
	
end

function SWEP:CanShootWeapon()

	if( self.Owner:IsNPC() ) then
		return true
	end
	
	// Cannot fire weapon if we were running less than 0.3 seconds ago
	if( self.CanSprintAndShoot == false ) then
		if( self.Owner:KeyDown( IN_SPEED ) ) then return false end
		if ( self.LastSprintTime && CurTime() - self.LastSprintTime < 0.1 ) then return false end
	end
	
	return true

end

function SWEP:Think()

	//Made it so when we run, the third person animation lowered their weapon, but the animation was fucked.
	
	// Keep track of the last time we were running while holding this weapon..
	if ( self.Owner && self.Owner:KeyDown( IN_SPEED ) ) then
		self.LastSprintTime = CurTime()
		self:SetIronsights( false )
		--if SERVER then self:SetWeaponHoldType( "passive" ) end
	--else
		--if SERVER then self:SetWeaponHoldType( self.HoldType ) end
	end
	self:GetStanceAccuracyBonus()
end


//FROM GMDM, just modified slightly.
function SWEP:GetStanceAccuracyBonus()

	if( self.Owner:IsNPC() ) then
		return 0.8;
	end
	
	if( self.ConstantAccuracy ) then
		return 1.0;
	end
	
	local LastAccuracy = self.LastAccuracy or 0;
	local Accuracy = 1.0;
	local LastShoot = self.Weapon:GetNWFloat( "LastShootTime", 0 );
	
	local speed = self.Owner:GetVelocity():Length()
	-- 200 walk, 500 sprint, 705 noclip
	local speedperc = math.Clamp( math.abs( speed / 2000 ), 0, 1 );
	
	if( CurTime() <= LastShoot + self.SprayTime ) then
		Accuracy = Accuracy * self.SprayAccuracy;
	end
	
	if( speed > 10 ) then -- moving
		Accuracy = Accuracy * ( ( ( 1 - speedperc ) + 0.1 ) / 1.5 );
	end
	
	if( self.Owner:KeyDown( IN_DUCK ) == true || self.Weapon:GetNetworkedBool( "Ironsights", false ) == true) then -- ducking moving forward
		Accuracy = Accuracy * 2;
	end

	if( self.Owner:KeyDown( IN_LEFT ) or self.Owner:KeyDown( IN_RIGHT ) ) then -- just strafing
		Accuracy = Accuracy * 0.5;
	end
	
	if( !self.Owner:OnGround() ) then
		Accuracy = Accuracy * 0.5;
	end
	
	if( LastAccuracy != 0 ) then
		if( Accuracy > LastAccuracy ) then
			Accuracy = math.Approach( self.LastAccuracy, Accuracy, FrameTime() * 2 )
		else
			Accuracy = math.Approach( self.LastAccuracy, Accuracy, FrameTime() * -2 )
		end
	end

	self.LastAccuracy = Accuracy;

	return Accuracy;
	
end

//FROM GMDM/CSS swep base, just modified slightly
function SWEP:DoDrawCrosshair( x, y )

	// No crosshair when ironsights is on
	if ( self.Weapon:GetNetworkedBool( "Ironsights" ) ) then return true end

	--local x = ScrW() / 2.0
	--local y = ScrH() / 2.0

	//local scale = ( 10 + (self.Primary.Cone * ( 260 * (ScrH()/720) ) ) * (1/self:GetStanceAccuracyBonus())) * 0.5;
	local scale = 10 * self.Primary.Cone * (1/self:GetStanceAccuracyBonus())
	
	// Scale the size of the crosshair according to how long ago we fired our weapon
	local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
	
	surface.SetDrawColor( 0, 255, 0, 255 )
	
	// Draw an awesome crosshair
	local gap = 40 * scale
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )
	
	return true

end
