
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.RespawnTime = 3
ENT.Timer = 0
ENT.Bonuses = { "prop_cashbox" }

function ENT:Initialize()

end

function ENT:KeyValue( key, value )

	if key == "frequency" then
	
		self.RespawnTime = math.Clamp( tonumber( value ), 1, 300 )
	
	end
	
end

function ENT:Think()

	if self.Timer < CurTime() then
	
		local numspawners = #ents.FindByClass( "prop_spawner" )
		local numplayers = #player.GetAll()
		local respawntime =  math.Clamp( numspawners * ( 1.25 / numplayers ), 1, 30 )
	
		self.Timer = CurTime() + respawntime
		self:SpawnProp()
		
	end	
	
end

function ENT:SpawnProp()

	local tbl = ents.FindByClass( "prop_phys*" )

	for k,v in pairs( tbl ) do

		if v:GetPos():Distance( self.Entity:GetPos() ) < 100 then
			v:Remove()
		end
	
	end

	if #tbl > 100 then return end
	
	local tbl = GAMEMODE:GetRandomPropInfo()
	local name = "prop_physics"
	
	if tbl.Bonus then
		name = tbl.Bonus
	end
	
	local prop = ents.Create( name )
	prop:SetPos( self.Entity:GetPos() )
	prop:SetAngles( VectorRand():Angle() )
	prop:SetModel( tbl.Model )
	prop:Spawn()
	prop:SetHealth( 9000 )
	prop.Name = tbl.Name
	prop.HP = tbl.HP
	prop.Price = tbl.Price
	prop.Gibs = tbl.Gibs
	
	local phys = prop:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		
		phys:SetMass( 50 )
		phys:AddAngleVelocity( Angle( math.random( -5000, 5000 ), math.random( -5000, 5000 ), math.random( -5000, 5000 ) ) )
		phys:ApplyForceCenter( VectorRand() * 10000 )
		
	end
	
end