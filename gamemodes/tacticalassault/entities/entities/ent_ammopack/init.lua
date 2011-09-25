AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 1 )
	ent:Spawn()
	ent:Activate()	
	
	return ent

end


function ENT:Initialize()	

	self:SetModel( "models/props_junk/wood_crate002a.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:Fire("setdamagefilter","0",0)

	local phys = self:GetPhysicsObject()  	
	if phys:IsValid() then  		
		phys:Wake()  	
	end
	
	self.NativeTeam = 0
	
end

function ENT:SetNativeTeam(t) self.NativeTeam = t end

function ENT:Use(pl,call)
	if pl:IsPlayer() then
		
		if pl:Team() != self.NativeTeam then
			// Explode
			self.Entity:Remove()
		else
			// Spawn ammo crates
			local crate = ents.Create("item_ammo_crate")
			crate:SetPos(self.Entity:GetPos())
			crate:SetAngles(Angle(0,pl:GetForward():Angle().yaw,0))
			crate:SetKeyValue("AmmoType","1")
			crate:Spawn()
			crate:Activate()
			
			local crate2 = ents.Create("item_ammo_crate")
			crate2:SetPos(self.Entity:GetPos() + crate:GetRight() * 100)
			crate:SetAngles(Angle(0,pl:GetForward():Angle().yaw,0))
			crate2:SetKeyValue("AmmoType","4")
			crate2:Spawn()
			crate2:Activate()
			

			timer.Simple(20,function() 
				crate2:Remove()
				crate:Remove()
			end)
			
			self.Entity:Remove()
			self:Remove()
		end	
		
	end
end


function ENT:OnRemove()

end








