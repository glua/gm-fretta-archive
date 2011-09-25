AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
	ent:Spawn()
	ent:Activate()
	ent:SetAngles(plr:GetAngles())
	
	return ent

end

function ENT:Initialize()

	local ent = ents.Create( "prop_vehicle_prisoner_pod" )
	ent:SetPos( self:GetPos() )
	ent:SetModel( "models/nova/airboat_seat.mdl") 
	ent:Spawn()
	ent:Activate()
	
	local turret = ents.Create("prop_physics")
	turret:SetPos( ent:GetPos() + ent:GetRight() * 20 )
	turret:SetModel("models/props_c17/canister01a.mdl")
	turret:Spawn()
	turret:Activate()
	ent:SetNWEntity("turret",turret)
	
	turret:SetMoveType(MOVETYPE_NONE)
	ent:SetMoveType(MOVETYPE_NONE)
	
	self.Turret = turret
	self.Seat = ent
	self.Cooldown = 0
	
	self.Primary = {}
	/*self.Primary.Shoot = Sound("NPC_Strider.Shoot")
	self.Primary.Charge = Sound("NPC_Strider.Charge")
	self.Primary.Explode = Sound("Weapon_Mortar.Impact")*/
	self.Primary.Shoot = Sound("npc/strider/fire.wav")
	self.Primary.Charge = Sound("npc/strider/charging.wav")
	self.Primary.Explode = Sound("weapons/mortar/mortar_explode3.wav")
	self.Primary.Recoil = 10
	
	timer.Create("changeAngles"..self:EntIndex(),0.001,0,function()
		if !ValidEntity(self) || !ValidEntity( self.Seat ) || !ValidEntity( self.Turret)  then return end
		local pl = self.Seat:GetDriver()
		if ValidEntity( pl ) then
			self.Owner = pl
			self:SetSolid( SOLID_VPHYSICS )
			self.Turret:SetPos( self.Seat:GetPos() + self.Seat:GetRight() * 20 + vector_up * 30 )
			self:SetPos( self.Seat:GetPos() )
			
			local ang = pl:GetAimVector():Angle()
			ang.pitch = ang.pitch + 90
			local seatyaw = self.Seat:GetAngles().yaw 
			self.Turret:SetAngles( ang )
			if math.abs( seatyaw - (ang.yaw - 100) ) > 30 then 
				local n = Lerp(0.05,seatyaw,ang.yaw-100)
				self.Seat:SetAngles( Angle( 0,n, 0 ) )
			end
			
			if pl:KeyDown( IN_ATTACK ) and pl:KeyDownLast( IN_ATTACK ) and self.Cooldown - CurTime() < 0 then
				self.Cooldown = CurTime() + 3
				self:ShootLaser()
			end
		else
			self:SetSolid(SOLID_NONE)
		end
	end)
	
	self:SetModel("models/nova/airboat_seat.mdl")
	self:SetNoDraw( true )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType(MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionBounds( self:OBBMins() * 10,self:OBBMaxs() * 10 )
	
end

function ENT:ShootLaser()

	self.Turret:EmitSound( self.Primary.Charge )
	
	local fx = EffectData()
	fx:SetEntity(self.Owner)
	fx:SetAttachment(1)
	util.Effect("stridcan_charge",fx)
	
	timer.Simple( SoundDuration( self.Primary.Charge ) - 1.3, function()
	
		if !ValidEntity(self.Owner) ||  !ValidEntity(self.Turret) then return end
	
		local tr = self.Owner:GetEyeTrace()
	
		self.Owner:ViewPunch( Angle( math.Rand( -0.2, -0.1 )  * self.Primary.Recoil, math.Rand( -0.1 ,0.1 ) * self.Primary.Recoil, 0 ) )
		self.Turret:EmitSound( self.Primary.Shoot )
		
		local fx = EffectData()
		fx:SetEntity(self.Owner)
		fx:SetOrigin(tr.HitPos)
		fx:SetAttachment(1)
		util.Effect("stridcan_fire",fx)
		util.Effect("stridcan_mzzlflash",fx)
		
		timer.Simple( ( tr.HitPos - self.Owner:GetShootPos() ):Length() / 8000, function()

			if !ValidEntity(self.Owner) ||  !ValidEntity(self.Turret) then return end
			
			util.BlastDamage(self.Turret, self.Owner, tr.HitPos + tr.HitNormal * 5, 400, 100)
			
			local fx = EffectData()
			fx:SetOrigin(tr.HitPos)
			fx:SetNormal(tr.HitNormal)
			util.Effect("stridcan_expld",fx)
			
			timer.Simple( 0.01, function() 
			
				if !ValidEntity(self.Owner) ||  !ValidEntity(self.Turret) then return end
			
				local targname = "dissolveme"..self:EntIndex()
				for k,ent in pairs( ents.FindInSphere( tr.HitPos + tr.HitNormal * 5 , 800 ) ) do

					if ent:GetMoveType() == 6 then
						ent:SetKeyValue("targetname",targname)
						
						local numbones = ent:GetPhysicsObjectCount()
						for bone = 0, numbones - 1 do 

							local PhysObj = ent:GetPhysicsObjectNum(bone)
							if PhysObj:IsValid()then
								PhysObj:SetVelocity(PhysObj:GetVelocity()*0.04)
								PhysObj:EnableGravity(true)
							end

						end
						
					end

				end
				
				local dissolver = ents.Create("env_entity_dissolver")
				dissolver:SetKeyValue("dissolvetype",0)
				dissolver:SetKeyValue("magnitude",0)
				dissolver:SetPos( tr.HitPos + tr.HitNormal * 5)
				dissolver:SetKeyValue("target",targname)
				dissolver:Spawn()
				dissolver:Fire("Dissolve",targname,0)
				dissolver:Fire("kill","",0.1)
				
				dissolver:EmitSound(self.Primary.Explode)
			end )
		end)
	end)
end

function ENT:OnTakeDamage( dmg )
	local pl = self.Seat:GetDriver()
	if ValidEntity( pl ) then 
		dmg:SetDamage( dmg:GetDamage() * 3 )
		pl:TakeDamageInfo( dmg )
		if pl:Health() == 0 then pl:Kill() end
	end
end

function ENT:OnRemove()
	
	timer.Destroy("changeAngles"..self:EntIndex())
	
	if ValidEntity( self.Seat ) then self.Seat:Remove() end
	if ValidEntity( self.Turret ) then self.Turret:Remove() end

end
