WARE.Author = "Kilburn"

WARE.Models = {
"models/props_junk/wood_crate001a.mdl",
"models/props_wasteland/speakercluster01a.mdl"
 }

local Alarms = {
	"ambient/alarms/alarm_citizen_loop1.wav",
	"ambient/alarms/alarm1.wav",
	"ambient/alarms/city_firebell_loop1.wav",
	"ambient/alarms/siren.wav",
}

WARE.Speakers = {}

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY )

	local maxcount = table.Count(GAMEMODE:GetEnts(ENTS_ONCRATE))
	
	local numberAlarmSpawns = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS)*0.5),1,maxcount)
	local numberNormalSpawns = math.Clamp(team.NumPlayers(TEAM_HUMANS)+1,4,maxcount-numberAlarmSpawns)
	
	self.Speakers = {}
	
	GAMEMODE:SetWareWindupAndLength(3,8)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Listen..." )
	
	for i,pos in ipairs(GAMEMODE:GetRandomPositionsAvoidBox(numberAlarmSpawns+numberNormalSpawns, ENTS_ONCRATE, function(v) return v:IsPlayer() end, Vector(-30,-30,-30), Vector(30,30,30))) do
		pos = pos + Vector(0,0,100)
		
		local prop = ents.Create("prop_physics")
		prop:SetModel(self.Models[1])
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(pos)
		prop:Spawn()
		
		prop:SetMoveType(MOVETYPE_NONE)
		
		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:MakeAppearEffect(pos)
		
		if i<=numberAlarmSpawns then
			local speaker = ents.Create("prop_physics")
			speaker:SetModel(self.Models[2])
			speaker:PhysicsInit(SOLID_VPHYSICS)
			speaker:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			speaker:SetSolid(SOLID_VPHYSICS)
			speaker:SetPos(prop:GetPos())
			speaker:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
			speaker:Spawn()
			speaker:SetColor(255,255,255,0)
			speaker:GetPhysicsObject():EnableMotion(false)
			
			speaker.AlarmSound = CreateSound(speaker, Sound(Alarms[math.random(1,#Alarms)]))
			prop.Speaker = speaker
			
			table.insert( self.Speakers , speaker )
			
			GAMEMODE:AppendEntToBin(speaker)
		end
	end
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Shut it down!" )
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give("weapon_crowbar")
	end
	
	for _,v in pairs(self.Speakers) do
		v.AlarmSound:Play()
	end
end

function WARE:EndAction()
	for _,v in pairs( self.Speakers ) do
		if v.AlarmSound then
			if not v.AlarmPitch then
				GAMEMODE:MakeLandmarkEffect(v:GetPos())
			end
			v.AlarmSound:Stop()
			v.AlarmSound = nil
		end
	end
end

function WARE:Think()
	for _,v in pairs(self.Speakers) do
		if v.AlarmSound and v.AlarmPitch then
			v.AlarmPitch = v.AlarmPitch - 0.7
			v.AlarmSound:ChangePitch(v.AlarmPitch)
			
			if v.AlarmPitch<=1 then
				v.AlarmSound:Stop()
				v.AlarmSound = nil
				v.AlarmPitch = nil
			end
		end
	end
end

function WARE:PropBreak(pl,prop)
	if not (pl:IsPlayer() and pl:IsWarePlayer()) then return end
	
	if prop.Speaker then
		pl:ApplyWin()
		pl:StripWeapons()
		
		prop.Speaker.AlarmPitch = 100
		
		local spark = ents.Create("env_spark")
		spark:SetPos(prop.Speaker:GetPos())
		spark:SetKeyValue("MaxDelay",1)
		spark:SetKeyValue("Magnitude",4)
		spark:SetKeyValue("TrailLength",2)
		spark:Spawn()
		spark:SetParent(prop.Speaker)
		spark:Fire("StartSpark")
		
		prop.Speaker:SetColor(255,255,255,255)
		prop.Speaker:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
		prop.Speaker:GetPhysicsObject():EnableMotion(true)
		prop.Speaker:GetPhysicsObject():Wake()
		prop.Speaker:GetPhysicsObject():AddAngleVelocity(Angle(math.random(500,2000),math.random(500,2000),math.random(500,2000)))
		prop.Speaker:GetPhysicsObject():ApplyForceCenter((prop:GetPos()-pl:GetPos()-Vector(0,0,20)):GetNormal() * math.random(10000,20000))
	end
end
