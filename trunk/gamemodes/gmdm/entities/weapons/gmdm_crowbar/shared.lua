
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "melee"

if ( CLIENT ) then

	SWEP.PrintName			= "Crowbar"			
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0
	SWEP.DrawAmmo			= false
	SWEP.CustomAmmoIcon = surface.GetTextureID( "hud/gmdm_icons/fireball" )

end

SWEP.Base				= "gmdm_base"
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self:GMDMInit()
end

function SWEP:HasUsableAmmo( )
	return true
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.CanSprintAndShoot		= true;

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ConstantAccuracy	= true
SWEP.Primary.Cone		= 0.0;

function SWEP:PrimaryAttack( )
	
	if not self:CanShootWeapon( ) then return end
	
	self.Weapon:EmitSound( "Weapon_Crowbar.Single" )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Owner:ViewPunch( Angle( math.random(-1,1), math.random(1,2), 0 ) )
	
	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * 60)

	local hull = Vector() * 8

	local tr_main = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
	local hitEnt = tr_main.Entity

   if IsValid(hitEnt) or tr_main.HitWorld then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      if not (CLIENT and (not IsFirstTimePredicted())) then
         local edata = EffectData()
         edata:SetStart(spos)
         edata:SetOrigin(tr_main.HitPos)
         edata:SetNormal(tr_main.Normal)

         --edata:SetSurfaceProp(tr_main.MatType)
         --edata:SetDamageType(DMG_CLUB)
         edata:SetEntity(hitEnt)

         if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
            util.Effect("BloodImpact", edata)

			self.Weapon:SendWeaponAnim( ACT_VM_HITKILL )
			
            util.Decal("Blood", tr_main.HitPos + tr_main.HitNormal, tr_main.HitPos - tr_main.HitNormal)
            self.Owner:LagCompensation(false)
            self.Owner:FireBullets({Num=1, Src=spos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=45})
			
         else
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
            util.Effect("Impact", edata)
         end
      end
   else
      self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
   end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
	
end

function SWEP:Reload( )
	return
end

function SWEP:SecondaryAttack( )
	self:PrimaryAttack( )
end
