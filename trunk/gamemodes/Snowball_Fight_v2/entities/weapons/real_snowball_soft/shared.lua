--Updated: 13 Dec. 2009
-- Please dont re-upload this with :"Lol this is da new version, cuz I've changed 1 line of code, now this is mah weapon and all credits to me! ... blahblahblah". Seriously...
-- Made by NECROSSIN
-- I got the model from other swep, because this model is really awesome
-- and big thanks to the aRaptor_024 for the help with visual effects

if ( CLIENT ) then

	SWEP.PrintName			= "Real Snowball"			
	SWEP.Author				= "NECROSSIN"

	SWEP.Slot				= 1
	SWEP.SlotPos			= 3
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= true
	SWEP.WepSelectIcon = surface.GetTextureID("weapons/snowball_icon") 
	killicon.Add( "real_snowball_swep", "snowball_killicon", Color(255, 255, 255, 255 ) )
end

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false
end

SWEP.Category = 		"Christmas";
SWEP.Spawnable      = true
SWEP.AdminSpawnable  = true

SWEP.HoldType			= "grenade"

SWEP.ViewModel      = "models/weapons/v_snowball.mdl"
SWEP.WorldModel   = "models/weapons/w_snowball.mdl"

SWEP.Purpose        	= "This is ...Christmas"

SWEP.Instructions   	= "Primary to throw a snowball.\nSeconday to cheer."

-- screw this shit. snowballs aren't a bullets
SWEP.Primary.Delay			= 1 
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1	
SWEP.Primary.Automatic   	= true	
SWEP.Primary.Ammo         	= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"



function SWEP:Initialize()
if SERVER then
	self:SetWeaponHoldType(self.HoldType)
end
end

function SWEP:Deploy()
-- we need this sound because its a "snow" entity
self.Weapon:EmitSound("player/footsteps/snow"..math.random(1,6)..".wav")
-- some animations
self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	timer.Simple(0.4, function()
	if !ValidEntity(self.Weapon) then return end
	if !self.Weapon:IsValid() then return end
	self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
	end)
return true
end
-- think does nothing
function SWEP:Think()
end

function SWEP:PrimaryAttack()

self.Weapon:SetNextPrimaryFire(CurTime() + 1)
self.Weapon:SendWeaponAnim(ACT_VM_THROW)
self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")

	if SERVER then
	local Angles = self.Owner:EyeAngles()	
	local Position = self.Owner:GetShootPos();
	-- this makes swep more realistic
	Position = Position + Angles:Up() * 6 + Angles:Right() * 6
	
	local snowball = ents.Create("softsnowball")
	snowball:SetAngles(self.Owner:EyeAngles())
	snowball:SetPos(Position)
	snowball:SetOwner(self.Owner)
	snowball:Spawn()
	snowball:Activate()
	
	local phys = snowball:GetPhysicsObject()
	phys:ApplyForceCenter(self.Owner:GetAimVector() * math.random(1000,1300))
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
end
-- again some animations
timer.Simple(.5, function()
-- I dont want some errors
if !ValidEntity(self.Weapon) then return end
if !self.Weapon:IsValid() then return end
self.Weapon:EmitSound("player/footsteps/snow"..math.random(1,6)..".wav")
self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	timer.Simple(0.6, function()
	if !self.Weapon:IsValid() then return end
	self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
	end)
end)
	
end

local Voices = {
"vo/npc/male01/likethat.wav",
"vo/npc/male01/watchout.wav",
"vo/npc/Barney/ba_laugh04.wav",
"vo/coast/odessa/male01/nlo_cheer02.wav",
"vo/coast/odessa/male01/nlo_cheer03.wav",
"vo/coast/odessa/male01/nlo_cheer04.wav",
}

-- idk why we need this
function SWEP:SecondaryAttack()
local r = math.random(1,table.Count(Voices))

self.Owner:EmitSound(Voices[ r ])
self.Weapon:SetNextSecondaryFire(CurTime() + 2)
end

-- visual effects here
if CLIENT then
-- please dont. change. this.
local x
local y
local wd
local hg
local alpha

local function DrawSnowHit()
-- because we need different position
	if not x then
		x = math.Rand(-0.5,0.5)
	end
	
	if not y then
		y = math.Rand(-0.5,0.3)
	end
	
	if not wd then
		wd = math.Rand(10,25)
	end
	
	if not hg then
		hg = math.Rand(10,25)
	end
--and the alpha trick (thanks to aRaptor_024)	
	if alpha > 0 then	
		alpha = alpha - math.random(0,1)
	end
	-- draw our texture at random position
	local w,h = surface.GetTextureSize(surface.GetTextureID("effects/blood_core"))
	surface.SetTexture(surface.GetTextureID("effects/blood_core"))
	surface.SetDrawColor(255, 255, 255,alpha)
	surface.DrawTexturedRect(ScrW()*x, ScrH()*y, w*wd, h*hg)
		
end
-- and the usermessage for it
local function SnowHit(um)
	-- remove old hook
	hook.Remove("HUDPaint", "PaintSnow")
	--and re-new position
	x = math.Rand(-0.5,0.5)
	y = math.Rand(-0.5,0.3)
	wd = math.Rand(10,25)
	hg = math.Rand(10,25)
	alpha = 255 -- and return normal alpha
	-- add it again
	hook.Add("HUDPaint","PaintSnow",DrawSnowHit)

end
usermessage.Hook("SnowHit", SnowHit)

end

------------------------------------------------------------
--resouces
------------------------------------------------------------
-- i did not make these models and textures, so all credits to their creator(s)

resource.AddFile( "materials/models/Weapons/v_models/sball/v_hands.vmt" )
resource.AddFile( "materials/models/Weapons/v_models/sball/v_hands.vtf" )
resource.AddFile( "materials/models/Weapons/v_models/sball/v_hands_normal.vtf" )
resource.AddFile( "materials/models/Weapons/v_models/Snooball/s.vmt" )
resource.AddFile( "materials/models/Weapons/v_models/Snooball/s.vtf" )
resource.AddFile( "materials/models/Weapons/v_models/Snooball/s_norm.vtf" )
resource.AddFile( "materials/weapons/snowball_icon.vtf" )
resource.AddFile( "materials/weapons/snowball_icon.vmt" )
resource.AddFile( "materials/vgui/entities/real_snowball_swep.vmt" )
resource.AddFile( "materials/vgui/entities/real_snowball_swep.vtf" )
resource.AddFile( "materials/snowball_killicon.vtf" )
resource.AddFile( "materials/snowball_killicon.vmt" )

resource.AddFile( "models/Weapons/v_snowball.mdl" )
resource.AddFile( "models/Weapons/v_snowball.vvd" )
resource.AddFile( "models/Weapons/v_snowball.dx80.vtx" )
resource.AddFile( "models/Weapons/v_snowball.dx90.vtx" )
resource.AddFile( "models/Weapons/v_snowball.sw.vtx" )
resource.AddFile( "models/Weapons/w_snowball.mdl" )
resource.AddFile( "models/Weapons/w_snowball.phy" )
resource.AddFile( "models/Weapons/w_snowball.vvd" )
resource.AddFile( "models/Weapons/w_snowball.dx80.vtx" )
resource.AddFile( "models/Weapons/w_snowball.dx90.vtx" )
resource.AddFile( "models/Weapons/w_snowball.sw.vtx" )
resource.AddFile( "models/Weapons/w_snowball_thrown.mdl" )
resource.AddFile( "models/Weapons/w_snowball_thrown.phy" )
resource.AddFile( "models/Weapons/w_snowball_thrown.vvd" )
resource.AddFile( "models/Weapons/w_snowball_thrown.dx80.vtx" )
resource.AddFile( "models/Weapons/w_snowball_thrown.dx90.vtx" )
resource.AddFile( "models/Weapons/w_snowball_thrown.sw.vtx" )




