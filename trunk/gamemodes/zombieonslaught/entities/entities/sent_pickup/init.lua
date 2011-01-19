
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Types = {}

ENT.Types[1] = {}
ENT.Types[1].Name = "Food"
ENT.Types[1].Sound = Sound("items/itempickup.wav")
ENT.Types[1].Model = "models/props_junk/garbage_bag001a.mdl"
ENT.Types[1].Func = function( ply ) ply:Heal( 10 ) end

ENT.Types[2] = {}
ENT.Types[2].Name = "Pills"
ENT.Types[2].Sound = Sound("weapons/physcannon/physcannon_claws_close.wav")
ENT.Types[2].Model = "models/props_lab/jar01b.mdl"
ENT.Types[2].Func = function( ply ) ply:NeutralizePoison() end

ENT.Types[3] = {}
ENT.Types[3].Name = "Health Vial"
ENT.Types[3].Sound = Sound("items/medshot4.wav")
ENT.Types[3].Model = "models/healthvial.mdl"
ENT.Types[3].Func = function( ply ) ply:Heal( 25 ) end

ENT.Types[4] = {}
ENT.Types[4].Name = "Ammunition"
ENT.Types[4].Sound = Sound("weapons/c4/c4_disarm.wav")
ENT.Types[4].Model = "models/items/boxbuckshot.mdl"
ENT.Types[4].Func = function( ply ) ply:SupplyAmmo( 0.8 ) end

util.PrecacheModel( "models/props_lab/jar01b.mdl" )
util.PrecacheModel( "models/props_junk/garbage_bag001a.mdl" )
util.PrecacheModel( "models/healthvial.mdl" )
util.PrecacheModel( "models/items/boxbuckshot.mdl" )

function ENT:Initialize()
		
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self.Entity:DrawShadow( false )
		
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableCollisions(true)
		phys:SetMass(10) 
		phys:ApplyForceCenter( VectorRand() * 50 )
	end
	
	self.DieTime = CurTime() + 60

end

function ENT:Think() 

	if self.DieTime < CurTime() then
	
		self.Entity:Remove()
	
	end

end 

function ENT:Use( ent, caller )

	if self.TakeOnce then return end
	self.TakeOnce = true
	
	if ent:IsPlayer() and ent:Team() == TEAM_ALIVE then
	
		ent:Notice( "Picked up item: "..self.PickupName, 5, 50, 255, 50 )
		
		self.PickupFunc( ent )
		self.Entity:EmitSound( self.PickupSound )

	end
	
	self.Entity:Remove()

end

function ENT:SetType( t )

	t = t or math.random(1,4)
	self.PickupType = t
	
	self.Entity:SetModel( self.Types[ t ].Model )
	self.PickupSound = self.Types[ t ].Sound
	self.PickupFunc = self.Types[ t ].Func
	self.PickupName = self.Types[ t ].Name

end
