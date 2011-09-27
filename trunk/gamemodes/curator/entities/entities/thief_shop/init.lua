
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
 
local LookSch = ai_schedule.New( "LookingSched" )
	LookSch:EngTask( "TASK_FACE_PLAYER", 	0)
 
function ENT:Initialize()
 
	self:SetModel( "models/Humans/Group01/Male_01.mdl" )
 
	self:SetHullType( HULL_HUMAN );
	self:SetHullSizeNormal();
 
	self:SetSolid( SOLID_BBOX ) 
	self:SetMoveType( MOVETYPE_STEP )
 
	self:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_ANIMATEDFACE | CAP_TURN_HEAD )
 
	self:SetMaxYawSpeed( 5000 )

	self:SetHealth(100)
	
	self:SetAngles(Angle(0,180,0))
	
	--self:SetUseType(SIMPLE_USE)
 
end
 
 function ENT:OnTakeDamage(dmg)
	self:SetHealth(1000)
 end 
 
 
/*---------------------------------------------------------
   Name: SelectSchedule
---------------------------------------------------------*/
function ENT:SelectSchedule()
 
	self:StartSchedule( LookSch )
 
end


function ENT:OnRemove()

end
--[[
function ENT:Use(ply,callr)
	print("Wub wub wub, using!")
	if ply ~= GAMEMODE.Curator and ply:Alive() then
		SendUserMessage("OpenThiefBuyMenu",ply)
	end
end ]]
