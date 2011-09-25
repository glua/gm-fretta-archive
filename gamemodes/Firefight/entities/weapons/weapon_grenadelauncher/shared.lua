if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "rpg"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Grenade Launcher"			
	SWEP.Author				= "Carnag3"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 2
	
	function SWEP:DrawHUD()

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	
	surface.SetDrawColor( 0, 255, 0, 200 )
	
	surface.DrawLine( x - 25, y, x - 5, y)
	surface.DrawLine( x + 5, y, x + 25, y)
	surface.DrawLine( x, y - 25, x, y - 5)
	surface.DrawLine( x, y + 5, x, y + 25)
	
	surface.SetDrawColor( 255, 0, 0, 200 )
	
	surface.DrawLine( x - 20, y + 115, x + 20, y + 115)
	surface.DrawLine( x - 25, y + 95, x + 25, y + 95)
	surface.DrawLine( x - 30, y + 75, x + 30, y + 75 )
	surface.DrawLine( x - 35, y + 55, x + 35, y + 55 )
	surface.DrawLine( x - 40, y + 35, x + 40, y + 35 )
	end
end

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rpg.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.ViewModelFlip 		= false
SWEP.DrawCrosshair		= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "RPG_Round"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Reload()
end

function SWEP:Think()	
end

function SWEP:PrimaryAttack()
	
	if self:Ammo1() < 1 then
		self:EmitSound( Sound( "Weapon_RPG.Empty" ) )
		return false
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )

	self:EmitSound( Sound( "Weapon_RPG.Single" ) )
	self:ShootEffects( self )
	self:TakePrimaryAmmo(1)
	
	// The rest is only done on the server
	if (!SERVER) then return end
	
	local Forward = self.Owner:EyeAngles():Forward()
	
	local ent = ents.Create( "Grenade_ammo" )
	if ( ValidEntity( ent ) ) then
		ent:SetPos( self.Owner:GetShootPos() + Forward * 32 )
		ent:SetAngles( self.Owner:EyeAngles() )
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		phys:Wake()
		phys:SetVelocity( Forward * 1500)
	end
	
	ent:SetOwner( self.Owner )
	
	
end

