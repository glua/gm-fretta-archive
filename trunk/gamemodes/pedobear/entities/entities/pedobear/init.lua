AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

resource.AddFile( "materials/pedobear/pedobear.vmt" )
resource.AddFile( "materials/pedobear/pedobear1.vmt" )
resource.AddFile( "materials/pedobear/pedobear_t.vmt" )
resource.AddFile( "materials/pedobear/pedobear.vtf" )
resource.AddFile( "materials/pedobear/pedobear1.vtf" )
local rapesound1=Sound("*vo/npc/barney/ba_pain06.wav")
local rapesound2=Sound("*vo/npc/male01/pain07.wav")
local breath="npc/fast_zombie/breathe_loop1.wav"

local PosVector=Vector(0,0,50)

function ENT:SpawnFunction(ply, tr)
 if not tr.Hit then return end
 local ent = ents.Create( self.Classname )
 ent:SetPos( tr.HitPos+PosVector+Vector(0,0,100))
 ent:Spawn()
 ent:Activate()
 return ent
end
/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
self:SetModel( "models/props_junk/PopCan01a.mdl" )
	
  self.Entity:PhysicsInitBox( Vector( -20, -20, -72), Vector( 20,20,72 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
  
	self.Entity:SetCollisionBounds( Vector( -20, -20, -72), Vector( 20,20,72 ) )
	self.LightColor = Vector( 0, 0, 0 )
end

function ENT:OnRemove( )
end

function ENT:Think( )
	if(GAMEMODE:InRound())then
		distance = 1000000
		curply = nil
		for _,ply in ipairs(player:GetAll()) do
			if(self.Entity:GetPos():Distance( ply:GetPos()) < distance) && (ply:Alive()) && (ply:Team() != TEAM_UNASSIGNED) && (ply:Team() != TEAM_SPECTATOR)then
				distance = self.Entity:GetPos():Distance( ply:GetPos())
				curply = ply
			end
		end
		if(curply == nil)then return end
		if(curply:IsValid())then
			if(curply:IsPlayer())then
				mult=200
				dist = curply:GetPos()-self.Entity:GetPos()
				xmulti = (dist.x/(math.abs(dist.x)+math.abs(dist.y)))*mult
				ymulti = (dist.y/(math.abs(dist.x)+math.abs(dist.y)))*mult
				self.Entity:GetPhysicsObject():AddVelocity(Vector(xmulti, ymulti, 0)-(self.Entity:GetPhysicsObject():GetVelocity()/5))
			end
		end
	else
		self.Entity:Remove()
	end
end

function ENT:Touch( ply )
	if(GAMEMODE:InRound())then
		if((ply:IsPlayer())  && (ply.dead == false))then
			if(math.random(0,1)==1) then
				ply:EmitSound(rapesound1)
			else
				ply:EmitSound(rapesound2)
			end
			GAMEMODE:PedoDeath(ply, self.Entity, {})
			ply.dead = true
			ply:Kill()
		end
	end
end
