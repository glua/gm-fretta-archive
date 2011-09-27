
SWEP.Author			= "Levybreak"
SWEP.Contact		= "Facepunch"
SWEP.Purpose		= "Grapple with it. To climb up the walls of building at specified points."
SWEP.Instructions	= "Left click to throw out at hook onto a green O area. Right click to remove it. When hooked, hold Shift-forward to move up it. Shift-Back to move down it. Use to hop up once you're near the hook."

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.HoldType			= "slam"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HookModel = "models/props_junk/meathook001a.mdl"

SWEP.Force = 20000

SWEP.Amt = 120

SWEP.UpForce = 10

function SWEP:Initialize()
	if ( SERVER ) then
       self:SetWeaponHoldType( self.HoldType )
	   self.CurSlack = -3500
	else

	end
end

function SWEP:Holster()

	if (!SERVER) then return end
	if self.Hook and self.Hook:IsValid() then
		self.Hook:Remove()
	end
	self.Hook =  nil
	if self.RopeMove and self.RopeMove:IsValid() then
		self.RopeMove:Remove()
	end
	self.RopeMove = nil
	if self.RopeKey and self.RopeKey:IsValid() then
		self.RopeKey:Remove()
	end
	self.RopeKey = nil
	self.CurSlack = -3500
	
	return true
end

local Red = Color(255,0,0,200)
local Green = Color(0,240,20,200)

function SWEP:DrawHUD()

	if (!CLIENT) then return end

	local tr = LocalPlayer():GetEyeTrace()
	if tr.HitPos:IsInLadder() then
		draw.SimpleText("O","HUDNumber3",ScrW()/2,ScrH()/2,Green,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("X","HUDNumber3",ScrW()/2,ScrH()/2,Red,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
end

local SLACK_DELTA   = 150
local WASD_FORCE    = 5
local HOOK_Z_OFFSET = 64 * 1.5
local GRAVITY       = -600
local SPHERE_COEFF  = 200

function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + 0.75)
    if CLIENT then return end
    
    if not self.RopeKey then
        GAMEMODE:DoAnimationEvent(self.Owner, PLAYERANIMEVENT_ATTACK_PRIMARY)
        
        local ply = self.Owner
        
        self.Hook = ents.Create("thief_hook")
        self.Hook:SetModel(self.HookModel)
        self.Hook:SetPos(ply:GetShootPos())
        self.Hook:Spawn()
        self.Hook:GetPhysicsObject():ApplyForceCenter(ply:GetAimVector()*self.Force)
        self.Hook.Fading = true
        
        self.RopeKey = ents.Create("keyframe_rope")
        self.RopeKey:SetKeyValue("MoveSpeed", "64")
        self.RopeKey:SetKeyValue("Slack", "-1000")
        self.RopeKey:SetKeyValue("Subdiv", "2")
        self.RopeKey:SetKeyValue("Width", "0.5")
        self.RopeKey:SetKeyValue("TextureScale", "1")
        self.RopeKey:SetKeyValue("Collide", "1")
        self.RopeKey:SetKeyValue("RopeMaterial", "cable/rope.vmt")
        self.RopeKey:SetKeyValue("targetname", ply:UniqueID().."GrappleRope")
        self.RopeKey:SetPos(self.Hook:GetPos())
        self.RopeKey:Spawn()
        self.RopeKey:Activate()
        self.RopeKey:SetParent(self.Hook)
    
        self.RopeMove = ents.Create("move_rope")
        self.RopeMove:SetKeyValue("MoveSpeed", "64")
        self.RopeMove:SetKeyValue("Slack", "-1000")
        self.RopeMove:SetKeyValue("Subdiv", "2")
        self.RopeMove:SetKeyValue("Width", "0.5")
        self.RopeMove:SetKeyValue("TextureScale", "1")
        self.RopeMove:SetKeyValue("Collide", "1")
        self.RopeMove:SetKeyValue("PositionInterpolator", "2")
        self.RopeMove:SetKeyValue("NextKey", ply:UniqueID().."GrappleRope")
        self.RopeMove:SetKeyValue("RopeMaterial", "cable/rope.vmt")
        self.RopeMove:SetKeyValue("targetname", ply:UniqueID().."GrappleMoveRope")
        self.RopeMove:SetPos(ply:GetShootPos() + Vector(0, 0, -5))
        self.RopeMove:Spawn()
        self.RopeMove:Activate()
        self.RopeMove:SetParent(ply)
    
        self.Hook.MoveRopeName = ply:UniqueID().."GrappleMoveRope"
        self.Hook.RopeName = ply:UniqueID().."GrappleRope"
        self.Hook.Player = self.Owner
        
        self.Weapon:DeleteOnRemove(self.Hook)
        self.Weapon:DeleteOnRemove(self.RopeKey)
        self.Weapon:DeleteOnRemove(self.RopeMove)
    end
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    
    if self.Hook and self.Hook:IsValid() then
        self.Hook:Remove()
    end
    
    self.Hook =  nil
    
    if self.RopeMove and self.RopeMove:IsValid() then
        self.RopeMove:Remove()
    end
    
    self.RopeMove = nil
    
    if self.RopeKey and self.RopeKey:IsValid() then
        self.RopeKey:Remove()
    end
    
    self.RopeKey  = nil
    self.CurSlack = -3500
end

function SWEP:OnRemove()
    self:SecondaryAttack() -- Same damn code anyways
end

function SWEP:OnDrop()
    self:SecondaryAttack() -- Same damn code anyways
    
    return false
end

function SWEP:OwnerChanged()
    self:SecondaryAttack() -- Same damn code anyways
end

function SWEP:Holster()
    self:SecondaryAttack() -- Same damn code anyways
    
    return true
end

function SWEP:ShouldDropOnDie()
    self:SecondaryAttack() -- Same damn code anyways
    
    return false
end

function SWEP:Think()
    if SERVER then return end
    
    local entGrappleHook = self.Owner:GetNWEntity("GrappleHook")
    if not (entGrappleHook and entGrappleHook.IsValid and entGrappleHook:IsValid()) then return end
    
    if self.Owner:IsOnGround() and self.Owner:KeyDown(IN_FORWARD) and self.Owner:KeyDown(IN_SPEED) then
        self.Owner:ConCommand("+jump")
        timer.Simple(0.1, self.Owner.ConCommand, self.Owner, "-jump")
    end
    
    self:NextThink(CurTime())
    return true
end



local tblClientTracer = {filter = {}}

local function Hooker(plySubject, objMoveData)
    local self = plySubject.tblCuratorGrappleHookMoveInfo or {}
    plySubject.tblCuratorGrappleHookMoveInfo = self
    
    local entGrappleHook = plySubject:GetNWEntity("GrappleHook")
    
    if not (entGrappleHook and entGrappleHook.IsValid and entGrappleHook:IsValid()) then
        self.bWasOnGround = true -- slight hack
        
        return
    end
    
    local vecShootPos   = plySubject:GetShootPos()
    local vecHookPos    = entGrappleHook:GetPos() + Vector(0, 0, HOOK_Z_OFFSET)
    local vecHookDir    = vecShootPos - vecHookPos
    local nHookDistance = vecHookDir:Length()
    
    local bOnGround = plySubject:IsOnGround()
        if self.bWasOnGround ~= false then -- Handles nil too
            --nHookDistance = nHookDistance - 100
            self.LastHookDist = nHookDistance
            
            if SERVER then
            plySubject:SetNWInt("Curator.GrappleAmt", nHookDistance)
            end
        end
    self.bWasOnGround = bOnGround
    
    if not bOnGround then
        local vecAimDir      = plySubject:GetAimVector()
        local vecHookDirNrml = (vecHookDir * 1):Normalize()
        
        local vecDahForce = Vector(0, 0, 0)
        local vecAimDirXY = vecAimDir * 1; vecAimDirXY.z = 0
        local angAimDirXY = vecAimDirXY:Angle()
        
        local nInitialDist = plySubject:GetNWInt("Curator.GrappleAmt", 0)
        local nDistPercXY  = math.Clamp(1 - math.min(((vecHookPos.x - vecShootPos.x)^2 + (vecHookPos.y - vecShootPos.y)^2)^0.5 / nInitialDist, 1), 0, 1)
        
        if plySubject:KeyDown(IN_FORWARD) and plySubject:KeyDown(IN_SPEED) then
            if SERVER then
            nInitialDist = math.max(nInitialDist - (SLACK_DELTA * FrameTime()), 32)
            end
            objMoveData:SetForwardSpeed(0)
        end
        
        if plySubject:KeyDown(IN_BACK) and plySubject:KeyDown(IN_SPEED) then
            if SERVER then
            nInitialDist = nInitialDist + (SLACK_DELTA * FrameTime())
            end
            objMoveData:SetForwardSpeed(0)
        end
        
        plySubject:SetNWInt("Curator.GrappleAmt", nInitialDist)
        
        local nDistPerc     = (nHookDistance / nInitialDist)^0.1
        local nDeltaValue   = math.Clamp(2 - math.max(self.LastHookDist - nHookDistance, 0), 0, 2) / 2
        local nDistOverflow = math.max(nHookDistance - nInitialDist, 0)
        local vecDahForce = vecHookDirNrml * -nDistOverflow * FrameTime() * SPHERE_COEFF * nDeltaValue
        vecDahForce.z = vecDahForce.z + (GRAVITY * FrameTime())
        
        if nHookDistance < 256 then
            vecDahForce = vecDahForce * (nHookDistance / 256) * 4
        end
        
        self.LastHookDist = nHookDistance
        
        objMoveData:SetVelocity(objMoveData:GetVelocity() + vecDahForce)
    end
end
hook.Add("Move", "Curator.GrappleHook", Hooker)