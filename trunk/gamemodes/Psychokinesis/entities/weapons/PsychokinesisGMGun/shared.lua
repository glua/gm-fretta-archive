//General Settings \\
AddCSLuaFile("shared.lua")
resource.AddFile( "materials/weapons/phychoicon.vmt" )
resource.AddFile( "materials/weapons/phychoicon.vtf" )
resource.AddFile( "models/weapons/v_fists.mdl" )
resource.AddFile( "models/weapons/w_fists.mdl" )

SWEP.PrintName 		= "Psychokinesis Gamemode Gun" // your sweps name
if( CLIENT )then SWEP.WepSelectIcon	= surface.GetTextureID("weapons/phychoicon") end
 
SWEP.Author 		= "Douglas Huck" // Your name 
SWEP.Instructions 	= "Right Click a Prop to add it to the queue. Left click to fire a prop." // How do pepole use your swep ? 
SWEP.Contact 		= "faceguydb@gmail.com" // How Pepole chould contact you if they find bugs, errors, etc 
SWEP.Purpose 		= "Have some fun with physics." // What is the purpose with this swep ? 
 
SWEP.AdminSpawnable = true // Is the swep spawnable for admin 
SWEP.Spawnable 		= true // Can everybody spawn this swep ? - If you want only admin keep this false and adminsapwnable true. 
 
SWEP.ViewModelFOV 	= 64 // How much of the weapon do u see ? 
SWEP.ViewModel 		= "models/weapons/v_fists.mdl" // The viewModel, the model you se when you are holding it-.- 
SWEP.WorldModel 	= "models/weapons/w_fists.mdl" // The worlmodel, The model yu when it's down on the ground 
 
SWEP.AutoSwitchTo 	= false // when someone walks over the swep, chould i automatectly change to your swep ? 
SWEP.AutoSwitchFrom = true // Does the weapon get changed by other sweps if you pick them up ?
 
SWEP.Slot 			= 1 // Deside wich slot you want your swep do be in 1 2 3 4 5 6 
SWEP.SlotPos = 1 // Deside wich slot you want your swep do be in 1 2 3 4 5 6 
 
SWEP.HoldType = "melee" // How the swep is hold Pistol smg greanade melee 
 
SWEP.FiresUnderwater = true // Does your swep fire under water ? 
 
SWEP.Weight = 5 // Chose the weight of the Swep 
 
SWEP.DrawCrosshair = true // Do you want it to have a crosshair ? 
 
SWEP.Category = "Match Head Studios" // Make your own catogory for the swep 
 
SWEP.DrawAmmo = false // Does the ammo show up when you are using it ? True / False 

SWEP.base = "weapon_base" 
//General settings\\
 
//PrimaryFire Settings\\ 
SWEP.Primary.Automatic = false // Is the swep automatic ? 
SWEP.Primary.Delay = 0.1 // How long time before you can fire again 
SWEP.Primary.Force = 10000 // The force of the shot
SWEP.Primary.Sound = "d1_trainstation_01.DoorSlot" // Fire sound
//PrimaryFire settings\\
 
//Secondary Fire Variables\\ 
SWEP.Secondary.Automatic = true // Is it automactic ? 
SWEP.Secondary.Delay = 0.05 // How long you have to wait before fire a new shot 
//Secondary Fire Variables\\
 
//SWEP:Initialize\\ 
function SWEP:Initialize() 
	util.PrecacheSound(self.Primary.Sound)
	Primary2 = "physics/metal/paintcan_impact_hard1.wav" // Can't Fire sound
	util.PrecacheSound(Primary2) 
        self:SetWeaponHoldType( self.HoldType )
		self.picked = nil // Define the table.
end 
//SWEP:Initialize\\
 
//SWEP:PrimaryFire\\ 
function SWEP:PrimaryAttack() 
	if ( !self:CanPrimaryAttack() ) then return end 
	if not(self.picked == nil)then
		self:EmitSound(Sound(self.Primary.Sound)) 
		ent = self.picked
		if(ent == NULL)then return end
		self.picked = nil
		if(SERVER)then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			ent:SetCollisionGroup(COLLISION_GROUP_NONE)
			ent:SetColor(255, 255, 255, 255)
			ent:GetPhysicsObject():EnableMotion(true)
			ent:GetPhysicsObject():AddVelocity(self.Owner:GetForward() * self.Primary.Force)
			self.Owner:SetAnimation( PLAYER_ATTACK1 );
		end
	else
		self:EmitSound(Sound(Primary2))
	end
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end 
//SWEP:PrimaryFire\\

//SWEP:SecondaryFire\\
function SWEP:SecondaryAttack() 
	if ( !self:CanSecondaryAttack() ) then return end
	if (self.picked == nil)then
		self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		ent = self.Owner:GetEyeTraceNoCursor().Entity
		if not ent:IsValid() then return end
		if ent:IsPlayer() then return end
		if (math.Dist(ent:GetPos().x, ent:GetPos().y, self.Owner:GetPos().x, self.Owner:GetPos().y) >= 250)then return end
		if (math.abs(ent:GetPos().z-self.Owner:GetPos().z) >= 140)then return end
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		self.picked = ent
		ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		ent:SetColor(255, 255, 255, 130)
		ent:SetNWEntity(1, self.Owner)
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
	end
end
//SWEP:SecondaryFire\\

//Custom Functions\\
function getDimensionZ(ent)
    local min,max = ent:WorldSpaceAABB()
    local offset=max-min
    return offset.z
end
//Custom Functions\\

//SWEP:Think\\
function SWEP:Think()
	if (self.picked == NULL)then
		self.picked = nil
	end
	if not(self.picked == nil)then
		if(SERVER)then
			if( self.Owner:Crouching())then
				dist = Vector(0,0,28)
			else
				dist = Vector(0,0,64)
			end
			self.picked:SetPos(self.Owner:GetPos() + (self.Owner:GetForward()*50) +dist)
			self.picked:SetAngles(self.Owner:GetAngles())
		end
	end
end
//SWEP:Think\\

function SWEP:OnRemove()
	if not(self.picked == nil)then
		ent = self.picked
		if(ent == NULL)then return end
		self.picked = nil
		if(SERVER)then
			ent:SetCollisionGroup(COLLISION_GROUP_NONE)
			ent:SetColor(255, 255, 255, 255)
			ent:GetPhysicsObject():EnableMotion(true)
			ent:GetPhysicsObject():AddVelocity(Vector(0,0,-1))
		end
	end
end