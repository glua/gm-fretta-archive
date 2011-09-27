//By Rambo_6
//Ruined by Douglas Huck
if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Box gun"
	SWEP.IconLetter = "t"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 50, 200, 50, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.ViewModel		= "models/weapons/v_toolgun.mdl"
SWEP.WorldModel		= "models/weapons/w_toolgun.mdl"
	
SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= Sound("weapons/ar1/ar1_dist1.wav")
SWEP.Primary.Burst          = Sound("Weapon_AR2.Single")
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.Automatic	= false
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetVar( "FireTime", -1 )
	
	return true
	
end  

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()
	
	return true
	
end

function SWEP:SecondaryAttack()
	local trace = self.Owner:GetEyeTrace()
	if(SERVER) then
		if(!GetGlobalBool( "InRealRound", false ))then
			if (self.Owner:GetPos():Distance(trace.HitPos) < 500)  then
				if(trace.Entity:IsValid())then
					if( trace.Entity:GetClass() == "box_ent" ) then
						if(trace.Entity:GetNetworkedEntity("OwnerObj") == self.Owner)then
							trace.Entity:Remove()
							GAMEMODE:addpoints(self.Owner, 1)
							GAMEMODE:addStat(self.Owner, "placed", -1)
						end
					end
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	local trace = self.Owner:GetEyeTrace()
	if(SERVER) then
		if (self.Owner.points > 0) && (self.Owner:GetPos():Distance(trace.HitPos) < 500) then
			if(trace.Entity == NULL)then return end
			if(trace.Entity:IsPlayer())then return end
			local box = ents.Create("box_ent")
			box:SetNetworkedString("Owner", self.Owner:Nick())
			box:SetNetworkedEntity("OwnerObj", self.Owner)
			box:SetPos(BoxSide(trace.HitNormal, trace.Entity, trace.HitPos))
			box:Spawn()
			box:Activate()
			box:SetColor(team.GetColor(self.Owner:Team()))
			GAMEMODE:addpoints(self.Owner, -1)
			GAMEMODE:addStat(self.Owner, "placed", 1)
		end
	end
end

function BoxSide(nang, ent, hitpos)
	local size = 52
	if( ent:GetClass( ) == "box_ent" ) then
		bent = ent:GetPos()
		size = 52
	else
		bent = hitpos
		size = 26
	end
		
	if (math.Round(nang.x) == 1) then
		return (bent + Vector(size,0,0))
	elseif (math.Round(nang.x) == -1) then
		return (bent + Vector(-size,0,0))
	elseif (math.Round(nang.y)	== 1) then
		return (bent + Vector(0,size,0))
	elseif (math.Round(nang.y) == -1) then
		return (bent + Vector(0,-size,0))
	elseif (math.Round(nang.z) == 1) then
		return (bent + Vector(0,0,size))
	elseif (math.Round(nang.z) == -1) then
		return (bent + Vector(0,0,-size))
	end
end

if CLIENT then

	SWEP.CrossRed = CreateClientConVar( "crosshair_r", 255, true, false )
	SWEP.CrossGreen = CreateClientConVar( "crosshair_g", 255, true, false )
	SWEP.CrossBlue = CreateClientConVar( "crosshair_b", 255, true, false )
	SWEP.CrossAlpha = CreateClientConVar( "crosshair_a", 255, true, false )
	SWEP.CrossScale = CreateClientConVar( "crosshair_scale", 1, true, false )

end

SWEP.CrosshairScale = 1
function SWEP:DrawHUD()

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	
	local scale = self.Primary.Cone
	
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = scale * 1.2
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( scale / 2, 0, 10 )
	end
	
	//scale = math.Clamp( ( 10 + ( scale * ( 260 * (ScrH()/720) ) ) ) * self.CrossScale:GetFloat(), 0, (ScrH()/2) - 100 )
	//self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 )
	
	// CAN'T GET THIS TO WORK NICELY
	
	scale = scale * scalebywidth * self.CrossScale:GetFloat()
	
	local dist = math.abs(self.CrosshairScale - scale)
	self.CrosshairScale = math.Approach(self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05)
	
	local gap = 40 * self.CrosshairScale
	local length = gap + 20 * self.CrosshairScale
	
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine(x - length, y, x - gap, y)
	surface.DrawLine(x + length, y, x + gap, y)
	surface.DrawLine(x, y - length, x, y - gap)
	surface.DrawLine(x, y + length, x, y + gap)
	
	local color = team.GetColor(self.Owner:Team())
	local r = color.r
	local g = color.g
	local b = color.b
	draw.RoundedBoxEx( 6, 0, 68, 300, 24, Color(r, g, b, 100), false, true, false, true )
	draw.RoundedBoxEx( 6, 0, 102, 300, 24, Color(r, g, b, 100), false, true, false, true )
	struc = {}
	struc["pos"] = {4, 72}
	if(self.Owner:GetNetworkedInt( "Points", 0 ) > 0)then
		struc["color"] = Color(255, 255, 255, 200)
	else
		struc["color"] = Color(180, 180, 180, 200)
	end
	struc["text"] = "Left: Spawn A Crate (-1 Box Point)"
	struc["font"] = "ChatFont"
	struc["xalign"] = TEXT_ALIGN_LEFT
	struc["yalign"] = TEXT_ALIGN_TOP
	draw.Text( struc )
	struc = {}
	struc["pos"] = {4, 106}
	if(GetGlobalBool( "InRealRound", false ))then
		struc["color"] = Color(180, 180, 180, 200)
	else
		struc["color"] = Color(255, 255, 255, 200)
	end
	struc["text"] = "Right: Remove A Crate (+1 Box Point)"
	struc["font"] = "ChatFont"
	struc["xalign"] = TEXT_ALIGN_LEFT
	struc["yalign"] = TEXT_ALIGN_TOP
	draw.Text( struc )
end

function SWEP:Think()	
	if(CLIENT) then
		if (self.Owner:GetNetworkedInt( "Points", 0 ) > 0) then
			local trace = self.Owner:GetEyeTrace()
			if(trace.Entity == NULL) or (trace.Entity:IsPlayer()) or (self.Owner:GetPos():Distance(trace.HitPos) > 500) then
				DestroyGhostEnt(self.Owner)
				return
			end
			local pos = BoxSide(trace.HitNormal, trace.Entity, trace.HitPos)
			local color = team.GetColor(self.Owner:Team())
			MakeGhostEnt(self.Owner, "models/mhs/cw_crate/cw_crate.mdl", pos, Vector(0, 0, 0), Color(color.r, color.g, color.b, 120))
		end
	end
end

function SWEP:Holster( wep )
	DestroyGhostEnt(self.Owner)
	return true
end

function SWEP:OnRemove()
	DestroyGhostEnt(self.Owner)
	return true
end

function MakeGhostEnt(owner, model, pos, angle, color)
	util.PrecacheModel(model)
	DestroyGhostEnt(owner)
	owner.GhostEnt = ents.Create("prop_physics")
	if (!owner.GhostEnt:IsValid()) then
		owner.GhostEnt = nil
		return
	end
	owner.GhostEnt:SetModel(model)
	owner.GhostEnt:SetPos(pos)
	owner.GhostEnt:SetAngles(angle)
	owner.GhostEnt:Spawn()
	
	owner.GhostEnt:SetSolid(SOLID_VPHYSICS);
	owner.GhostEnt:SetMoveType(MOVETYPE_NONE)
	owner.GhostEnt:SetNotSolid(true);
	owner.GhostEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
	owner.GhostEnt:SetColor(color.r, color.g, color.b, color.a)
end

function DestroyGhostEnt(owner)
	if ( owner.GhostEnt ) then
		if (!owner.GhostEnt:IsValid()) then owner.GhostEnt = nil return end
		owner.GhostEnt:Remove()
		owner.GhostEnt = nil
	end
end