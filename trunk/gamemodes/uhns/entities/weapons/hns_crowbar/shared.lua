
if (SERVER) then
   AddCSLuaFile ("shared.lua");
end

SWEP.Base				= "gmdm_base"
SWEP.PrintName = "PROJECTILE CROWBAR";
SWEP.Slot = 1;
SWEP.SlotPos = 0;
SWEP.DrawAmmo = false;
SWEP.DrawCrosshair = true;
SWEP.ViewModel		= "models/weapons/v_crowbar.mdl"		
SWEP.WorldModel		= "models/weapons/w_crowbar.mdl"

function SWEP:Initialize()

	self:GMDMInit()
	self:SetWeaponHoldType( "pistol" )
	
end

local ShootSound = Sound ("weapons/slam/throw.wav");

SWEP.RunArmAngle  = Angle( 70, 0, 0 )
SWEP.RunArmOffset = Vector( 25, 4, 0 )
SWEP.Delay = 0.3
SWEP.TickDelay = 0.1

function SWEP:ThrowCrowbar(shotPower)
	local tr = self.Owner:GetEyeTrace();

	if (!SERVER) then return end;

	local ent = ents.Create ("throwing_crowbar");	
	ent:SetPhysicsAttacker(self.Owner)
	local Forward = self.Owner:EyeAngles():Forward()
	ent:SetPos( self.Owner:GetShootPos() + Forward * 0 )
	ent:SetAngles (self.Owner:EyeAngles());
	ent:Spawn();
	ent:SetOwner(self.Owner)
	ent:Activate( )
	
	ent.Owner = self.Owner
	
	local trail_entity = util.SpriteTrail( ent,  //Entity
											0,  //iAttachmentID
											Color( 255, 255, 255, 92 ),  //Color
											false, // bAdditive
											0.7, //fStartWidth
											1.2, //fEndWidth
											0.4, //fLifetime
											1 / ((0.7+1.2) * 0.5), //fTextureRes
											"trails/physbeam.vmt" ) //strTexture
	
	local phys = ent:GetPhysicsObject()
	phys:ApplyForceCenter (self.Owner:GetAimVector():GetNormalized() * shotPower);
end

/*---------------------------------------------------------
   PRIMARY
---------------------------------------------------------*/

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "none";

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.TickDelay )
	
	if ( !self:CanShootWeapon() ) then return end
	
	self.Weapon:EmitSound (ShootSound);
	
	if (CLIENT) then return end
	self:ThrowCrowbar(100000);
	self.Owner:StripWeapon("hns_crowbar");
end

/*---------------------------------------------------------
   SECONDARY
---------------------------------------------------------*/

SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none";

function SWEP:SecondaryAttack()
end
