if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

if( CLIENT ) then
	SWEP.PrintName = "Knife";
	SWEP.Slot = 3;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = false;
end

SWEP.Author			= "Adobe Ninja"
SWEP.Instructions	= "Left click to stab"
SWEP.Contact		= "adobeninja.net"
SWEP.Purpose		= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.NextStrike = 0;
  
SWEP.ViewModel      = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel   = "models/weapons/w_knife_t.mdl"
  
-------------Primary Fire Attributes----------------------------------------
SWEP.Primary.Delay			= 0.9 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 15	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= true	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"	--Ammo Type
 
-------------Secondary Fire Attributes-------------------------------------
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"

util.PrecacheSound("weapons/knife/knife_deploy1.wav")
util.PrecacheSound("weapons/knife/knife_hitwall1.wav")
util.PrecacheSound("weapons/knife/knife_hit1.wav")
util.PrecacheSound("weapons/knife/knife_hit2.wav")
util.PrecacheSound("weapons/knife/knife_hit3.wav")
util.PrecacheSound("weapons/knife/knife_hit4.wav")
util.PrecacheSound("weapons/iceaxe/iceaxe_swing1.wav")

function SWEP:Initialize()
	self:SetWeaponHoldType( "melee" );
	self.Hit = { 
	Sound( "weapons/knife/knife_hitwall1.wav" )};
	self.FleshHit = {
  	Sound( "weapons/knife/knife_hit1.wav" ),
	Sound( "weapons/knife/knife_hit2.wav" ),
	Sound( "weapons/knife/knife_hit3.wav" ),
  	Sound( "weapons/knife/knife_hit4.wav" ) };

end

function SWEP:Precache()
end

function SWEP:Deploy()
	self.Owner:EmitSound( "weapons/knife/knife_deploy1.wav" );
	return true;
end

function SWEP:PrimaryAttack()
	if( CurTime() < self.NextStrike ) then return; end
	self.NextStrike = ( CurTime() + .5 );
 	local trace = self.Owner:GetEyeTrace();
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
		if( trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass()=="prop_ragdoll" ) then
			self.Owner:EmitSound( self.FleshHit[math.random(1,#self.FleshHit)] );
		else
			self.Owner:EmitSound( self.Hit[math.random(1,#self.Hit)] );
		end
			self.Owner:SetAnimation( PLAYER_ATTACK1 );
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
				bullet = {}
				bullet.Num    = 1
				bullet.Src    = self.Owner:GetShootPos()
				bullet.Dir    = self.Owner:GetAimVector()
				bullet.Spread = Vector(0, 0, 0)
				bullet.Tracer = 0
				bullet.Force  = 1
				bullet.Damage = 100000
			self.Owner:FireBullets(bullet) 
	else
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end
end


function SWEP:SecondaryAttack()
end 
