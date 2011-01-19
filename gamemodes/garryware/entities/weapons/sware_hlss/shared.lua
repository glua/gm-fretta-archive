
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "gmdm_base"
SWEP.PrintName			= "HLSS"			
SWEP.Slot				= 1
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.HoldType = "slam"

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

function SWEP:PrimaryAttack()

end

function SWEP:DrawHUD()

end

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:SecondaryAttack()

end

function SWEP:Think()
	if (CLIENT) then
		if GetConVar("voice_inputfromfile"):GetInt() > 0 and self.Owner:IsSpeaking( ) then
			RunConsoleCommand("cware_hlss")
		end
	end
end
