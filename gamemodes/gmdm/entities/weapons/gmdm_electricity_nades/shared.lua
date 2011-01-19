SWEP.Author			= "Levybreak"
SWEP.Contact		= "nil"
SWEP.Purpose		= "1.21 JIGAWATTS OF AWESOME POWER!"
SWEP.Instructions	= "Left-Click: Throw grenade"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.CustomSecondaryAmmo = true
SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "Electricity Grenades"	
SWEP.Slot				= 5
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_grenade.mdl"
SWEP.WorldModel			= "models/weapons/w_grenade.mdl"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

if ( CLIENT ) then

	SWEP.CustomAmmoIcon = surface.GetTextureID( "hud/gmdm_icons/mine" )

end


function SWEP:Precache()
	util.PrecacheModel("models/weapons/w_grenade.mdl")
end

function SWEP:Initialize( )
	self:GMDMInit()
	self:SetWeaponHoldType( "grenade" )	
end

function SWEP:FirstTimePickup( Owner )
	Owner:AddCustomAmmo( "ElectricityGrenades", 3 )	
end

function SWEP:HasUsableAmmo( )
	return self.Owner:GetCustomAmmo( "ElectricityGrenades" ) > 0
end


//PRIMARY FIRE
function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 1.21 )

	if not self:CanShootWeapon( ) then return end	
	if self.Owner:GetCustomAmmo( "ElectricityGrenades" ) < 1 then return end

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )

	self.Owner:SetAnimation( PLAYER_ATTACK2 )

	if (SERVER) then
		self.Owner:TakeCustomAmmo( "ElectricityGrenades", 1 )
		timer.Simple(0.157, function() if self:IsValid() then self:ThrowHigh( false ) end end)
	end
	
	self:NoteGMDMShot( )
	
end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 1.35 )

	if not self:CanShootWeapon( ) then return end	
	if self.Owner:GetCustomAmmo( "ElectricityGrenades" ) < 1 then return end

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )

	self.Owner:SetAnimation( PLAYER_ATTACK2 )

	if (SERVER) then
		self.Owner:TakeCustomAmmo( "ElectricityGrenades", 1 )
		timer.Simple(0.167, function() if self:IsValid() then self:ThrowHigh( true ) end end)
	end
	self:NoteGMDMShot( )

end

//RELOAD
function SWEP:Reload()
end

function SWEP:Deploy()
	if( self:CustomAmmoCount() > 0 ) then
		self.Weapon:SendWeaponAnim(	ACT_VM_DRAW	)
	else
		self.Weapon:SendWeaponAnim(	ACT_VM_SECONDARYATTACK	)
	end
	return true
end

function SWEP:Think()
end

function SWEP:ThrowHigh( IsSticky )
	if (SERVER) then
		local ply = self.Owner
		local grenadeobj = ents.Create("grenade_electricity")
		grenadeobj:SetPos(ply:GetShootPos() + Vector(0,0,-9.2))
		grenadeobj:SetAngles(ply:GetAimVector())
		grenadeobj:SetPhysicsAttacker(self.Owner)
		
		if( IsSticky == true ) then
			grenadeobj:SetKeyValue( "IsSticky", "1" )
		else
			grenadeobj:SetKeyValue( "IsSticky", "0" )
		end
		
		grenadeobj:SetOwner(self.Owner)
		grenadeobj:Spawn()

		local Phys = grenadeobj:GetPhysicsObject()
		local Force = ply:GetAimVector() * math.random(4620,4820) + Vector(0, 0, math.random(100,120))
		Phys:ApplyForceCenter(Force)

		self.Owner:EmitSound( "weapons/ar2/ar2_reload_rotate.wav", 40, 100 )

		if( self:CustomAmmoCount() > 0 ) then
			self.Weapon:SendWeaponAnim(	ACT_VM_DRAW	)
		end
	end
end 


function SWEP:CustomAmmoCount()

	if ( !ValidEntity( self.Owner ) ) then return 0 end
	return self.Owner:GetCustomAmmo( "ElectricityGrenades" )
	
end 