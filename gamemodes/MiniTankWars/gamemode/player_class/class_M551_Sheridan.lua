/*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in shared.lua
------------------------
class_M551_Sheridan.lua
	-M551 Sheridan Class setup
*/


local CLASS = {}
 
CLASS.DisplayName			= "M551 Sheridan"
CLASS.WalkSpeed 			= 256
CLASS.CrouchedWalkSpeed 	= 0.3
CLASS.RunSpeed				= 512
CLASS.DuckSpeed				= 0.3
CLASS.JumpPower				= 0
CLASS.DrawTeamRing			= false
CLASS.DrawViewModel		= false
CLASS.CanUseFlashlight      = false
CLASS.MaxHealth				= 90
CLASS.StartHealth			= 75
CLASS.StartArmor			= 0
CLASS.RespawnTime           = 0 // 0 means use the default spawn time chosen by gamemode
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= false
CLASS.AvoidPlayers			= false // Automatically avoid players that we're no colliding
CLASS.Selectable			= true // When false, this disables all the team checking
CLASS.FullRotation			= true // Allow the player's model to rotate upwards, etc etc
 
function CLASS:Loadout( pl )
	pl:Give( "weapon_lightcannon" )
end
 
function CLASS:OnSpawn( pl )
	pl:SetNWString("TankName", pl:GetPlayerClassName())
	pl.TankEnt = ents.Create( "M551_Sheridan" )
	pl.TankEnt:SetPos(pl:GetPos())
	pl.TankEnt:SetAngles(pl:GetAngles())	
	pl.TankEnt:Spawn()
	pl:SetMoveType(MOVETYPE_NONE)
	pl:SetCollisionGroup(COLLISION_GROUP_NONE)
	pl:SetParent(pl.TankEnt)
	pl.TankEnt:SetPlayerModel(pl:GetModel())
	pl.TankEnt:SetMyPlayer(pl)
	
	pl:SetNoDraw(true)
	pl:DrawShadow(false)  //just to be safe
	if (CLIENT) then pl:DestroyShadow() end
	pl:SetColor( Color(0,0,0,0) )   //see above
end

function CLASS:OnDeath( pl, attacker, dmginfo )
	if (pl.TankEnt) then
		local Wreck = ents.Create( "TankWreck" )
		Wreck:SetPos(pl.TankEnt:GetPos())
		Wreck:SetAngles(pl.TankEnt:GetAngles())
		Wreck:Spawn()
		Wreck:SetTank("M551_Sheridan")
		Wreck:GetPhysicsObject():ApplyForceCenter(Vector(0,0,1000))
		
		local ed = EffectData()
		ed:SetEntity(Wreck)
		ed:SetOrigin(Wreck:GetPos())
		util.Effect("TankSplode", ed, true, true)

		pl.TankEnt:Remove()
		pl.TankEnt=NULL
	end
	if (CLIENT) then
		local head=pl:GetRagdollEntity():GetPhysicsObjectNum(10)
		head:ApplyForceCenter(Vector(0,0,10000))
	end
end
 
function CLASS:PlayerDisconnected(pl)
	if (pl.TankEnt) then
		pl.TankEnt:Remove()
		pl.TankEnt=NULL
	end
	GAMEMODE:ChatBroadCast(pl.Nick().." deserted!")
end 
 
function CLASS:Think( pl )
	if (pl.TankEnt and pl.TankEnt:IsValid() and pl:Alive()) then
		pl:SetPos(pl.TankEnt:GetPos())
		pl:SetAngles(pl.TankEnt:GetAngles())
	end
end

function CLASS:OnKeyPress( pl, key )
	if (pl:GetNWBool("FlipPrompt", false)==true) then
		if (pl:KeyDown( IN_USE )) then
			pl:SetNWBool("FlipPrompt", false)
			if (SERVER) then pl.TankEnt:FlipTank() end
		end
	end
end
 
function CLASS:OnKeyRelease( pl, key )
end


function CLASS:CalcView( pl, origin, angles, fov )
	if ( !pl:Alive() ) then return end
	
	local DistanceAngle = angles:Forward() * - 0.8 + angles:Up() * 0.2
	
	local ret = {}
	ret.origin = origin + DistanceAngle * 350
	//ret.angles  	= angles
	//ret.fov 		= fov
	return ret
end
 
player_class.Register( "M551_Sheridan", CLASS )  
