WARE.Author = "Hurricaaane (Ha3)"

WARE.PossibleColors = {
{ "black" , Color(0,0,0,255) },
{ "grey" , Color(138,138,138,255), Color(255,255,255,255) },
{ "white" , Color(255,255,255,255), Color(0,0,0,255) },
{ "red" , Color(220,0,0,255) },
{ "green" , Color(0,220,0,255) },
{ "blue" , Color(64,64,255,255) },
{ "pink" , Color(255,0,255,255) }
}

WARE.Models = {
"models/props_c17/furniturewashingmachine001a.mdl"
 }
 
WARE.Props = {}

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_REFLEX )
	GAMEMODE:SetWareWindupAndLength(0.7,4)
	
	self.Props = {}
	
	local spawnedcolors = {}
	local magicCopy = {}
	for k=1,#self.PossibleColors do
		magicCopy[k] = k
	end
	
	local ratio = 0.5
	local minimum = 4
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS)*ratio), minimum, #self.PossibleColors)
	local entposcopy = GAMEMODE:GetRandomLocations(num, ENTS_OVERCRATE)
	
	for k,v in pairs(entposcopy) do
		local chosenColor = math.random(1, #magicCopy)
		local colorID = table.remove( magicCopy , chosenColor )
		table.insert(spawnedcolors, colorID)
		
		local ent = ents.Create("prop_physics")
		ent:SetModel( self.Models[1] )
		ent:SetPos(v:GetPos())
		ent:SetAngles(Angle(0,math.Rand(0,360),0) )
		ent:Spawn()
		
		ent:GetPhysicsObject():EnableMotion(false)
		GAMEMODE:AppendEntToBin(ent)
		
		table.insert( self.Props , ent )
		
		ent.ColorID = colorID
		ent:SetColor(self.PossibleColors[colorID][2].r, self.PossibleColors[colorID][2].g, self.PossibleColors[colorID][2].b, self.PossibleColors[colorID][2].a)

		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
	local selected = table.Random(spawnedcolors)
	self.SelectedColorID = selected
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Shoot the ".. self.PossibleColors[selected][1] .." prop!" , self.PossibleColors[selected][2] or nil, self.PossibleColors[selected][3] or nil )
	
end

function WARE:StartAction()
	for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		ply:Give("sware_pistol")
		ply:GiveAmmo(12, "Pistol", true)
	end
	
end

function WARE:EndAction()
	for k,prop in pairs( self.Props ) do
		if prop.ColorID == self.SelectedColorID then
			GAMEMODE:MakeLandmarkEffect( prop:GetPos() )
			break
		end
	end
end

function WARE:EntityTakeDamage( ent, inf, att, amount, info )
	if att:IsPlayer() == false or info:IsBulletDamage() == false then return end
	if not ent.ColorID then return end
	
	if ent.ColorID == self.SelectedColorID then
		att:ApplyWin( )
	else
		att:ApplyLose( )
	end
	
	att:StripWeapons()
	
end
