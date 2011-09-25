
function EFFECT:Init( data )

	local ent = data:GetEntity()
	
	if not ValidEntity( ent ) then
	
		self.LifeTime = -1
		return
		
	end
	
	self.LifeTime = CurTime() + 20
	
	local find = string.lower( ent:GetModel() )
	local tblpos = data:GetScale()
	local tbl = {"models/props/cs_office/computer_caseb_p5a.mdl"}

	for k,v in pairs( GAMEMODE.Props ) do
		if string.find( find, v.Model ) then
			tbl = GAMEMODE.Gibs[v.Gibs]
		end
	end

	local model = tbl[tblpos]
	
	local low, high = ent:WorldSpaceAABB()
	local pos = Vector( math.Rand(low.x,high.x), math.Rand(low.y,high.y), math.Rand(low.z,high.z) )

	self.Entity:SetModel( model )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS ) 
	self.Entity:SetPos( ent:GetPos() ) //pos
	self.Entity:SetAngles( ent:GetAngles() )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if not ValidEntity( phys ) then
	
		self.Entity:Remove()
		MsgN("\nError! "..model.." is not a valid prop model!\n")
		
	end
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:SetVelocity( VectorRand() * 200 )
		phys:AddAngleVelocity( Angle( math.random(-500,500), math.random(-500,500), math.random(-500,500) ) )
	
	end
end

function EFFECT:Think( )

	return self.LifeTime > CurTime() 
	
end

function EFFECT:Render()

	self.Entity:DrawModel()

end



