if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false
	SWEP.HoldType			= "knife"

	local ActIndex = {}
		ActIndex[ "knife" ]		= ACT_HL2MP_IDLE_KNIFE

	function SWEP:SetWeaponHoldType( t )

		local index 								= ActIndex[ t ]
			
		if (index == nil) then
			return
		end

		self.ActivityTranslate 							= {}
		self.ActivityTranslate [ ACT_HL2MP_IDLE ] 			= index
		self.ActivityTranslate [ ACT_HL2MP_WALK ] 			= index + 1
		self.ActivityTranslate [ ACT_HL2MP_RUN ] 				= index + 2
		self.ActivityTranslate [ ACT_HL2MP_IDLE_CROUCH ] 		= index + 3
		self.ActivityTranslate [ ACT_HL2MP_WALK_CROUCH ] 		= index + 4
		self.ActivityTranslate [ ACT_HL2MP_GESTURE_RANGE_ATTACK ] 	= index + 5
		self.ActivityTranslate [ ACT_HL2MP_GESTURE_RELOAD ] 		= index + 6
		self.ActivityTranslate [ ACT_HL2MP_JUMP ] 			= index + 7
		self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 			= index + 8
	
		self:SetupWeaponHoldTypeForAI( t )
	end
end

if ( CLIENT ) then
	SWEP.PrintName			= "KNIFE"	
	SWEP.Author				= "WORSHIPPER"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false
	SWEP.ViewModelFOV			= 65
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes		= false
	
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "j"

	killicon.AddFont("weapon_real_cs_knife", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))

	-- This is the font that's used to draw the death icons
	surface.CreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
	-- This is the font that's used to draw the select icons
	surface.CreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end

SWEP.Instructions 			= "Left click to cut \nRight click to throw \nReload to aim"

SWEP.IronSightsPos 			= Vector (-15.6937, -10.1535, -1.0596)
SWEP.IronSightsAng 			= Vector (46.9034, 9.0593, -90.2522)

SWEP.Category				= "CS:S Realistic Weapons"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel 				= "models/weapons/v_knife_t.mdl"
SWEP.WorldModel 				= "models/weapons/w_knife_t.mdl" 

SWEP.Weight					= 5
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.ClipSize			= -1
SWEP.Primary.Damage			= 100
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "xbowbolt"

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Damage			= 100
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"

SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/knife/knife_hitwall1.wav")
SWEP.DeploySound				= Sound("weapons/knife/knife_deploy1.wav")

SWEP.IronSightsPos 			= Vector (-2.0423, -11.5056, 8.4193)
SWEP.IronSightsAng 			= Vector (-63.4059, 40.5195, 0)

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

 if !self.Owner:KeyDown(IN_USE) then 

 if self.Owner:KeyPressed(IN_RELOAD) then
		self:SetIronsights(true)
		self.Owner:SetFOV( 70, 0.15 )

	if CLIENT then return end
 	end
end

 if self.Owner:KeyReleased(IN_RELOAD) then
		self:SetIronsights(false)
		self.Owner:SetFOV( 0, 0.15 )

	if CLIENT then return end
	end

	if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
		self.Owner:RemoveAmmo(1,self.Primary.Ammo)
		self.Owner:ConCommand("lastinv")
	end
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize() 
   
 	if ( SERVER ) then 
 		self:SetWeaponHoldType( self.HoldType ) 
 	end 
	util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")
	util.PrecacheSound("weapons/knife/knife_hit1.wav")
	util.PrecacheSound("weapons/knife/knife_hit2.wav")
	util.PrecacheSound("weapons/knife/knife_hit3.wav")
	util.PrecacheSound("weapons/knife/knife_hit4.wav")	 

 end 

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:EmitSound( self.DeploySound, 50, 100 )
	return true
end

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 1 then return end

	self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Owner:RemoveAmmo(1,self.Primary.Ammo)

	if SERVER then
		local knife = ents.Create("ent_knife")
		knife:SetAngles(self.Owner:EyeAngles())

		if (self:GetIronsights() == false) then
			local v = self.Owner:GetShootPos()
				v = v + self.Owner:GetForward() * 5
				v = v + self.Owner:GetRight() * 9
				v = v + self.Owner:GetUp() * -5
			knife:SetPos( v )
		else
			knife:SetPos (self.Owner:EyePos() + (self.Owner:GetAimVector()))
		end

		knife:SetOwner(self.Owner)
		knife:SetPhysicsAttacker(self.Owner)
		knife:Spawn()
		knife:Activate()

		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		local phys = knife:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector() * 3000)
		phys:AddAngleVelocity(Vector(0, 500, 0))
	end
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 50 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then

		if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 50
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( "weapons/knife/knife_hit" .. math.random(1, 4) .. ".wav" )
		else
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 50
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( self.WallSound )		
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
		end
	else
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	return false
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()

return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()

	return true
end

/*---------------------------------------------------------
ShootEffects
---------------------------------------------------------*/
function SWEP:ShootEffects()

end

local IRONSIGHT_TIME = 0.15

/*---------------------------------------------------------
GetViewModelPosition
---------------------------------------------------------*/
function SWEP:GetViewModelPosition(pos, ang)
	if (not self.IronSightsPos) then return pos, ang end

	local bIron = self.Weapon:GetNWBool("Ironsights")

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()

		if (bIron) then
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end

	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end

	local Offset	= self.IronSightsPos

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
end


/*---------------------------------------------------------
SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights(b)

	self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()

	return self.Weapon:GetNWBool("Ironsights")
end

SWEP.NextSecondaryAttack = 0

/*---------------------------------------------------------
DrawWeaponSelection
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)

	draw.SimpleText(self.IconLetter, "CSSelectIcons", x + wide / 2, y + tall * 0.2, Color(255, 210, 0, 255), TEXT_ALIGN_CENTER)
	-- Draw a CS:S select icon

	self:PrintWeaponInfo(x + wide + 20, y + tall * 0.95, alpha)
	-- Print weapon information
end