
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then

	SWEP.DrawAmmo			= false
	SWEP.PrintName          = "Spawnpoint Gun"
	
end

SWEP.Author				= "Dlaor"
SWEP.Contact			= "Don't"
SWEP.Purpose			= "Change your spawnpoint"
SWEP.Instructions		= "Primary fire to change your spawnpoint to where you are currently standing, secondary fire to reset it"
SWEP.ViewModel			= "models/weapons/v_IRifle.mdl"
SWEP.WorldModel			= "models/weapons/w_IRifle.mdl"

SWEP.Primary.Sound			= Sound( "Airboat.FireGunRevDown" )
SWEP.Primary.Delay			= 0.2

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.Sound		= Sound( "Buttons.snd16" )
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( "ar2" )
end

function SWEP:PrimaryAttack()
	self:AttackFunction( self.Owner:GetPos(), self.Owner:EyeAngles(), "Spawnpoint has been changed!", self.Primary.Sound, true )
end

function SWEP:SecondaryAttack()
	if ( self.Owner:GetNWVector( "Spawnpoint", vector_origin ) != vector_origin ) then
		self:AttackFunction( vector_origin, Angle(0,0,0), "Spawnpoint has been reset!", self.Secondary.Sound, false )
	end
end

function SWEP:AttackFunction( pos, ang, str, snd, primary ) //Convenience function :P
	
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( snd )
	self:ShootEffects()
	
	if ( !IsFirstTimePredicted() or !SERVER ) then return end //Only do stuff if it's the first time predicted, otherwise you get double stuff
	if ( primary and self.Owner:Crouching() ) then //Can't place spawnpoint while crouching! (for security reasons)
		self.Owner:PrintMessage( HUD_PRINTTALK, "You cannot place your spawnpoint here!" )
		return
	end

	//if ( SERVER ) then
		self.Owner:SetNWVector( "Spawnpoint", pos )
		self.Owner:SetNWAngle( "Spawnang", ang )
	//else 
		self.Owner:PrintMessage( HUD_PRINTTALK, str )
	//end
	
end
