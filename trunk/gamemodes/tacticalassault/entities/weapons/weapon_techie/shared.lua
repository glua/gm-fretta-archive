if (SERVER) then
	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	
	SWEP.Weight = 1
end

if (CLIENT) then

	SWEP.PrintName = "TECH CONSTRUCTOR"
	SWEP.Slot = 3
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.ViewModelFOV = 70
	
	if (file.Exists("../materials/weapons/weapon_techie.vmt")) then
		SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_techie")
	end

end

 SWEP.Author = "Entoros"; 
 SWEP.Contact = ""; 
 SWEP.Purpose = "Create technology"; 
 SWEP.Instructions = "Primary: Popup menu + Make buildings\nSecondary: Remove buildings"
 SWEP.Base = "weapon_ta_base";
 
 SWEP.Spawnable = false
 SWEP.AdminSpawnable = true;
   
SWEP.ViewModel		= "models/weapons/devin/v_wrench.mdl"
SWEP.WorldModel		= "models/weapons/devin/w_wrench.mdl"

 SWEP.Primary.ClipSize = 100; 
 SWEP.Primary.DefaultClip = 100; 
 SWEP.Primary.Automatic = false; 
 SWEP.Primary.Ammo = "CombineCannon";
 SWEP.Secondary.Ammo = "none";
 
 SWEP.RunAng = Angle(20,0,0)
 SWEP.RunPos = Vector(0,0,4)
 SWEP.types = {
	[1] = { 
		model = "models/devin/barricade_small.mdl",
		health = 250,
		buildtime = 10,
		height = 102.780,
		},
	[2] = {
		model = "models/devin/barricade_medium.mdl",
		health = 500,
		buildtime = 20,
		height =102.780,
		},
	[3]  = {
		model = "models/devin/barricade_large.mdl",
		health = 1000,
		buildtime = 30,
		height =102.780,
		raiseup = 0,
		}
}

SWEP.build_sounds = {
	Sound("ta/build/build1.mp3"),
	Sound('ta/build/build2.wav'),
}
 
 function SWEP:Initialize()
	self.GhostEntity = nil
end

function SWEP:Deploy()
	self.Yaw = 90
end

function SWEP:Holster()

	if self.GhostEntity then
		self.GhostEntity:Remove()
		self.GhostEntity = nil
	end

	return true
end

function SWEP:OnRemove()
	if self.GhostEntity then
		self.GhostEntity:Remove()
		self.GhostEntity = nil
	end

	return true
end

function SWEP:PrimaryAttack()
	
	if !self:CanPrimaryAttack() || CLIENT then return end
	
	local tr = self.Owner:GetEyeTrace()
	
	if self.GhostEntity then
	
		local barrier_count = self.Owner:GetNWInt("ta-barriercount")
		local tr = self.Owner:GetEyeTrace()
		local dist = tr.HitPos:Distance(self.Owner:GetPos())
	
		if barrier_count >= 4 then 
			
			self.Owner:ChatPrint("You already have four barriers!")
			
		elseif not self:ValidTrace() then
			
			self.Owner:ChatPrint("That is not a valid location.")
			
		else
			
			local barr = ents.Create("ent_barrier")
			barr:SetType(self.GhostEntity:GetNWInt("Type"),self.Owner,self.GhostEntity:GetNWInt("RaiseUp"))
			barr:SetPos(self.GhostEntity:GetPos())
			barr:SetAngles(self.GhostEntity:GetAngles())
		
			barr:Spawn()
			barr:Activate()
			barr:SetNWEntity("ta-owner",self.Owner)
			
			self.Owner:SetNWInt("ta-barriercount",barrier_count + 1)
			self.Owner:EmitSound(table.Random(self.build_sounds))
			
		end
		
		self.GhostEntity:Remove()
		self.GhostEntity = nil
		self.Yaw = 90
		
	elseif ValidEntity(tr.Entity) and tr.Entity:GetClass() == "ent_barrier" and self.Owner:GetPos():Distance(tr.HitPos) < 100 then
		
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		
		self.Owner:Freeze(true)
		self.Owner:SetVelocity( Vector(0,0,0) )
		timer.Simple(2,function() self.Owner:Freeze(false) end)
		
	else
		umsg.Start("Techie-ShowMenu",self.Owner) umsg.End()
	end
	
end

function SWEP:ValidTrace( )

	local tr = self.Owner:GetEyeTrace()
	local dist =tr.HitPos:Distance(self.Owner:GetPos())
	local pos = self.GhostEntity:GetPos()
	local test_points = {
		pos + self.GhostEntity:OBBMins(),
		pos + self.GhostEntity:OBBMaxs(),
		pos + Vector(0,0,100),
		pos + self.GhostEntity:GetRight() * 50,
		pos + self.GhostEntity:GetRight() * -50,
	}
	for _,v in pairs(test_points) do if not util.IsInWorld(test_points) then return false end end
	
	return dist < 300 && !tr.HitNonWorld && math.abs(tr.HitPos.z - self.Owner:GetPos().z) < 50
end
	
function SWEP:SecondaryAttack()

	if !self:CanPrimaryAttack() || CLIENT || self:GetNextPrimaryFire() > CurTime() then return end
	
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	
	if self.Owner:GetShootPos():Distance(tr.HitPos) < 80 then
		timer.Simple(0.15,function()
			local owner = ent:GetNWEntity("ta-owner")
			if ent:GetClass() == "ent_barrier" and owner == self.Owner then
				self.Owner:SetNWInt("ta-barriercount",self.Owner:GetNWInt("ta-barriercount") - 1)
				ent:Remove()
			elseif ent == self.Owner:GetNWEntity("ta-turret") then
				ent:Remove()
				self.Owner:SetNWEntity("ta-turret",nil)
			elseif ent == self.Owner:GetDispenser() then
				ent:Remove()
				self.Owner:SetDispenser(nil)
				self.Owner:SetDispenserTime(0)
			else
				local bullet = {};
				bullet.Num = 1
				bullet.Src = self.Owner:GetShootPos();
				bullet.Dir = self.Owner:GetAimVector();
				bullet.Spread = Vector( 0.01,0.01,0.01);
				bullet.Tracer = 1
				bullet.Force = 100
				bullet.Damage = 45;
				self.Owner:FireBullets( bullet );
			end
			self.Weapon:EmitSound("weapons/crowbar/crowbar_impact"..math.random(1,2)..".wav")
		end)
	else
		timer.Simple(0.15,function() self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav") end)
	end
	self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self:SetNextPrimaryFire( CurTime() + 0.8 )
	
end

function SWEP:Think()
	
	if CLIENT then return end
	
	self:UpdateGhost()
	
end

function SWEP:MakeGhost( n )
	self.GhostEntity = ents.Create( "prop_physics" )
	
	if (!self.GhostEntity:IsValid()) then
		self.GhostEntity = nil
		return
	end
	
	local info = self.types[n]
	
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
	local cent,min,max = self.GhostEntity:OBBCenter(),self.GhostEntity:OBBMins(),self.GhostEntity:OBBMaxs()
	
	if self:ValidTrace() then
		self.GhostEntity:SetColor( 50, 255, 50, 200 )
	else
		self.GhostEntity:SetColor( 255, 50, 50, 200 )
	end
	
	if self.Owner:KeyDown(IN_USE) then self.Yaw = self.Yaw + 1 end
	
	self.GhostEntity:SetAngles( Angle(0,self.Owner:GetForward():Angle().yaw + self.Yaw,0) )
	
	self.GhostEntity:SetPos( self.Owner:GetEyeTrace().HitPos + Vector(0,0,self.GhostEntity:GetNWInt("RaiseUp")) )
	
end

