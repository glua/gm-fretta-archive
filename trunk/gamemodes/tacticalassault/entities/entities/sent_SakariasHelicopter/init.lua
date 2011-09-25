
resource.AddFile( "materials/VGUI/entities/sent_SakariasHelicopter.vmt" )
resource.AddFile( "materials/VGUI/entities/sent_SakariasHelicopter.vtf" )

resource.AddFile( "materials/models/military2/air/air_frontglass.vmt" )
resource.AddFile( "materials/models/military2/air/air_frontglass.vtf" )
resource.AddFile( "materials/models/military2/air/air_glass.vmt" )
resource.AddFile( "materials/models/military2/air/air_glass.vtf" )
resource.AddFile( "materials/models/military2/air/air_h500ext7.vmt" )
resource.AddFile( "materials/models/military2/air/air_h500ext7.vtf" )
resource.AddFile( "materials/models/military2/air/air_h500ext7_nomal.vtf" )
resource.AddFile( "materials/models/military2/air/air_h500int3a.vmt" )
resource.AddFile( "materials/models/military2/air/air_h500int3a.vtf" )
resource.AddFile( "materials/models/military2/air/air_h500int3a_nomal.vtf" )
resource.AddFile( "materials/models/military2/air/air_h500int6.vmt" )
resource.AddFile( "materials/models/military2/air/air_h500int6.vtf" )
resource.AddFile( "materials/models/military2/air/air_h500int6_nomal.vtf" )

resource.AddFile( "models/nova/Airboat_seat.dx80.vtx" )
resource.AddFile( "models/nova/Airboat_seat.dx90.vtx" )
resource.AddFile( "models/nova/airboat_seat.mdl" )
resource.AddFile( "models/nova/Airboat_seat.phy" )
resource.AddFile( "models/nova/Airboat_seat.sw.vtx" )
resource.AddFile( "models/nova/airboat_seat.vvd" )
resource.AddFile( "models/nova/Airboat_seat.xbox.vtx" )
resource.AddFile( "models/military2/air/air_h500.dx80.vtx" )
resource.AddFile( "models/military2/air/air_h500.dx90.vtx" )
resource.AddFile( "models/military2/air/air_h500.mdl" )
resource.AddFile( "models/military2/air/air_h500.phy" )
resource.AddFile( "models/military2/air/air_h500.sw.vtx" )
resource.AddFile( "models/military2/air/air_h500.vvd" )
resource.AddFile( "models/military2/air/air_h500.xbox.vtx" )
resource.AddFile( "models/military2/air/air_h500_r.dx80.vtx" )
resource.AddFile( "models/military2/air/air_h500_r.dx90.vtx" )
resource.AddFile( "models/military2/air/air_h500_r.mdl" )
resource.AddFile( "models/military2/air/air_h500_r.phy" )
resource.AddFile( "models/military2/air/air_h500_r.sw.vtx" )
resource.AddFile( "models/military2/air/air_h500_r.vvd" )
resource.AddFile( "models/military2/air/air_h500_r.xbox.vtx" )
resource.AddFile( "models/military2/air/air_h500_sr.dx80.vtx" )
resource.AddFile( "models/military2/air/air_h500_sr.dx90.vtx" )
resource.AddFile( "models/military2/air/air_h500_sr.mdl" )
resource.AddFile( "models/military2/air/air_h500_sr.phy" )
resource.AddFile( "models/military2/air/air_h500_sr.sw.vtx" )
resource.AddFile( "models/military2/air/air_h500_sr.vvd" )
resource.AddFile( "models/military2/air/air_h500_sr.xbox.vtx" )


resource.AddFile( "scripts/vehicles/HeliSeat.txt" )

resource.AddFile( "sound/HelicopterVehicle/bladehit.mp3" )
resource.AddFile( "sound/HelicopterVehicle/CrashAlarm.mp3" )
resource.AddFile( "sound/HelicopterVehicle/HeliLoopExt.mp3" )
resource.AddFile( "sound/HelicopterVehicle/HeliLoopInt.mp3" )
resource.AddFile( "sound/HelicopterVehicle/HeliStart.mp3" )
resource.AddFile( "sound/HelicopterVehicle/HeliStop.mp3" )
resource.AddFile( "sound/HelicopterVehicle/LowHealth.mp3" )
resource.AddFile( "sound/HelicopterVehicle/MinorAlarm.mp3" )
resource.AddFile( "sound/HelicopterVehicle/MissileNearby.mp3" )
resource.AddFile( "sound/HelicopterVehicle/MissileShoot.mp3" )
resource.AddFile( "sound/HelicopterVehicle/Shooting.mp3" )
resource.AddFile( "sound/HelicopterVehicle/StopShooting.mp3" )

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.SmokeTimer = CurTime()

ENT.TopProp = NULL
ENT.BackProp = NULL
ENT.Unbalance = NULL
ENT.PlyUser = NULL
ENT.Gunner = 1
ENT.PlyUsers = {}
ENT.Seats = {}
ENT.OccupiedSeats = {}


ENT.CanFly = 0
ENT.PropellerForceDel = CurTime()
ENT.TakeForceDelOnce = 0
ENT.RotorDustEffectOnce = 0
ENT.RotorDustEffect = NULL

ENT.SoundLoopDelay = CurTime()
ENT.StopSoundOnce = 0
ENT.HeliStart = NULL
ENT.HeliStop = NULL
ENT.HeliExt = NULL
ENT.HeliInt = NULL
ENT.MissileAlert = NULL
ENT.MissileAlertDel = CurTime()
ENT.MissileShootDel = CurTime()
ENT.CrashAlarmDel = CurTime()
ENT.BladesAlarmDel = CurTime()
ENT.LowHealthDel = CurTime()
ENT.HeliCreakDel = CurTime()
ENT.CrashAlarm = NULL
ENT.LowHealth = NULL
ENT.MinorAlarm = NULL
ENT.MissileShoot = NULL
ENT.MissileShootTimer = CurTime()
ENT.SpawnMissiles = 0
ENT.SpawnLaserMissileDel = CurTime()
ENT.SpawnLaserMissileRelSound = 1
ENT.UpdateLaserPosDel = CurTime()
ENT.SpawnMissileRelSound = 1

ENT.ShootBulletSoundDel = CurTime()
ENT.ShootSound = NULL
ENT.StopShootSound = NULL
ENT.ShootStopSoundOnce = 1
ENT.BulletDel = CurTime()
ENT.WeaponType = 1


ENT.Seat = NULL
ENT.SeatTwo = NULL
ENT.SeatThree = NULL
ENT.SeatFour = NULL

ENT.TopPropellerHealth = 100
ENT.ChopperHealth = 300

ENT.PropSpeedDel = 0

ENT.FireEffectOnce = 0
ENT.SmokeEffectOnce = 0
ENT.RedDotLaser = 1

ENT.SpawnTargetsOnce = 0
ENT.target1 = NULL
ENT.target2 = NULL
ENT.target3 = NULL
ENT.target4 = NULL
ENT.target5 = NULL

--Damage
ENT.RemoveTopPropOnce = 0
ENT.MediumDamageEffect = 0
ENT.TakeHealth = CurTime()
ENT.DieOnce = 0
ENT.CrashOnce = 0
ENT.CrashVector = NULL
ENT.OldSpeed = 0

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
--------Spawning the entity and getting some sounds i use.   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,200)
 	 
 	local ent = ents.Create( "sent_SakariasHelicopter" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
 	ent.Owner = ply
	self.PlyUsers[1] = ply	
	ent.UserOne = NULL
	return ent 
	
end

function ENT:Initialize()

	self.Entity:SetModel("models/military2/air/air_h500.mdl")
	--self.Entity:SetMaterial("Glad/BlueEye.vtf")
	self.Entity:SetOwner(self.Owner)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	self.Entity:SetSolid(SOLID_VPHYSICS)	
    local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	
				self.TopProp = ents.Create( "prop_physics" )
				self.TopProp:SetModel("models/military2/air/air_h500_r.mdl")		
				--self.TopProp:SetAngles(self.Entity:GetAngles())
				self.TopProp:SetPos(self.Entity:GetPos() + (self.Entity:GetUp() * 50))
				self.TopProp:SetOwner(self.Owner)		
				self.TopProp:Spawn()
				self.TopProp.IsHeliPart = 1
				--self.TopProp:GetPhysicsObject():SetMass(200)	

				self.BackProp = ents.Create( "prop_physics" )
				self.BackProp:SetModel("models/military2/air/air_h500_sr.mdl")		
				--self.BackProp:SetAngles(self.Entity:GetAngles())
				self.BackProp:SetPos(self.Entity:GetPos() + (self.Entity:GetForward() * -185) + (self.Entity:GetUp() * 13) + (self.Entity:GetRight() * -3) )
				self.BackProp:SetOwner(self.Owner)		
				self.BackProp:Spawn()					
				self.BackProp.IsHeliPart = 2
	
	--Spawning a new seat
	self.Seats[1] = ents.Create("prop_vehicle_prisoner_pod")  
    self.Seats[1]:SetKeyValue("vehiclescript","scripts/vehicles/HeliSeat.txt")  
    self.Seats[1]:SetModel( "models/nova/airboat_seat.mdl" ) 
    self.Seats[1]:SetPos( self.Entity:GetPos() + ( self.Entity:GetForward() * 28 ) + ( self.Entity:GetRight() * -14.5 ) + ( self.Entity:GetUp() * -14 ) )  
	self.Seats[1]:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
	self.Seats[1]:SetKeyValue("limitview", "0")  
	self.Seats[1]:SetColor(255,255,255,0)
	self.Seats[1]:Spawn()  
	self.Seats[1]:GetPhysicsObject():EnableGravity(true);
	self.Seats[1]:GetPhysicsObject():SetMass(1)	
	self.Entity.SeatOne = self.Seats[1]
	self.Seats[1].EntOwner = self.Entity
	self.Seats[1].SeatNum = 1
	self.Entity.UseSeatOne = 0
	--
	--Spawning a new seatTwo
	self.Seats[2] = ents.Create("prop_vehicle_prisoner_pod")  
    self.Seats[2]:SetKeyValue("vehiclescript","scripts/vehicles/HeliSeat.txt")  
    self.Seats[2]:SetModel( "models/nova/airboat_seat.mdl" ) 
    self.Seats[2]:SetPos( self.Entity:GetPos() + ( self.Entity:GetForward() * 28 ) + ( self.Entity:GetRight() * 14.5 ) + ( self.Entity:GetUp() * -14 ) )  
	self.Seats[2]:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
	self.Seats[2]:SetKeyValue("limitview", "0")  
	self.Seats[2]:SetColor(255,255,255,0)
	self.Seats[2]:Spawn()  
	self.Seats[2]:GetPhysicsObject():EnableGravity(true);
	self.Seats[2]:GetPhysicsObject():SetMass(1)		
	self.Entity.SeatTwo = self.Seats[2]
	self.Seats[2].EntOwner = self.Entity
	self.Seats[2].SeatNum = 2	
	self.Entity.UseSeatTwo = 0	
	--	
	
	--Spawning a new seatThree
	self.Seats[3] = ents.Create("prop_vehicle_prisoner_pod")  
    self.Seats[3]:SetKeyValue("vehiclescript","scripts/vehicles/HeliSeat.txt")  
    self.Seats[3]:SetModel( "models/nova/airboat_seat.mdl" ) 
    self.Seats[3]:SetPos( self.Entity:GetPos() + ( self.Entity:GetForward() * -10 ) + ( self.Entity:GetRight() * 10 ) + ( self.Entity:GetUp() * -14 ) )  
	self.Seats[3]:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
	self.Seats[3]:SetKeyValue("limitview", "0")  
	self.Seats[3]:SetColor(255,255,255,0)
	self.Seats[3]:Spawn()  
	self.Seats[3]:GetPhysicsObject():EnableGravity(true);
	self.Seats[3]:GetPhysicsObject():SetMass(1)	
	self.Entity.SeatThree = self.Seats[3]	
	self.Seats[3].EntOwner = self.Entity
	self.Seats[3].SeatNum = 3	
	self.Entity.UseSeatThree = 0	
	--	
	
	--Spawning a new seatFour
	self.Seats[4] = ents.Create("prop_vehicle_prisoner_pod")  
    self.Seats[4]:SetKeyValue("vehiclescript","scripts/vehicles/HeliSeat.txt")  
    self.Seats[4]:SetModel( "models/nova/airboat_seat.mdl" ) 
    self.Seats[4]:SetPos( self.Entity:GetPos() + ( self.Entity:GetForward() * -10 ) + ( self.Entity:GetRight() * -10 ) + ( self.Entity:GetUp() * -14 ) )  
	self.Seats[4]:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
	self.Seats[4]:SetKeyValue("limitview", "0")  
	self.Seats[4]:SetColor(255,255,255,0)
	self.Seats[4]:Spawn()  
	self.Seats[4]:GetPhysicsObject():EnableGravity(true);
	self.Seats[4]:GetPhysicsObject():SetMass(1)
	self.Entity.SeatFour = self.Seats[4]	
	self.Seats[4].EntOwner = self.Entity
	self.Seats[4].SeatNum = 4	
	self.Entity.UseSeatFour = 0	
	
	--	
				
				
				local Lpos1 = self.Entity:GetLocalPos()
				local Wpos1 = self.Entity:GetPos()
				
				local Lpos2 = self.BackProp:GetLocalPos()
				local Wpos2 = self.BackProp:GetPos()
				
			  constraint.Weld( self.Entity, self.Seats[1], 0, 0, 0, 1 )	
			  constraint.Weld( self.Entity, self.Seats[2], 0, 0, 0, 1 )	
			  constraint.Weld( self.Entity, self.Seats[3], 0, 0, 0, 1 )	
			  constraint.Weld( self.Entity, self.Seats[4], 0, 0, 0, 1 )				  
			  --constraint.Weld( self.Entity, self.BackProp, 0, 0, 0, 1 )	
			  constraint.Axis( self.Entity, self.TopProp, 0, 0, (Vector(0,0,0)), Vector(0,0,0) , 0, 0, 0, 1 )	
			  constraint.Axis( self.Entity, self.BackProp, 0, 0, Vector(-185,-3,13) , Vector(0,0,0), 0, 0, 1, 1 ) --Vector(-185,13,-3)	
			constraint.Keepupright( self.TopProp, Angle(0,0,0), 0, 15 )				
			--constraint.Axis( Entity Ent1, Entity Ent2, number Bone1, number Bone2, Vector LPos1, Vector LPos2, number forcelimit, number torquelimit, number friction, number nocollide )			
			
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
self.Entity.CanFly = 0
self.Entity.LaserPos = self.Entity:GetPos()
	self.UserOne = NULL
			
end

function ENT:MakeMissile()

				self.MissileShoot:Stop()
				self.MissileShoot:Play()

				local Missile = ents.Create( "sent_NoTargetMissile" )
				Missile:SetPos( self.Entity:GetPos() + (self.Entity:GetUp() * -20) + (self.Entity:GetForward() * 35)) 
				local NewAng = self.Entity:GetAngles()
				
				--Missile:SetAngles( Angle(NewAng.r,(NewAng.y+90),NewAng.p) )
				Missile:SetAngles( NewAng )				
				Missile:Spawn()
				Missile:Activate() 
				Missile:GetPhysicsObject():SetVelocity( (self.Entity:GetVelocity():Length() * self.Entity:GetForward()) )
				Missile:GetPhysicsObject():Wake()
				constraint.NoCollide( self.Entity, Missile, 0, 0 )
				constraint.NoCollide( self.Entity, self.Entity.SeatOne, 0, 0 )
				constraint.NoCollide( self.Entity, self.Entity.SeatTwo, 0, 0 )
				constraint.NoCollide( self.Entity, self.Entity.SeatThree, 0, 0 )
				constraint.NoCollide( self.Entity, self.Entity.SeatFour, 0, 0 )				
				constraint.NoCollide( self.Entity, self.TopProp, 0, 0 )
				constraint.NoCollide( self.Entity, self.BackProp , 0, 0 )	
end
-------------------------------------------USE
function ENT:Use( activator, caller )


	if ( activator:IsPlayer() and activator:Alive()) and self.RemoveTopPropOnce == 0 and self.ChopperHealth > 0 then	

	self.Entity.UseSeatOne = 0
	self.Entity.UseSeatTwo = 0
	self.Entity.UseSeatThree = 0
	self.Entity.UseSeatFour = 0
	
				for k,v in pairs(player.GetAll()) do
					if v:InVehicle( ) then
						local PlyUsedVeh = v:GetVehicle()					
							for i = 1, 4 do		
							
								if PlyUsedVeh == self.Entity.SeatOne then
									self.Entity.UseSeatOne = 1
								end
								if PlyUsedVeh == self.Entity.SeatTwo then
									self.Entity.UseSeatTwo = 1
								end
								if PlyUsedVeh == self.Entity.SeatThree then
									self.Entity.UseSeatThree = 1
								end
								if PlyUsedVeh == self.Entity.SeatFour then
									self.Entity.UseSeatFour = 1
								end
							end
					end
				end

		local dont = 0		

			
				if self.Entity.UseSeatOne == 0 and dont == 0 then
					activator:EnterVehicle( self.Entity.SeatOne )
					self.Entity.UserOne = activator
					dont = 1	
				end
			
				if self.Entity.UseSeatTwo == 0 and dont == 0 then
					activator:EnterVehicle( self.Entity.SeatTwo )
					self.Entity.UserTwo = activator					
					dont = 1	
				end

				if self.Entity.UseSeatThree == 0 and dont == 0 then
					activator:EnterVehicle( self.Entity.SeatThree )
					self.Entity.UserThree = activator				
					dont = 1	
				end

				if self.Entity.UseSeatFour == 0 and dont == 0 then
					activator:EnterVehicle( self.Entity.SeatFour )
					self.Entity.UserFour = activator					
					dont = 1	
				end				
		
	end	
end

-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity


end
-------------------------------------------PHYSICS =D
function ENT:PhysicsUpdate( physics )


		//Weapons
			local GunUser = NULL
			local ValidGunner = 0
			
			if self.Gunner == 1 then
				GunUser =  self.Entity.UserOne
				ValidGunner = self.Entity.UseSeatOne
			else
				GunUser =  self.Entity.UserTwo
				ValidGunner = self.Entity.UseSeatTwo
			end
		
		
		
		--Calculating and limiting the direction the turret can be aimed in.
	if ValidGunner == 1 then
		local Dir = GunUser:GetAimVector()
		local entDir = self.Entity:GetForward()
		
		//Limiting the angles when using the turret
		if self.WeaponType == 1 then
			if Dir.z > entDir.z then
			Dir.z = entDir.z
			end
			
			if Dir.y > (entDir.y + 0.6) then
			Dir.y = (entDir.y + 0.6)
			end
			
			if Dir.y < (entDir.y - 0.6) then
			Dir.y = (entDir.y - 0.6)
			end

			if Dir.x > (entDir.x + 0.6) then
			Dir.x = (entDir.x + 0.6)
			end
			
			if Dir.x < (entDir.x - 0.6) then
			Dir.x = (entDir.x - 0.6)
			end
		end

		
		if 	GunUser:KeyDown( IN_ATTACK ) and self.RemoveTopPropOnce == 0 and self.DieOnce == 0 then
			
		//If the weapon type is 1 we will use the turret
			if self.WeaponType == 1 and self.BulletDel < CurTime() then
				local BulletNum = 1
				self.BulletDel = CurTime() + 0.06
				local Origin =  self.Entity:GetPos() + ( self.Entity:GetForward() * 60 ) + ( self.Entity:GetUp() * -30 ) 	
				
				local Spread = Vector(0.03,0.03,0)
				self.ShootStopSoundOnce = 0
				self:Shoot(BulletNum,Origin,Dir,Spread,GunUser)
					if self.ShootBulletSoundDel < CurTime() then
					self.ShootBulletSoundDel = CurTime() + 0.9
					self.ShootSound:Stop()
					self.ShootSound:Play()
					end
			end
		
		//If the weapon type is 2 we will missiles
			if self.WeaponType == 2 and self.MissileShootDel < CurTime() then
				self.ShootSound:Stop()
				self.SpawnMissileRelSound = 0		
				self.MissileShootDel = CurTime() + 3
				self:MakeMissile()
				self.MissileShootTimer = CurTime()
				self.SpawnMissiles = 1
			end
		
						
		//If the weapon type is 3
			if self.WeaponType == 3 and self.SpawnLaserMissileDel < CurTime() then
				self.SpawnLaserMissileDel  = CurTime() + 5
				self.SpawnLaserMissileRelSound = 0

				self.MissileShoot:Stop()
				self.MissileShoot:Play()
				local Missile = ents.Create( "sent_LaserGuidedMissile" )
				Missile:SetPos( self.Entity:GetPos() + (self.Entity:GetUp() * -20) + (self.Entity:GetForward() * 35)) 				
				Missile:SetAngles( self.Entity:GetAngles() )
				Missile:Spawn()
				Missile:Activate() 
				Missile:GetPhysicsObject():SetVelocity( (self.Entity:GetVelocity():Length() * self.Entity:GetForward()) )
				Missile:GetPhysicsObject():Wake()
				Missile.EntityOwner = self.Entity
			end
		end

		
				if self.SpawnLaserMissileRelSound == 0 and ( self.SpawnLaserMissileDel - 0.5 ) < CurTime() then
					self.Entity:EmitSound("npc/dog/dog_servo10.wav")
					self.SpawnLaserMissileRelSound = 1
				end
				
				if self.SpawnMissileRelSound == 0 and (self.MissileShootDel - 0.5 ) < CurTime() then
					self.Entity:EmitSound("npc/dog/dog_servo10.wav")
					self.SpawnMissileRelSound = 1
				end				
		
			if self.WeaponType == 1 or self.WeaponType == 3 then	
				//Making a red dot laser
				Pos1 = self.Entity:GetPos() + ( self.Entity:GetForward() * 60 ) + ( self.Entity:GetUp() * -30 ) 
				local trace = {}
				trace.start = Pos1 
				trace.endpos = trace.start + (Dir * 50000)
				trace.filter = { self.Entity, self.TopProp }
				local tr = util.TraceLine( trace )
				local hitpos = tr.HitPos
				
				//We don't have to update the pos very often
				if self.WeaponType == 3 and self.UpdateLaserPosDel < CurTime() then
					self.UpdateLaserPosDel = CurTime() + 0.2
					self.Entity.LaserPos = hitpos
				end
				
				if self.RedDotLaser == 1 then
				
						self.RedDotLaser = ents.Create("env_sprite");
						self.RedDotLaser:SetPos( hitpos );
						self.RedDotLaser:SetKeyValue( "renderfx", "14" )
						self.RedDotLaser:SetKeyValue( "model", "sprites/glow1.vmt")
						self.RedDotLaser:SetKeyValue( "scale","0.5")
						self.RedDotLaser:SetKeyValue( "spawnflags","1")
						self.RedDotLaser:SetKeyValue( "angles","0 0 0")
						self.RedDotLaser:SetKeyValue( "rendermode","9")
						self.RedDotLaser:SetKeyValue( "renderamt","255")
						self.RedDotLaser:SetKeyValue( "rendercolor", "255 0 0" )				
						self.RedDotLaser:Spawn()
					
					elseif self.RedDotLaser ~= 1 and self.RedDotLaser:IsValid() then
					self.RedDotLaser:SetPos( hitpos );		
				end
			
				
				if not(GunUser:KeyDown( IN_ATTACK )) and self.ShootStopSoundOnce == 0 and self.WeaponType == 1 then
				self.ShootStopSoundOnce = 1
				self.ShootBulletSoundDel = CurTime()
				self.ShootSound:Stop()
				self.StopShootSound:Stop()
				self.StopShootSound:Play()	
				end
			end
		end
	

		if self.SpawnMissiles >= 1 then
		
			if (self.MissileShootTimer + 0.2) < CurTime() and self.SpawnMissiles == 1 then
				self:MakeMissile()
				self.SpawnMissiles = 2
			end

			if (self.MissileShootTimer + 0.4) < CurTime() and self.SpawnMissiles == 2 then
				self:MakeMissile()
				self.SpawnMissiles = 3
			end

			if (self.MissileShootTimer + 0.6) < CurTime() and self.SpawnMissiles == 3 then
				self:MakeMissile()
				self.SpawnMissiles = 0
			end			
		end	
	
//Heli controls	
		local BackPhys = NULL
		if  self.BackProp:IsValid() then
		BackPhys = self.BackProp:GetPhysicsObject()
		end
		local entphys = self.Entity:GetPhysicsObject()
		local TopPhys = NULL
		
		if self.RemoveTopPropOnce == 0 and self.TopProp:IsValid() then
			TopPhys = self.TopProp:GetPhysicsObject()		
		end
		
	--Apply some rotation force on the top prop
	
	
	if self.Entity.CanFly == 1 and self.Entity.UseSeatOne == 1 then
	
		Mul = self.PropellerForceDel - CurTime() 
		
		if Mul < 0 then Mul = 0 end
		
		Mul = (10 - Mul) / 10
			
		if self.RemoveTopPropOnce == 0 and TopPhys:IsValid() then
			TopPhys:AddAngleVelocity( Vector(0,0, (300 * Mul) ) )
		end
		
		if BackPhys ~= NULL and BackPhys:IsValid() then
		BackPhys:AddAngleVelocity( Vector(0,(50 * Mul),0 ) )
		end
		
		local PowForce = 0
		
		local UsedKey = 0
		
		if self.PropellerForceDel < CurTime() and self.RemoveTopPropOnce == 0 then		
		
		
		if 	self.Entity.UserOne:KeyDown( IN_FORWARD ) then
			entphys:AddAngleVelocity( Vector(0,10,0 ) )	
			entphys:ApplyForceCenter( self.Entity:GetForward() * 2000 )  --4.27
			UsedKey = 1
		end
	
		if 	self.Entity.UserOne:KeyDown( IN_BACK ) then
			entphys:AddAngleVelocity( Vector(0,-8,0 ) )
			UsedKey = 2			
		end
		
		
		if 	self.Entity.UserOne:KeyDown( IN_JUMP ) then	
			PowForce = PowForce + 1500	
		end
	
		if 	self.Entity.UserOne:KeyDown( IN_WALK  ) then
			PowForce = PowForce - 3000
		end
		
		
		if  UsedKey == 1 or UsedKey == 2 then
		PowForce = PowForce + 500
		end
		
		if 	self.Entity.UserOne:KeyDown( IN_MOVELEFT ) then
			entphys:AddAngleVelocity( Vector(-20,0,3 ) )	
		end
	
		if 	self.Entity.UserOne:KeyDown( IN_MOVERIGHT ) then
			entphys:AddAngleVelocity( Vector(20,0,-3 ) )			
		end		
		
		end
		
		if self.RemoveTopPropOnce == 0 and TopPhys:IsValid() then
			local MulForce = TopPhys:GetAngleVelocity():Length()
			entphys:ApplyForceCenter(self.Entity:GetUp() * ( (PowForce *Mul) + (MulForce * 4.20  ) ) )  --4.27
		end	
			--4700
			
			
			if self.CrashOnce == 0 and self.ChopperHealth < 50 then
				self.CrashOnce = 1 
				self.CrashVector = Vector(math.random(-40,40),math.random(-40,40),math.random(-40,40) )
				
				
			end
			
			if self.CrashOnce == 1 and self.ChopperHealth > 0 and self.Entity.CanFly == 1 and self.Entity.UseSeatOne == 1 then
			entphys:AddAngleVelocity( self.CrashVector )
			entphys:ApplyForceCenter(self.Entity:GetUp() * -4000 )
			end
	end

end
-------------------------------------------DAMAGE
function ENT:OnTakeDamage(dmg)

local Damage = 	0


if dmg:IsExplosionDamage() then
	Damage = dmg:GetDamage()
else
	Damage = (dmg:GetDamage()) / 4
end

self.ChopperHealth = self.ChopperHealth - Damage
self.TopPropellerHealth = self.TopPropellerHealth - (Damage / 4)

end
-------------------------------------------THINK
function ENT:Think()

// Getting Helicopter speed delta
--The delta will be used to define how much damage should be done to the player when crashing.

			local CurSpeed = self.Entity:GetPhysicsObject():GetVelocity():Length()
			local SpeedDelta = self.OldSpeed - CurSpeed
			
			self.OldSpeed = CurSpeed
			
			
		if  (self.CrashOnce == 1 or self.RemoveTopPropOnce == 1) and SpeedDelta > 100 then
		
		//Making it emit some sounds 
					local RanSound = math.random(1,4)
					if RanSound == 1 then
						self.Entity:EmitSound("vehicles/v8/vehicle_impact_heavy1.wav")
					end
					if RanSound == 2 then
						self.Entity:EmitSound("vehicles/v8/vehicle_impact_heavy2.wav")
					end
					if RanSound == 3 then
						self.Entity:EmitSound("vehicles/v8/vehicle_impact_heavy3.wav")
					end
					if RanSound == 4 then
						self.Entity:EmitSound("vehicles/v8/vehicle_impact_heavy4.wav")
					end	
		
		end
		
		if  (self.CrashOnce == 1 or self.RemoveTopPropOnce == 1) and SpeedDelta > 300 then				
		
		local dmg = SpeedDelta / 10
		self.ChopperHealth = self.ChopperHealth - (SpeedDelta / 20)
															
								if self.Entity.UseSeatOne == 1 then
									local health = self.Entity.UserOne:Health() 
									health = health - dmg
									self.Entity.UserOne:Fire("sethealth", ""..health.."", 0)
								end
								if self.Entity.UseSeatTwo == 1 then
									local health = self.Entity.UserTwo:Health() 
									health = health - dmg
									self.Entity.UserTwo:Fire("sethealth", ""..health.."", 0)
								end
								if self.Entity.UserThree == 1 then
									local health = self.Entity.UseSeatOne:Health() 
									health = health - dmg
									self.Entity.UserThree:Fire("sethealth", ""..health.."", 0)
								end
								if self.Entity.UserFour == 1 then
									local health = self.Entity.UseSeatOne:Health() 
									health = health - dmg
									self.Entity.UserFour:Fire("sethealth", ""..health.."", 0)
								end

		end
		
//Getting Top propeller rotate speed delta
//
	if self.Entity.CanFly == 1 and self.PropellerForceDel < CurTime() and self.RemoveTopPropOnce == 0 and self.TopProp:IsValid() then
		local TopPhys = self.TopProp:GetPhysicsObject()
		local CurSpeed = TopPhys:GetAngleVelocity():Length()
		local SpeedDelta = CurSpeed - self.PropSpeedDel
		self.PropSpeedDel = TopPhys:GetAngleVelocity():Length()
			if SpeedDelta > -1500 and SpeedDelta < -300 then 
					local RanSound = math.random(1,3)
					if RanSound == 1 then
						self.Entity:EmitSound("physics/metal/metal_box_impact_bullet1.wav")
					end
					if RanSound == 2 then
						self.Entity:EmitSound("physics/metal/metal_box_impact_bullet2.wav")
					end
					if RanSound == 3 then
						self.Entity:EmitSound("physics/metal/metal_box_impact_bullet3.wav")
					end
					self.TopPropellerHealth = self.TopPropellerHealth - 20
			end
	end


local entphys = self.Entity:GetPhysicsObject()
	entphys:Wake()

--Checking if there is players in the seats

	self.Entity.UseSeatOne = 0
	self.Entity.UseSeatTwo = 0
	self.Entity.UseSeatThree = 0
	self.Entity.UseSeatFour = 0
	
	local HaveUser = 0
	
				for k,v in pairs(player.GetAll()) do
					if v:InVehicle( ) then
						local PlyUsedVeh = v:GetVehicle()					
							for i = 1, 4 do		
								
								if PlyUsedVeh == self.Entity.SeatOne then
									self.Entity.UseSeatOne = 1
									HaveUser = 1
								end
								if PlyUsedVeh == self.Entity.SeatTwo then
									self.Entity.UseSeatTwo = 1
									HaveUser = 1									
								end
								if PlyUsedVeh == self.Entity.SeatThree then
									self.Entity.UseSeatThree = 1
									HaveUser = 1										
								end
								if PlyUsedVeh == self.Entity.SeatFour then
									self.Entity.UseSeatFour = 1
									HaveUser = 1										
								end
							end
					end
				end
	
--	
//Checking if a player wants to change seat
					local Ignore = {0,0,0,0}
					for i = 1, 4 do	
						local Ply = NULL
						local PlyPrevSeat = i
						if i == 1 then Ply = self.Entity.UserOne end
						if i == 2 then Ply = self.Entity.UserTwo end	
						if i == 3 then Ply = self.Entity.UserThree end
						if i == 4 then Ply = self.Entity.UserFour end
							if Ply ~= nil and Ply ~= NULL and HaveUser == 1 and Ignore[i] == 0 then
								if Ply:IsValid() then
									if 	Ply:KeyDown( IN_ZOOM ) then

										local SeatCheck = 0
										local UseThaSeat = i
										local dont = 0
										while SeatCheck < 4 do
											SeatCheck = SeatCheck + 1
											UseThaSeat = UseThaSeat + 1
											if UseThaSeat > 4 then UseThaSeat = 1 end
										
										
											if UseThaSeat == 1 and self.Entity.UseSeatOne == 0 and dont == 0 then
												Ply:ExitVehicle()
												Ply:EnterVehicle(self.Entity.SeatOne)
												Ignore[1] = 1
												self.Entity.UserOne = Ply												
												dont = 1
											end
										
											if UseThaSeat == 2 and self.Entity.UseSeatTwo == 0 and dont == 0 then
												Ply:ExitVehicle()
												Ply:EnterVehicle(self.Entity.SeatTwo)											
												Ignore[2] = 1												
												self.Entity.UserTwo = Ply												
												dont = 1
											end
										
											if UseThaSeat == 3 and self.Entity.UseSeatThree == 0 and dont == 0 then
												Ply:ExitVehicle()
												Ply:EnterVehicle(self.Entity.SeatThree)												
												Ignore[3] = 1												
												self.Entity.UserThree = Ply													
												dont = 1
											end									
										
											if UseThaSeat == 4 and self.Entity.UseSeatFour == 0 and dont == 0 then
												Ply:ExitVehicle()
												Ply:EnterVehicle(self.Entity.SeatFour)												
												Ignore[4] = 1												
												self.Entity.UserFour = Ply													
												dont = 1
											end									
										
										
											if dont == 1 then
												if PlyPrevSeat == 1 then
													self.Entity.UseSeatOne = 0
													self.Entity.UserOne = NULL
												end
												if PlyPrevSeat == 2 then
													self.Entity.UseSeatTwo = 0
													self.Entity.UserTwo = NULL													
												end
												if PlyPrevSeat == 3 then
													self.Entity.UseSeatThree = 0
													self.Entity.UserThree = NULL													
												end
												if PlyPrevSeat == 4 then
													self.Entity.UseSeatFour = 0
													self.Entity.UserFour = NULL													
												end
											end
											
											
										end
								
									end
								end
							end
					end
--

//Checking if there is a pilot															
self.Entity.CanFly = 0
	if	self.Entity.UserOne ~= NULL and self.Entity.UserOne:IsValid() and self.Entity.UseSeatOne == 1 and self.Entity:WaterLevel() <= 0 then
		if 	self.Entity.UserOne:InVehicle( ) then
			local PlyUsedVeh =	self.Entity.UserOne:GetVehicle()	
		
			if PlyUsedVeh == self.Entity.SeatOne then		
				self.Entity.CanFly = 1
				
				if self.TakeForceDelOnce == 0 then
					self.PropellerForceDel = CurTime() + 10
					self.TakeForceDelOnce = 1
					self.SoundLoopDelay = CurTime() + 9
					self.StopSoundOnce = 1					
					self.HeliStart:Play()
					self.HeliStop:Stop()					
				end
				
			end
			
		end		
	end 

		
	
	

//Changing gunner
	
	if self.Entity.CanFly == 1 and self.Entity.UseSeatOne == 1 then
	
		if self.Entity.UserOne:KeyDown( IN_SPEED ) then
			self.Gunner = self.Gunner + 1
			if self.Gunner > 2 then self.Gunner = 1 end
			
			if self.Gunner == 1 then
				local message = "You are the gunner!"
				self.Entity.UserOne:PrintMessage( HUD_PRINTTALK, message)
					if self.Entity.UseSeatTwo == 1 then
					message = "You not the gunner anymore."				
					self.Entity.UserTwo:PrintMessage( HUD_PRINTTALK, message)
					end
			else
				local message = "You not the gunner anymore."	
				self.Entity.UserOne:PrintMessage( HUD_PRINTTALK, message)
					if self.Entity.UseSeatTwo == 1 then
					message = "You are the gunner!"			
					self.Entity.UserTwo:PrintMessage( HUD_PRINTTALK, message)
					end
			end
			
		end
	
	end
	
	
//Does the gunner/John Freeman want to change wepon?	

			local GunUser = NULL
			local ValidGunner = 0
			
			if self.Gunner == 1 then
				GunUser =  self.Entity.UserOne
				ValidGunner = self.Entity.UseSeatOne
			else
				GunUser =  self.Entity.UserTwo
				ValidGunner = self.Entity.UseSeatTwo
			end


	if ValidGunner == 1 then
		if GunUser:KeyDown( IN_ATTACK2 ) then
			self.WeaponType = self.WeaponType + 1
			if self.WeaponType > 3 then self.WeaponType = 1 end
			
				if self.WeaponType == 1 then
					message = "Weapon: Turret"			
					GunUser:PrintMessage( HUD_PRINTTALK, message)
				end

				if self.WeaponType == 2 then
					message = "Weapon: Missiles"			
					GunUser:PrintMessage( HUD_PRINTTALK, message)
				end

				if self.WeaponType == 3 then
					message = "Weapon: Laser Guided Missiles"			
					GunUser:PrintMessage( HUD_PRINTTALK, message)
				end
				
		end
	end
	
//Helicopters can't go in the water	
if self.Entity:WaterLevel() > 0 then
	self.Entity.CanFly = 0
end
	
	
	if 	self.Entity.CanFly == 1 and	self.PropellerForceDel < CurTime() and self.RemoveTopPropOnce == 0 then
	
	//Adding rotor dust effect here 
			if self.RotorDustEffectOnce == 0 then
				self.RotorDustEffect = ents.Create("env_rotorwash_emitter")
				self.RotorDustEffect:SetPos(self.Entity:GetPos())
				self.RotorDustEffect:SetParent(self.Entity)
				self.RotorDustEffect:Activate()
				self.RotorDustEffectOnce = 1
			end
	end		
	
	if self.Gunner == 2 and self.Entity.UseSeatTwo == 0 and self.RedDotLaser ~= 1 then
		self.RedDotLaser:Remove()
		self.RedDotLaser = 1
	end
	
	if self.WeaponType == 2 and self.RedDotLaser ~= 1 then
		self.RedDotLaser:Remove()
		self.RedDotLaser = 1	
	end
	
	if 	self.Entity.CanFly == 0 then
	    --self.SpawnMissiles = 0
		if self.RedDotLaser ~= 1 and self.Gunner ~= 2 then
		self.RedDotLaser:Remove()
		self.RedDotLaser = 1
		end
		
		if self.RotorDustEffectOnce == 1 then
			self.RotorDustEffect:Remove()
			self.RotorDustEffectOnce = 0
		end
		
		self.TakeForceDelOnce = 0
		
		if self.StopSoundOnce == 1 and self.RemoveTopPropOnce == 0 then
			self.StopSoundOnce = 0
			self.HeliStop:Play()
			self.HeliStart:Stop()
			self.HeliExt:Stop()
			self.HeliInt:Stop()
			self.CrashAlarm:Stop()
			self.LowHealth:Stop()		
			self.MinorAlarm:Stop()	
		end
		
	end
	
	
	//Sounds
	if self.Entity.CanFly == 1 and self.SoundLoopDelay < CurTime() and self.RemoveTopPropOnce == 0 then
	self.HeliExt:Stop()
	self.HeliInt:Stop()	
	self.HeliExt:Play()
	self.HeliInt:Play()
	self.SoundLoopDelay = CurTime() + 9
	end
	
	//Missile alert sound
	if self.Entity.CanFly == 1 then
	
		for k, v in pairs( ents.FindInSphere( self.Entity:GetPos(), 4000 ) ) do	
			if string.find(v:GetClass(), "rpg_missile") then
				if self.MissileAlertDel < CurTime() then
					self.MissileAlertDel = CurTime() + 3
					self.MissileAlert:Stop()
					self.MissileAlert:Play()	
				end
			end
		end
	end
	
	
	--Checking the damage and fixing some sounds
	
	if self.ChopperHealth <= 0 and self.DieOnce == 0 then
	self.DieOnce = 1
	
		//Many explosions D:
		local expl = ents.Create("env_explosion")
		expl:SetKeyValue("spawnflags",128)
		expl:SetPos(self.Entity:GetPos())
		expl:Spawn()
		expl:Fire("explode","",0)
	
			local FireExp = ents.Create("env_physexplosion")
			FireExp:SetPos(self.Entity:GetPos())
			FireExp:SetParent(self.Entity)
			FireExp:SetKeyValue("magnitude", 500)
			FireExp:SetKeyValue("radius", 500)
			FireExp:SetKeyValue("spawnflags", "1")
			FireExp:Spawn()
			FireExp:Fire("Explode", "", 0)
			FireExp:Fire("kill", "", 5)
			util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 500, 500)
	
	local effectdata = EffectData()
	effectdata:SetStart( self.Entity:GetPos() )
	effectdata:SetOrigin( self.Entity:GetPos() )
	effectdata:SetScale( 1 )
	util.Effect( "Explosion", effectdata )	
	util.Effect( "HelicopterMegaBomb", effectdata )	
	util.Effect( "cball_explode", effectdata )	
	
	self.Entity:SetColor(0,0,0,255)
	self.TopProp:SetColor(0,0,0,255)
	self.BackProp:SetColor(0,0,0,255)
	
	self.Entity.UseSeatOne = 0
	self.Entity.UseSeatTwo = 0
	self.Entity.UseSeatThree = 0
	self.Entity.UseSeatFour = 0
	
				for k,v in pairs(player.GetAll()) do
					if v:InVehicle( ) then
						local PlyUsedVeh = v:GetVehicle()					
							for i = 1, 4 do		
							
								if PlyUsedVeh == self.Entity.SeatOne then
									self.Entity.UseSeatOne = 1
								end
								if PlyUsedVeh == self.Entity.SeatTwo then
									self.Entity.UseSeatTwo = 1
								end
								if PlyUsedVeh == self.Entity.SeatThree then
									self.Entity.UseSeatThree = 1
								end
								if PlyUsedVeh == self.Entity.SeatFour then
									self.Entity.UseSeatFour = 1
								end
							end
					end
				end

								local health = 0							
								if self.Entity.UseSeatOne == 1 then
									
									self.Entity.UserOne:Fire("sethealth", ""..health.."", 0)
								end
								if self.Entity.UseSeatTwo == 1 then

									self.Entity.UserTwo:Fire("sethealth", ""..health.."", 0)
								end
								if self.Entity.UseSeatThree == 1 then

									self.Entity.UserThree:Fire("sethealth", ""..health.."", 0)
								end
								if self.Entity.UseSeatFour == 1 then

									self.Entity.UserFour:Fire("sethealth", ""..health.."", 0)
								end

	
			self.CrashAlarm:Stop()
			self.LowHealth:Stop()		
			self.MinorAlarm:Stop()	

		if self.target1 != NULL then
			self.target1:Remove()
		end	
		
		if self.target2 != NULL then
			self.target2:Remove()
		end	

		if self.target3 != NULL then
			self.target3:Remove()
		end	

		if self.target4 != NULL then
			self.target4:Remove()
		end	

		if self.target5 != NULL then
			self.target5:Remove()
		end			
			
	end
	
	
	if self.ChopperHealth < 50 then

		if self.TakeHealth < CurTime() then
			self.TakeHealth = CurTime() + 1
			self.ChopperHealth = self.ChopperHealth - 2
		end
	
		if self.FireEffectOnce == 0 then
			local fire = ents.Create( "env_fire_trail" )
			fire:SetPos( self.Entity:GetPos() + (self.Entity:GetUp() * 30) + (self.Entity:GetForward() * -60))
			fire:Spawn()
			fire:SetParent(self.Entity)
			self.FireEffectOnce = 1
		end
		
		if self.CrashAlarmDel < CurTime() and self.ChopperHealth > 0 then
		self.CrashAlarmDel = CurTime() + 14
		self.CrashAlarm:Stop()
		self.CrashAlarm:Play()
		end
	end
	
	if self.ChopperHealth <= 150 and self.Entity.CanFly == 1 and self.ChopperHealth > 0 then
		if self.LowHealthDel < CurTime() and self.ChopperHealth > 0 then
			self.LowHealthDel = CurTime() + 10
			self.LowHealth:Stop()
			self.LowHealth:Play()
		end
		
		if self.HeliCreakDel < CurTime() and self.Entity.UseSeatOne == 1 then
		local RanSound = math.random(1,5)
		self.HeliCreakDel = CurTime() + math.random(3,15)
		
		
		
			if RanSound == 1 then
			self.Entity:EmitSound("physics/metal/metal_solid_strain1.wav")
			end

			if RanSound == 2 then
			self.Entity:EmitSound("physics/metal/metal_solid_strain2.wav")
			end	

			if RanSound == 3 then
			self.Entity:EmitSound("physics/metal/metal_solid_strain3.wav")
			end			
			
			if RanSound == 4 then
			self.Entity:EmitSound("physics/metal/metal_solid_strain4.wav")
			end			
			
			if RanSound == 5 then
			self.Entity:EmitSound("physics/metal/metal_solid_strain5.wav")
			end			

			
			local Mul =( (1 - (self.ChopperHealth / 150 )) )
			self.Entity:GetPhysicsObject():AddAngleVelocity( Vector( (((math.random(-500,500)) * Mul)), (((math.random(-500,500)) * Mul)), (((math.random(-500,500)) * Mul))  ))	
	
		end

		
		if self.MediumDamageEffect == 0 then
			self.MediumDamageEffect = 1
			local smoke = ents.Create("env_smokestack")
			smoke:SetPos(self.Entity:GetPos() + (self.Entity:GetUp() * 30) + (self.Entity:GetForward() * -60))
			smoke:SetKeyValue("InitialState", "1")
			smoke:SetKeyValue("WindAngle", "0 10 0")
			smoke:SetKeyValue("WindSpeed", "0")
			smoke:SetKeyValue("rendercolor", "" .. tostring(10) .. " " .. tostring(10) .. " " .. tostring(10) .. "")
			smoke:SetKeyValue("renderamt", "" .. tostring(170) .. "")
			smoke:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
			smoke:SetKeyValue("BaseSpread", tostring(10))
			smoke:SetKeyValue("SpreadSpeed", tostring(5))
			smoke:SetKeyValue("Speed", tostring(100))
			smoke:SetKeyValue("StartSize", tostring(10))
			smoke:SetKeyValue("EndSize", tostring(100))
			smoke:SetKeyValue("roll", tostring(10))
			smoke:SetKeyValue("Rate", tostring(100))
			smoke:SetKeyValue("JetLength", tostring(50))
			smoke:SetKeyValue("twist", tostring(5))

			//Spawn smoke
			smoke:Spawn()
			smoke:SetParent(self.Entity)
			smoke:Activate()
		end
	end
	
	
	if self.TopPropellerHealth <= 40 then

		if self.SmokeEffectOnce == 0 then
		self.SmokeEffectOnce = 1
			local smoke = ents.Create("env_smokestack")
			smoke:SetPos(self.Entity:GetPos() + (self.Entity:GetUp() * 50))
			smoke:SetKeyValue("InitialState", "1")
			smoke:SetKeyValue("WindAngle", "0 0 0")
			smoke:SetKeyValue("WindSpeed", "0")
			smoke:SetKeyValue("rendercolor", "" .. tostring(170) .. " " .. tostring(170) .. " " .. tostring(170) .. "")
			smoke:SetKeyValue("renderamt", "" .. tostring(170) .. "")
			smoke:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
			smoke:SetKeyValue("BaseSpread", tostring(10))
			smoke:SetKeyValue("SpreadSpeed", tostring(5))
			smoke:SetKeyValue("Speed", tostring(100))
			smoke:SetKeyValue("StartSize", tostring(10))
			smoke:SetKeyValue("EndSize", tostring(100))
			smoke:SetKeyValue("roll", tostring(10))
			smoke:SetKeyValue("Rate", tostring(10))
			smoke:SetKeyValue("JetLength", tostring(50))
			smoke:SetKeyValue("twist", tostring(5))

			//Spawn smoke
			smoke:Spawn()
			smoke:SetParent(self.Entity)
			smoke:Activate()
			
				self.Unbalance = ents.Create( "prop_physics" )
				self.Unbalance:SetModel("models/props_borealis/door_wheel001a.mdl")		
				self.Unbalance:SetAngles(self.TopProp:GetAngles())
				self.Unbalance:SetPos(self.TopProp:GetPos() + (self.Entity:GetForward() * 100))
				self.Unbalance:SetOwner(self.Owner)		
				self.Unbalance:Spawn()	
				self.Unbalance:SetColor(255,255,255,0)  
				self.Unbalance:GetPhysicsObject():SetMass(5)					
			 	constraint.Weld( self.Unbalance, self.TopProp, 0, 0, 0, 1 )	
		end
		
		if self.SmokeEffectOnce == 1 and self.Unbalance:IsValid() then
		local NewMass = 5 + ( (1 - (self.TopPropellerHealth / 40 )) * 20 )
		self.Unbalance:GetPhysicsObject():SetMass(NewMass)
		end
	end
	
	if self.TopPropellerHealth <= 40 and self.BladesAlarmDel < CurTime() and self.Entity.CanFly == 1 then
		self.MinorAlarm:Stop()
		self.MinorAlarm:Play()
		self.BladesAlarmDel = CurTime() + 14
	end
	
	if self.TopPropellerHealth <= 0 and self.RemoveTopPropOnce == 0 then
	self.RemoveTopPropOnce = 1
	local Ang = self.TopProp:GetAngles()
	local phys = self.TopProp:GetPhysicsObject()
	local Speed = phys:GetVelocity()
	local AngSpeed = phys:GetAngleVelocity()
	local Pos = phys:GetPos()
	
				self.TopProp:Remove()
				self.TopProp = ents.Create( "prop_physics" )
				self.TopProp:SetModel("models/military2/air/air_h500_r.mdl")		
				self.TopProp:SetAngles(Ang)
				self.TopProp:SetPos(Pos)
				self.TopProp:SetOwner(self.Owner)		
				self.TopProp:Spawn()
				phys = self.TopProp:GetPhysicsObject()
				phys:SetVelocity(Speed)
				phys:AddAngleVelocity( AngSpeed )
		self.HeliExt:Stop()
		self.HeliInt:Stop()	
		self.HeliStop:Stop()		
		self.HeliStop:Play()	
		
	end
	
			
	--Adding targets if there is someone in the heli
	--Adding targets so npcs will shoot you while you are inside the jet		
	if (self.Entity.UseSeatOne == 1 or self.Entity.UseSeatTwo == 1 or self.Entity.UseSeatThree == 1 or self.Entity.UseSeatFour == 1) && self.SpawnTargetsOnce == 0 then
		self.SpawnTargetsOnce = 1
		
		self.target1 = ents.Create("npc_bullseye")   
		self.target1:SetPos( self.Entity:GetPos() + ( self.Entity:GetForward() * 80 ) + ( self.Entity:GetUp() * 15 ) )
		self.target1:SetParent(self.Entity)  
		self.target1:SetKeyValue("health","9999")  
		self.target1:SetKeyValue("spawnflags","256") 
		self.target1:SetNotSolid( true )  
		self.target1:Spawn()  
		self.target1:Activate() 
		
		self.target2 = ents.Create("npc_bullseye")   
		self.target2:SetPos( self.Entity:GetPos() + ( self.Entity:GetForward() * -90 ) + ( self.Entity:GetUp() * -20 ))
		self.target2:SetParent(self.Entity)  
		self.target2:SetKeyValue("health","9999")  
		self.target2:SetKeyValue("spawnflags","256") 
		self.target2:SetNotSolid( true )  
		self.target2:Spawn()  
		self.target2:Activate() 

		self.target3 = ents.Create("npc_bullseye")   
		self.target3:SetPos( self.Entity:GetPos() + ( self.Entity:GetRight() * 40 ) + ( self.Entity:GetUp() * -10 ))
		self.target3:SetParent(self.Entity)  
		self.target3:SetKeyValue("health","9999")  
		self.target3:SetKeyValue("spawnflags","256") 
		self.target3:SetNotSolid( true )  
		self.target3:Spawn()  
		self.target3:Activate() 

		self.target4 = ents.Create("npc_bullseye")   
		self.target4:SetPos( self.Entity:GetPos() + ( self.Entity:GetRight() * -40 ) + ( self.Entity:GetUp() * -10 )) 
		self.target4:SetParent(self.Entity)  
		self.target4:SetKeyValue("health","9999")  
		self.target4:SetKeyValue("spawnflags","256") 
		self.target4:SetNotSolid( true )  
		self.target4:Spawn()  
		self.target4:Activate() 

		self.target5 = ents.Create("npc_bullseye")   
		self.target5:SetPos( self.Entity:GetPos() + ( self.Entity:GetUp() * -50 ))
		self.target5:SetParent(self.Entity)  
		self.target5:SetKeyValue("health","9999")  
		self.target5:SetKeyValue("spawnflags","256") 
		self.target5:SetNotSolid( true )  
		self.target5:Spawn()  
		self.target5:Activate() 		
	end
	
	if self.SpawnTargetsOnce == 1 then
		for k,v in pairs(ents.FindByClass("npc_*")) do
			if ( string.find(v:GetClass(), "npc_antlionguard")) or ( string.find(v:GetClass(), "npc_combine*")) or ( string.find(v:GetClass(), "*zombie*")) or ( string.find(v:GetClass(), "npc_helicopter")) or ( string.find(v:GetClass(), "npc_manhack")) or ( string.find(v:GetClass(), "npc_metropolice")) or ( string.find(v:GetClass(), "npc_rollermine")) or ( string.find(v:GetClass(), "npc_strider")) or ( string.find(v:GetClass(), "npc_turret*")) or ( string.find(v:GetClass(), "npc_hunter")) or ( string.find(v:GetClass(), "antlion")) then
					v:Fire( "setrelationship", "npc_bullseye D_HT 5" )
			end
		end	
	end
	
	if self.Entity.UseSeatOne == 0 && self.Entity.UseSeatTwo == 0 && self.Entity.UseSeatThree == 0 && self.Entity.UseSeatFour == 0 && self.SpawnTargetsOnce == 1 then
		self.SpawnTargetsOnce = 0
		
		if self.target1 != NULL then
			self.target1:Remove()
			self.target1 = NULL
		end	
		
		if self.target2 != NULL then
			self.target2:Remove()
			self.target2 = NULL
		end	

		if self.target3 != NULL then
			self.target3:Remove()
			self.target3 = NULL
		end	

		if self.target4 != NULL then
			self.target4:Remove()
			self.target4 = NULL	
		end	

		if self.target5 != NULL then
			self.target5:Remove()
			self.target5 = NULL		
		end				
	end
	
end

function ENT:OnRemove()

	if self.target1 != NULL then
		self.target1:Remove()
	end	
	
	if self.target2 != NULL then
		self.target2:Remove()
	end	

	if self.target3 != NULL then
		self.target3:Remove()
	end	

	if self.target4 != NULL then
		self.target4:Remove()
	end	

	if self.target5 != NULL then
		self.target5:Remove()
	end		
	
	if self.TopProp:IsValid() then
	self.TopProp:Remove()
	end
	if self.BackProp:IsValid() then
	self.BackProp:Remove()
	end
	if 	self.Entity.SeatOne:IsValid() then
		self.Entity.SeatOne:Remove()
	end
	if 	self.Entity.SeatTwo:IsValid() then
		self.Entity.SeatTwo:Remove()
	end
	if 	self.Entity.SeatThree:IsValid() then
		self.Entity.SeatThree:Remove()
	end
	if 	self.Entity.SeatFour:IsValid() then
	self.Entity.SeatFour:Remove()
	end	
	if self.Unbalance:IsValid() then
	self.Unbalance:Remove()
	end
	
	if self.RedDotLaser ~= 1 then
		self.RedDotLaser:Remove()
	end
	
	self.HeliStart:Stop()
	self.HeliStop:Stop()
	self.HeliExt:Stop()
	self.HeliInt:Stop()
	self.MissileAlert:Stop()
	self.ShootSound:Stop()
	self.StopShootSound:Stop()
	self.CrashAlarm:Stop()
	self.LowHealth:Stop()
	self.MinorAlarm:Stop()
	self.MissileShoot:Stop()	
	
end

 local function SetPlyAnimation( pl, anim )

	 if pl:InVehicle( ) then
	 local Veh = pl:GetVehicle()
	
		if string.find(Veh:GetModel(), "models/nova/airboat_seat") then 
		
			local seq = pl:LookupSequence( "sit" )
				
			pl:SetPlaybackRate( 1.0 )
			pl:ResetSequence( seq )
			pl:SetCycle( 0 )
			return true

		end
	end
end
hook.Add( "SetPlayerAnimation", "SetHeliChairAnim", SetPlyAnimation )

function ENT:Shoot(BulletNum,Origin,Dir,Spread,GunUser)

	// Make a muzzle flash
	local effectdata = EffectData()
		effectdata:SetOrigin( Origin )
		effectdata:SetAngle( Dir )
		effectdata:SetScale( 1 )
	util.Effect( "MuzzleEffect", effectdata )


	// Shoot a bullet
	local bullet = {}
		bullet.Num 			= BulletNum
		bullet.Src 			= Origin
		bullet.Dir 			= Dir
		bullet.Spread 		= Spread
		bullet.Tracer		= 1
		bullet.TracerName	= "Tracer"
		bullet.Force		= 10
		bullet.Damage		= 30
		bullet.Attacker 	= GunUser		
	self.Entity:FireBullets( bullet )
	

	


end