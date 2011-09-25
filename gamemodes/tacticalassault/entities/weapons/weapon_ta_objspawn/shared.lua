if (SERVER) then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	
	SWEP.Weight = 1
end

if (CLIENT) then

	SWEP.PrintName = "Objective Spawner"
	SWEP.Slot = 5
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false

end

 SWEP.Author = "Entoros"; 
 SWEP.Contact = ""; 
 SWEP.Purpose = "Spawn objectives"; 
 SWEP.Instructions = "Primary: Spawn objective\nSecondary: Switch objectives + Remove placed objectives"
 SWEP.Base = "weapon_ta_base";
 
 SWEP.Spawnable = false
 SWEP.AdminSpawnable = true;
   
SWEP.ViewModel		= "models/weapons/v_toolgun.mdl"
SWEP.WorldModel		= "models/weapons/w_toolgun.mdl"

 SWEP.Primary.ClipSize = -1; 
 SWEP.Primary.DefaultClip = -1; 
 SWEP.Primary.Automatic = false; 
 SWEP.Primary.Ammo = "none";
 SWEP.Secondary.Ammo = "none";
 
 SWEP.RunAng = Angle(20,0,0)
 SWEP.RunPos = Vector(0,0,4)
 SWEP.types = {
	{
		model = "models/props_gameplay/cap_point_base.mdl",
		name = "Capture Objective",
		class = "obj_capture",
		raiseup = 2,
	},
	{
		model = "models/props/metal_box.mdl",
		name =  "Bomb Objective",
		class = "obj_explode_win",
		raiseup = 20,
	},
}
SWEP.Description = [[LIST OF OBJECTIVES
1. Capture Objective
	These are used either as game-winners
	or spawn points. If there is a bomb in
	the game, then they do not cause the round
	to end
2. Bomb Objective
	These, if placed, are the primary objective.
	Players use a C4 explosive to destroy the
	bomb, therefore it is imperative to defend it
	at all costs.]]

SWEP.build_sounds = {
	Sound("ta/build/build1.mp3"),
	Sound('ta/build/build2.wav'),
}
SWEP.CurObj = 1
 
 function SWEP:Initialize()
	self.Yaw = 0
end

function SWEP:Holster()

	if self.GhostEntity then
		self.GhostEntity:Remove()
		self.GhostEntity = nil
	end

	return true
end

function SWEP:Deploy()
	if not self.GhostEntity || not self.GhostEntity:IsValid() then
		self:MakeGhost()
	end
	return true
end

function SWEP:Reload()
	
	for _,v in ipairs(string.Explode("\n",self.Description)) do
		self.Owner:ChatPrint(v)
	end
	
end
	

function SWEP:PrimaryAttack()
	
	if !self:CanPrimaryAttack() then return end

	if self.GhostEntity then
	
		local tr = self.Owner:GetEyeTrace()
		local dist = tr.HitPos:Distance(self.Owner:GetPos())
		local info = self.types[self.CurObj]
	
		if dist > 300 || tr.HitNonWorld then
			
			self.Owner:ChatPrint("That is not a valid location.")
			
		else
			
			local ent = ents.Create(info.class)
			ent:SetPos(self.GhostEntity:GetPos())
			ent:SetAngles(self.GhostEntity:GetAngles())
		
			ent:Spawn()
			ent:Activate()
			
			self.Owner:EmitSound(table.Random(self.build_sounds))
			
		end
		
		self.Weapon:SetNextPrimaryFire(CurTime() + 5)
		
	end
	
end
	
function SWEP:SecondaryAttack()

	if !self:CanPrimaryAttack() then return end
	
	local ent = self.Owner:GetEyeTrace().Entity
	for _,v in ipairs(self.types) do 
		if v.class == ent:GetClass() then
			ent:Remove()
			return
		end
	end
	
	self.CurObj = self.CurObj + 1
	if self.CurObj > #self.types then self.CurObj = 1 end
	
	local info = self.types[self.CurObj]
	self.Owner:PrintMessage(HUD_PRINTCENTER,info.name)
	
	self.GhostEntity:SetModel(info.model)
	self.GhostEntity:SetNWInt("RaiseUp",info.raiseup)
	
end

function SWEP:Think()
	
	self:UpdateGhost()
	
end

function SWEP:MakeGhost( n )
	self.GhostEntity = ents.Create( "prop_physics" )
	
	if (!self.GhostEntity:IsValid()) then
		self.GhostEntity = nil
		return
	end
	
	local info = self.types[self.CurObj]
	
	self.GhostEntity:SetModel( info.model )
	self.GhostEntity:SetNWInt("RaiseUp",info.raiseup)
	self.GhostEntity:SetNWInt("Type",n)
	self.GhostEntity:SetPos( self.Owner:GetEyeTrace().HitPos + Vector(0,0,raiseup))
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

	local tr = self.Owner:GetEyeTrace()
	local dist =tr.HitPos:Distance(self.Owner:GetPos())
	
	if dist < 300 && !tr.HitNonWorld then
		self.GhostEntity:SetColor( 50, 255, 50, 200 )
	else
		self.GhostEntity:SetColor( 255, 50, 50, 200 )
	end
	
	if self.Owner:KeyDown(IN_USE) then self.Yaw = self.Yaw + 1 end
	
	self.GhostEntity:SetAngles( Angle(0,self.Owner:GetForward():Angle().yaw + self.Yaw,0) )
	
	self.GhostEntity:SetPos( self.Owner:GetEyeTrace().HitPos + Vector(0,0,self.GhostEntity:GetNWInt("RaiseUp")) )
	
end