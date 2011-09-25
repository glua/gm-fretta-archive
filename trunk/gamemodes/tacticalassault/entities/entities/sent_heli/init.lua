AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 10 )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function ENT:Initialize()

	self.MaxHealth = 1000
	self.Damage = 0
	self.OnFire = false
	self.LastUse = CurTime()
	self.Flying = false
	self.Soldiers = {}
	self.PropellerInc = 0
	
	self:SetUseType(SIMPLE_USE)
	
	self:SetPos( self:GetPos() + Vector(-2,0,5) )
	self:SetModel("models/ta/vehicles/helicopter_main.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake() 
		phys:SetMass(400)
	else ErrorNoHalt("Heli has no physics!") end

	local rotor = ents.Create("prop_physics")
	rotor:SetPos( self:GetPos() + Vector(-30,0,160) )
	rotor:SetModel("models/ta/vehicles/helicopter_rotor.mdl")
	rotor:Spawn()
	rotor:Activate()
	local phys = rotor:GetPhysicsObject()
	if IsValid(phys) then 
		phys:Wake()
		phys:SetMass( 100 )
	end
	rotor:SetParent(self)
	//constraint.Axis(self,rotor,0,0,Vector(0,0,0),Vector(0,0,0),0,0,0,1)
	//constraint.Keepupright( rotor, Angle(0,0,0), 0, 15 )	
	self.Rotor = rotor
	self.TopProp = rotor
	
	local seat = ents.Create( "prop_vehicle_prisoner_pod" )
	seat:SetPos( self:GetPos() + Vector(123,23,60) )
	seat:SetModel( "models/Nova/airboat_seat.mdl") 
	seat:SetAngles( Angle(0,270,0) )
	seat:Spawn()
	seat:Activate()
	seat:SetParent(self)
	seat:SetNoDraw(true)
	self.Driver = seat
	
	local seat = ents.Create( "prop_vehicle_prisoner_pod" )
	seat:SetPos( self:GetPos() + Vector(123,-21,60) )
	seat:SetModel( "models/Nova/airboat_seat.mdl") 
	seat:SetAngles( Angle(0,270,0) )
	seat:Spawn()
	seat:Activate()
	seat:SetParent(self)
	seat:SetNoDraw(true)
	self.Passenger = seat
	
	/**************************************** STOLEN FROM SAKARIAS HELICOPTER ****************************************/
	self.HeliStart = CreateSound(self.Entity,"HelicopterVehicle/HeliStart.mp3")
	self.HeliStop = CreateSound(self.Entity,"HelicopterVehicle/HeliStop.mp3")
	self.HeliExt = CreateSound(self.Entity,"HelicopterVehicle/HeliLoopExt.mp3")
	self.HeliInt = CreateSound(self.Entity,"HelicopterVehicle/HeliLoopInt.mp3")
	self.MissileAlert = CreateSound(self.Entity,"HelicopterVehicle/MissileNearby.mp3")
	self.ShootSound =  CreateSound(self.Entity,"HelicopterVehicle/Shooting.mp3")
	self.StopShootSound =  CreateSound(self.Entity,"HelicopterVehicle/StopShooting.mp3")
	self.CrashAlarm = CreateSound(self.Entity,"HelicopterVehicle/CrashAlarm.mp3")
	self.LowHealth =  CreateSound(self.Entity,"HelicopterVehicle/LowHealth.mp3")
	self.MinorAlarm = CreateSound(self.Entity,"HelicopterVehicle/MinorAlarm.mp3")
	self.MissileShoot = CreateSound(self.Entity,"HelicopterVehicle/MissileShoot.mp3")
	self.SoundLoopDelay = CurTime()
	self.HeliStartup = 0
	
	self:StartMotionController()
	
end

function ENT:OnTakeDamage( dmg )
	self.Damage = self.Damage + dmg:GetDamage()
	self:SetNWInt("ta-health",self.MaxHealth - self.Damage)
	print(self.Damage)
	if self.Damage >= self.MaxHealth then
		self:Remove()
	elseif self.Damage >= self.MaxHealth * 3/4 and not self.OnFire then
		self.OnFire = true
		local fire = ents.Create("env_fire_trail")
		fire:SetPos( self:GetPos() + Vector(0,-90,50) )
		fire:Spawn()
		fire:SetParent( self.Jeep )
		self.EngineFire = fire
	end
end

function ENT:Think()
	self:NextThink(CurTime())
	self.UserOne = self.Driver:GetDriver()
	
	local driver = self.Driver:GetDriver()
	if ValidEntity(driver) then
		self.CanFly = 1
		self.PropellerInc = math.Approach(self.PropellerInc,10,0.025)	
		if driver:KeyDownLast(IN_USE) then
	
		end
		if self.HeliStartup == 0 then
			self.HeliStartup = CurTime() + 8
		end
		self.HeliStart:Play()
		self.HeliStop:Stop()
	else
		self.HeliStartup = 0
		self.HeliInt:Stop()
		self.HeliExt:Stop()
		self.HeliStart:Stop()
		self.HeliStop:Play()
		self.CanFly = 0
		self.PropellerInc = math.Approach(self.PropellerInc,0,0.025)
	end
	self:MoveRotor( self.PropellerInc )
	
	if self.CanFly == 1 and self.HeliStartup - CurTime() <= 0  and self.SoundLoopDelay < CurTime() then
		self.HeliExt:Stop()
		self.HeliInt:Stop()	
		self.HeliExt:Play()
		self.HeliInt:Play()
		self.SoundLoopDelay = CurTime() + 9
	end
	
	for _,v in ipairs(self.Soldiers) do
		if not v:Alive() then
			self:RemoveSoldier(v,false,false)
		elseif not ValidEntity(v) then
		end
	end
		
	return true
end

function ENT:MoveRotor( deg )
	local ang = self.Rotor:GetAngles()
	ang:RotateAroundAxis( self:GetUp(),deg)
	self.Rotor:SetAngles(ang)
end

function ENT:RemoveSoldier( pl, kill, spawn )
	pl:UnSpectate()
	if kill then pl:Kill()
	elseif spawn then 
		pl:Spawn()
		pl:SetPos(self:GetPos()+Vector(100,100,5))
	end
	pl:SetScriptedVehicle(NULL)
	self.Soldiers[pl:UniqueID()] = nil
end

function ENT:Use( activator, caller )
	
	if CurTime() - self.LastUse < 0 then return end
	self.LastUse = CurTime() + 0.4
	
	if ValidEntity(self.Soldiers[activator:UniqueID()]) then
		local pl = self.Soldiers[activator:UniqueID()]
		self:RemoveSoldier( pl, false, true )
		return
	end
	
	local pos = activator:GetShootPos()
	local d_drive, d_pass = pos:Distance(self.Driver:GetPos()),pos:Distance( self.Passenger:GetPos() )
	if d_pass < 200 and d_pass < d_drive and not ValidEntity( self.Passenger:GetDriver() ) then
		activator:EnterVehicle( self.Passenger)
	elseif d_drive < 200 and d_drive < d_pass and not ValidEntity( self.Driver:GetDriver() ) then
		activator:EnterVehicle( self.Driver )
	else
		local pl = activator
		pl:SetScriptedVehicle( self )
		pl:Spectate(OBS_MODE_CHASE)
		pl:StripWeapons()
		self.Soldiers[pl:UniqueID()] = pl
	end
end

 local function SetPlyAnimation( pl, anim )

	 if pl:InVehicle( ) then
	 local Veh = pl:GetVehicle()
	
		if string.find(Veh:GetModel(), "models/nova/jeep_seat") || string.find(Veh:GetModel(),"models/nova/airboat_seat") then 
		
			local seq = pl:LookupSequence( "sit" )
				
			pl:SetPlaybackRate( 1.0 )
			pl:ResetSequence( seq )
			pl:SetCycle( 0 )
			return true

		end
	end
end
hook.Add( "SetPlayerAnimation", "SetHeliChairAnim", SetPlyAnimation )

function ENT:PhysicsUpdate( physics )

	local entphys = self:GetPhysicsObject()
	print(self.PropellerInc)
	if self.CanFly == 1 and self.PropellerInc > 7 then
	
		local pl = self.Driver:GetDriver()
		local PowForce = 0
		local UsedKey = 0
			
		if pl:KeyDown( IN_FORWARD ) then
			entphys:AddAngleVelocity( Vector(0,2,0 ) )	
			entphys:ApplyForceCenter( self.Entity:GetForward() * 2000 )  --4.27
			UsedKey = 1
		end
	
		if pl:KeyDown( IN_BACK ) then
			entphys:AddAngleVelocity( Vector(0,-8,0 ) )
			UsedKey = 2			
		end
		
		if pl:KeyDown( IN_JUMP ) then	
			PowForce = PowForce + 3000
		end
	
		if  pl:KeyDown( IN_WALK  ) then
			PowForce = PowForce - 5000
		end
		
		if UsedKey == 1 or UsedKey == 2 then
			PowForce = PowForce + 500
		end
		
		if pl:KeyDown( IN_MOVELEFT ) then
			entphys:AddAngleVelocity( Vector(-7,0,3 ) )	
		end
	
		if pl:KeyDown( IN_MOVERIGHT ) then
			entphys:AddAngleVelocity( Vector(7,0,-3 ) )			
		end	
		
		entphys:ApplyForceCenter(self.Entity:GetUp() * ( (PowForce) + (self.PropellerInc * 4.20 * 150 ) ) )  --4.27
	end

end

function ENT:OnRemove()

/*	local gibs = {
		"models/props_vehicles/carparts_wheel01a.mdl",
		"models/props_vehicles/carparts_wheel01a.mdl",
		"models/props_vehicles/carparts_wheel01a.mdl",
		"models/props_vehicles/carparts_wheel01a.mdl",
		"models/combine_apc_destroyed_gib02.mdl",
		"models/combine_apc_destroyed_gib03.mdl",
		"models/combine_apc_destroyed_gib04.mdl",
		"models/combine_apc_destroyed_gib05.mdl",	
		"models/combine_apc_destroyed_gib06.mdl",	
		"models/Nova/airboat_seat.mdl",		
		 "models/nova/jeep_seat.mdl",
		  "models/nova/jeep_seat.mdl",
		//  "models/buggy.mdl",
	}
	local props = {}

	for _,v in ipairs( gibs ) do
		local prop = ents.Create("prop_physics")
		prop:SetPos( self:GetPos() + Vector( math.random() * 20, math.random() * 20, math.random(1,2) * 30 ) )
		prop:SetAngles( Angle(math.random() * 360,math.random() * 360,math.random() * 360) )
		prop:SetModel(v)
		prop:Spawn()
		prop:Activate()
		local vec = VectorRand() * 100
		vec.z = math.Clamp(vec.z,-5,1000)
		prop:SetVelocity( VectorRand() * 100 )
		table.insert(props,prop)
	end
	timer.Simple(10,function() for _,v in ipairs(props) do v:Remove() end end) */

	local ta = {}
	function ta.Explosion(pl,pos,mag)
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetNormal( pos:GetNormalized() )
		util.Effect( "explosion", effectdata )
		
		local explosion = ents.Create( "env_explosion" )
		explosion:SetPos(pos)
		explosion:SetKeyValue( "iMagnitude" , tostring(mag) )
		explosion:SetPhysicsAttacker(pl)
		explosion:SetOwner(pl)
		explosion:Spawn()
		explosion:Fire("explode","",0)
		explosion:Fire("kill","",0 )
	end
	
	// EXPLOSION HERE
	//ta.Explosion( nil, self:GetPos(),250)
	ParticleEffect( "building_explosion", self:GetPos(), Angle(0,0,0), nil )
	
	for _,v in pairs(self.Soldiers) do
		if ValidEntity(v) then
			self:RemoveSoldier(v,true)
		end
	end
	if ValidEntity( self.Driver:GetDriver() ) then self.Driver:GetDriver():Kill() end
	if ValidEntity( self.Passenger:GetDriver() ) then self.Passenger:GetDriver():Kill() end
	
	local to_remove = { self.Rotor,self.EngineFire,self.Driver,self.Passenger }
	for _,v in ipairs(to_remove) do if IsValid(v) then v:Remove() end end


end
