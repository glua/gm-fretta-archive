
if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "slam"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Tool Kit"
	SWEP.IconLetter = "E"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.Base = "claw_base"

SWEP.ViewModel	= "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade.mdl"

SWEP.Primary.Sound			= Sound("HL1/fvox/buzz.wav")
SWEP.Primary.Sound2			= Sound("buttons/lightswitch2.wav")
SWEP.Primary.Damage			= 0
SWEP.Primary.HitForce       = 0
SWEP.Primary.Delay			= 40.0
SWEP.Primary.Automatic		= true

SWEP.BarModel = "models/props_debris/wood_chunk03b.mdl"
SWEP.Position = 35

function SWEP:PrimaryAttack()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetVar( "AnimTime", CurTime() + self.Primary.Delay )
	
	self.Weapon:BarricadeTrace()
	
end

function SWEP:SecondaryAttack()
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	self.Weapon:EmitSound( self.Primary.Sound2, 100, 60 )
	
	if CLIENT then return end
	
	self.Weapon:SetNWInt( "Pos", self.Weapon:GetNWInt( "Pos", 35 ) * -1 )

end

function SWEP:Deploy()

	if self.Weapon:GetVar( "AnimTime", 0 ) > CurTime() then
		self.Weapon:SendWeaponAnim(	ACT_VM_THROW )
	else
		self.Weapon:SendWeaponAnim(	ACT_VM_DRAW )
	end
	
	self.Weapon:SetNWInt( "Pos", 35 )
	
	return true
	
end

function SWEP:Holster()

	self.Weapon:ReleaseGhost()
	
	return true
	
end

function SWEP:Think()	

	if self.Weapon:GetVar( "AnimTime", 0 ) > 0 and self.Weapon:GetVar( "AnimTime", 0 ) < CurTime() then
	
		self.Weapon:SetVar( "AnimTime", 0 )
		self.Weapon:SendWeaponAnim(	ACT_VM_DRAW	)

	end
	
	if CLIENT then
		if not self.GhostEntity then
			self:MakeGhost( self.BarModel, self.Owner:GetPos() + Vector(0,0,100), Angle(0,0,0) )
		else
			self:UpdateGhost()
		end
	end

end

function SWEP:DrawHUD()

	local w,h = ScrW(),ScrH()
	
	surface.SetDrawColor(255, 255, 255, 255)
	local wh, lh, sh = w*.5, h*.5, 5
	surface.DrawLine(wh - sh, lh - sh, wh + sh, lh - sh) //top line
	surface.DrawLine(wh - sh, lh + sh, wh + sh, lh + sh) //bottom line
	surface.DrawLine(wh - sh, lh - sh, wh - sh, lh + sh) //left line
	surface.DrawLine(wh + sh, lh - sh, wh + sh, lh + sh) //right line
	
end

function SWEP:BarricadeTrace()

	self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_LOW )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local trace = util.GetPlayerTrace( self.Owner )
	local tr = util.TraceLine( trace )
	local trlength = self.Weapon:GetOwner():GetPos() - tr.HitPos
	trlength = trlength:Length() 
	   
	if trlength < 110 and tr.HitWorld then
	
		if SERVER then
		
			self.Owner:EmitSound( table.Random( GAMEMODE.WoodHammer ), 100, math.random(90,110) )
			self.Owner:EmitSound( table.Random( GAMEMODE.Drill ), 100, math.random(90,110) )
		
			local item = ents.Create("prop_physics")
			item:SetModel( self.BarModel )
			item:Spawn()
			item:SetHealth( 200 )
			self.Weapon:SetPlacePosition( item )
			
			self.Owner:Notice( "Placed a barricade", 5, 0, 100, 255 )
			
			self.Owner:AddBones( 2 )
			self.Owner:AddSupport()
			
		end
			
	else
	
		self.Weapon:EmitSound( self.Primary.Sound )
		
		if SERVER then
		
			self.Owner:Notice( "You can't place a barricade here", 5, 255, 50, 0 )
			
		end
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
		self.Weapon:SetVar( "AnimTime", CurTime() + 2 )
	
	end
	
end

function SWEP:SetPlacePosition(ent)

	local tr = utilx.GetPlayerTrace( self:GetOwner(), self:GetOwner():GetCursorAimVector() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	local ang = (trace.HitNormal * -1):Angle() + Angle(0,0,90)
	ent:SetAngles( ang )
	
	local pos = trace.HitPos + trace.HitNormal
	ent:SetPos( pos + ( ent:GetUp() * self.Weapon:GetNWInt( "Pos", 35 ) ) )
	
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( false )
	end

end

function SWEP:ReleaseGhost()

	if ( self.GhostEntity ) then
		if (!self.GhostEntity:IsValid()) then self.GhostEntity = nil return end
		self.GhostEntity:Remove()
		self.GhostEntity = nil
	end

end

function SWEP:MakeGhost( model, pos, angle )

	self.GhostEntity = ents.Create( "prop_physics" )
	
	if (!self.GhostEntity:IsValid()) then
		self.GhostEntity = nil
		return
	end
	
	self.GhostEntity:SetModel( model )
	self.GhostEntity:SetPos( pos )
	self.GhostEntity:SetAngles( angle )
	self.GhostEntity:Spawn()
	
	self.GhostEntity:SetSolid( SOLID_VPHYSICS );
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true );
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.GhostEntity:SetColor( 255, 255, 255, 200 )
	
end

function SWEP:UpdateGhost()

	if (self.GhostEntity == nil) then return end
	if (!self.GhostEntity:IsValid()) then self.GhostEntity = nil return end
	
	local tr = utilx.GetPlayerTrace( self:GetOwner(), self:GetOwner():GetCursorAimVector() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	local ang = (trace.HitNormal * -1):Angle() + Angle(0,0,90)
	local pos = trace.HitPos + trace.HitNormal
	
	local trlength = self.Weapon:GetOwner():GetPos() - trace.HitPos
	trlength = trlength:Length() 
	
	if trlength < 110 then
		self.GhostEntity:SetColor( 50, 255, 50, 200 )
	elseif trlength >= 110 or tr.HitWorld then
		self.GhostEntity:SetColor( 255, 50, 50, 200 )
	end
	
	self.GhostEntity:SetModel( self.BarModel )
	self.GhostEntity:SetPos( pos + (self.GhostEntity:GetUp() * self.Weapon:GetNWInt( "Pos", 35 ) ) )
	self.GhostEntity:SetAngles( ang )
	
end