 /*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in /shared.lua
------------------------
ProtoTank init.lua
	-ProtoTank Entity serverside init
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local EngineSound = Sound("ambient/machines/diesel_engine_idle1.wav")

function ENT:Initialize()
	self.Entity.MyPlayer = NULL
	
	self.Entity:SetModel( "models/BMCha/MiniTanks/BMP-3/BMP-3_Body.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.TurretEnt= ents.Create( "BMP-3_Turret" )
	self.TurretEnt:SetParent(self.Entity)
	self.TurretEnt:SetPos(self.Entity:GetPos())
	self.TurretEnt:SetAngles(self.Entity:GetAngles())
	self.TurretEnt:Spawn()
	
	self.TracksEnt= ents.Create( "BMP-3_Tracks" )
	self.TracksEnt:SetParent(self.Entity)
	self.TracksEnt:SetPos(self.Entity:GetPos())
	self.TracksEnt:SetAngles(self.Entity:GetAngles())
	self.TracksEnt:Spawn()
	self.TracksEnt:SetNWEntity("TankBody", self.Entity )   
	
	/*---------------------------------------------
			Tank Differentiating Variables
	---------------------------------------------*/
	self.Entity.TopSpeed = 548
	self.Entity.Acceleration = 600
	self.Entity.Speed = 0
	
	self.Entity.TurnTopSpeed = 115
	self.Entity.TurnSpeed = 0
	self.Entity.SpeedMul = 1
	//-----------------------------------------------
	
	self.Entity.LastSpeed=0
	self.Entity.LastTime=CurTime()
	self.Entity.LastThink=CurTime()
	
	self.Entity.EngineSound=CreateSound(self.Entity, EngineSound)
	self.Entity.EngineSound:Play()
	
	self.Entity.LastFlip=CurTime()
end

function ENT:OnRemove() 
	self.TurretEnt:Remove()
	self.TracksEnt:Remove()
	self.Entity.EngineSound:Stop()
end


function ENT:SetPlayerModel( playersmodel )
	self.TurretEnt:SetPlayerModel( playersmodel)
end


function ENT:SetMyPlayer( pl )
	self.Entity.MyPlayer=pl
	self.Entity:SetNWEntity("MyPlayer", pl)
	self.Entity:SetOwner(pl)
	self.TurretEnt.MyPlayer=pl
	self.TurretEnt:SetOwner(pl)
	self.TracksEnt.MyPlayer=pl
	self.TracksEnt:SetOwner(pl)
	
	pl:SetNWBool("PowerupActive", false)
	pl:SetNWString("PowerupName", "None")
	pl:SetNWFloat("PowerupTime", 0)
	pl:SetNWFloat("PowerupTotTime", 1)
	pl:SetNWEntity("TurretEnt", self.TurretEnt)
end

//////////////////////////////////////////////////////////////////
function ENT:Think()
	if !self.Entity.MyPlayer:IsValid() then
		self.Entity:Remove()
	end
	if !self.Entity.MyPlayer:Alive() then
		self.Entity:Remove()
	end
	self.Entity:GetPhysicsObject():Wake()
	//powerup management
	if (self.Entity.MyPlayer and self.Entity.MyPlayer:IsValid() and self.Entity.MyPlayer:Alive()) then
		if self.Entity.MyPlayer:GetNWBool("PowerupActive")==true then
			local time = self.Entity.MyPlayer:GetNWFloat("PowerupTime", 0)
			time = time-(CurTime()-self.Entity.LastThink)
			if time < 0 then
				self.Entity:EndPowerUp()
			else
				self.Entity.MyPlayer:SetNWFloat("PowerupTime", time)
			end
		end
	end
	self.Entity.LastThink=CurTime()
	self.Entity.EngineSound:ChangePitch(math.Clamp(   ((math.abs(self.Entity.Speed)/self.Entity.TopSpeed)*57+100)   , 100, 255))
end

function ENT:PowerUp( PUName, PUTime )
	if self.Entity.MyPlayer:GetNWBool("PowerupActive")==true then
		self.Entity:EndPowerUp()
	end
	self.Entity.MyPlayer:SetNWBool("PowerupActive", true)
	self.Entity.MyPlayer:SetNWString("PowerupName", PUName)
	self.Entity.MyPlayer:SetNWFloat("PowerupTime", PUTime)
	self.Entity.MyPlayer:SetNWFloat("PowerupTotTime", PUTime)
	//effects of powerup
	if (PUName=="SpeedBoost") then
		self.Entity.SpeedMul = 1.5
	end
	if (PUName=="AP") then
		self.Entity.MyPlayer:SetNWBool("AP", true)
	end
	if (PUName=="QuickReload") then
		self.Entity.MyPlayer:SetNWFloat("Delay", 0.75)
	end
end

function ENT:EndPowerUp()
	local PUName=self.Entity.MyPlayer:GetNWString("PowerupName")
	//disable effects of powerup
	if (PUName=="SpeedBoost") then
		self.Entity.SpeedMul=1.0
	end
	if (PUName=="AP") then
		self.Entity.MyPlayer:SetNWBool("AP", false)
	end
	if (PUName=="QuickReload") then
		self.Entity.MyPlayer:SetNWFloat("Delay", 1.5)
	end
	//reset
	self.Entity.MyPlayer:SetNWBool("PowerupActive", false)
	self.Entity.MyPlayer:SetNWString("PowerupName", "None")
	self.Entity.MyPlayer:SetNWFloat("PowerupTime", 0)
	self.Entity.MyPlayer:SetNWFloat("PowerupTotTime", 1)
end
//////////////////////////////////////////////////////////////////

function ENT:FlipTank()
	if CurTime()-self.Entity.LastFlip < 2 then 
		self.Entity.MyPlayer:ChatPrint("Wait a little longer..")
		return
	end
	self.Entity:SetAngles(Angle(0, self.Entity:GetAngles().y, 0))
	self.Entity:SetPos(self.Entity:GetPos()+Vector(0,0,100))
	self.Entity.Speed=0
	local phys=self.Entity:GetPhysicsObject()
	phys:SetVelocity(Vector(0,0,100))
	phys:AddAngleVelocity(phys:GetAngleVelocity()*-1)
	self.Entity.LastFlip=CurTime()
end

function ENT:Recoil(force, vec)
	self.Entity:GetPhysicsObject():AddVelocity(vec*-force)
end
//------------------TAnk Movement-------------------------------------
function ENT:PhysicsUpdate( phys )
	local dt=CurTime()-self.Entity.LastTime
	self.Entity.LastTime=CurTime()
	if self.Entity.Flipping==true then return end
	
	phys:Wake()
	local pl = self.Entity.MyPlayer
	if !pl:IsValid() then return end
	if pl:Alive() then
		local up = phys:GetAngle():Up()
		if ( up.z < 0.6 ) then
			phys:Wake()
			if (pl:GetNWBool("FlipPrompt", false)==false) then
				pl:SetNWBool("FlipPrompt", true)
			end
			return
		else
			if (pl:GetNWBool("FlipPrompt", true)==true) then
				pl:SetNWBool("FlipPrompt", false)
			end
		end
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////
		self.TurretEnt:Update(dt)
		local tankSpeed = self.Entity.Speed
		local tankTopSpeed = self.Entity.TopSpeed
		local tankAcceleration = self.Entity.Acceleration
		local tankTurnTopSpeed = self.Entity.TurnTopSpeed
		local tankTurnSpeed = self.Entity.TurnSpeed
		local tankSpeedMul = self.Entity.SpeedMul
		tankTopSpeed=tankTopSpeed*tankSpeedMul
		
		if pl:KeyDown( IN_FORWARD ) then
			tankSpeed = math.Clamp(tankSpeed+(tankAcceleration*dt), -tankTopSpeed/2, tankTopSpeed)
		end
		if pl:KeyDown( IN_BACK ) then
			tankSpeed = math.Clamp(tankSpeed-(tankAcceleration*dt), -tankTopSpeed/2, tankTopSpeed)
		end
		if not (pl:KeyDown( IN_FORWARD ) or pl:KeyDown( IN_BACK )) then
			if (tankSpeed > 0) then
				tankSpeed = math.Clamp(tankSpeed-(tankAcceleration*dt), 0, tankTopSpeed)
			elseif (tankSpeed < 0) then
				tankSpeed = math.Clamp(tankSpeed+(tankAcceleration*dt), -tankTopSpeed/2, 0)
			end
		end
		self.Entity.Speed = tankSpeed
		
		if pl:KeyDown( IN_MOVELEFT ) then
			tankTurnSpeed=math.Clamp(tankTurnSpeed+(tankTurnTopSpeed*dt), -tankTurnTopSpeed, tankTurnTopSpeed)
			tankSpeed=tankSpeed*(1-((math.abs(tankTurnSpeed)/tankTurnTopSpeed)*0.5))
		elseif pl:KeyDown( IN_MOVERIGHT ) then
			tankTurnSpeed=math.Clamp(tankTurnSpeed-(tankTurnTopSpeed*dt), -tankTurnTopSpeed, tankTurnTopSpeed)
			tankSpeed=tankSpeed*(1-((math.abs(tankTurnSpeed)/tankTurnTopSpeed)*0.5))
		else
			if (tankTurnSpeed > 0) then
				tankTurnSpeed = math.Clamp(tankTurnSpeed-(tankTurnTopSpeed*dt*2), 0, tankTurnTopSpeed)
			elseif (tankTurnSpeed < 0) then
				tankTurnSpeed = math.Clamp(tankTurnSpeed+(tankTurnTopSpeed*dt*2), -tankTurnTopSpeed, 0)
			end
		end
		self.Entity.TurnSpeed = tankTurnSpeed
		
		local Vel = phys:GetVelocity()
		local RightVel = phys:GetAngle():Right():Dot( Vel )
		
		//****************LINEAR TEIM************************
		//stop skidding(tracks (well, wheels too) don't go sideways)
		RightVel = RightVel * -0.5
		
		if tankSpeed>0 then
			Linear=tankSpeed-math.Clamp(self.Entity:GetForward():Dot(Vel), 0, tankSpeed)
			Linear=Linear*(  0.6  -  math.Clamp(self.Entity:GetForward():Dot(Vector(0,0,1)), -0.6,0.6)  )*1.67
		else
			Linear=tankSpeed+math.Clamp(-self.Entity:GetForward():Dot(Vel), 0, -tankSpeed)
			Linear=Linear*(  0.6  -  math.Clamp((self.Entity:GetForward()*-1):Dot(Vector(0,0,1)), -0.6,0.6)  )*1.67
		end
		Linear=Vector(Linear,-RightVel,0)  //rightvel
		Linear=(self.Entity:LocalToWorld(Linear)-self.Entity:GetPos())
		phys:AddVelocity(Linear)
		//**************ANGULAR TIEM************************
		local AngVel=Vector( 0, 0, ((-1*phys:GetAngleVelocity().z)+tankTurnSpeed) )
		if not (math.abs(tankSpeed) < 5 and math.abs(tankTurnSpeed) < 1) then
			phys:AddAngleVelocity(AngVel)
		end
		
	end
	return
end
