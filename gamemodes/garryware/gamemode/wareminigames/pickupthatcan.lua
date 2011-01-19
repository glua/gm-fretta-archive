WARE.Author = "Kilburn"

WARE.Models = {
"models/props_junk/popcan01a.mdl",
"models/props_trainstation/trashcan_indoor001b.mdl"
 }
 
WARE.TrailColor = Color(255,255,255,92)

function WARE:GetModelList()
	return self.Models
end

function WARE:FlashCans( iteration, delay )
	for k,ent in pairs(ents.FindByModel(self.Models[1])) do
		GAMEMODE:MakeAppearEffect( ent:GetPos() )
	end
	if (iteration > 0) then
		timer.Simple( delay , self.FlashCans, self , iteration - 1, delay )
	end
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	GAMEMODE:SetWareWindupAndLength(3,5)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Pick up that can!" )
	
	local numberSpawns = math.Clamp(team.NumPlayers(TEAM_HUMANS),1,table.Count(GAMEMODE:GetEnts(ENTS_INAIR)))
	
	-- HAXX
	-- GravGunOnPickedUp hook is broken, so we'll use this tricky workaround
	local lua_run = ents.Create("lua_run")
	
	lua_run:SetKeyValue('Code','CALLER.CanOwner=ACTIVATOR')
	lua_run:SetKeyValue('targetname','luarun')
	lua_run:Spawn()
	
	for _,pos in ipairs(GAMEMODE:GetRandomPositions(numberSpawns, ENTS_INAIR)) do
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[1] )
		prop:SetSkin(math.random(0,2))
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetMoveType(MOVETYPE_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(pos)
		prop:SetAngles(Angle(math.random(-180,180),math.random(-180,180),math.random(-180,180)))
		prop:Spawn()
		
		prop:Fire("AddOutput", "OnPhysGunPickup luarun,RunCode")
		
		util.SpriteTrail(prop,0,self.TrailColor,false,1.2,2.2,5,1/((1.2+2.2)*0.5),"trails/physbeam.vmt")
		
		GAMEMODE:AppendEntToBin(prop)
	end
	
	self:FlashCans( 6 , 0.3 )
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Now put it in the trashcan!" )
	
	self.Trashcans = {}
	local pos = GAMEMODE:GetRandomPositionsAvoidBox(2, ENTS_ONCRATE, function(v) return v:IsPlayer() end, Vector(-64,-64,64), Vector(64,64,64))
	
	for k,v in pairs(pos) do
		local trash = ents.Create("prop_physics")
		trash:SetModel( self.Models[2] )
		trash:PhysicsInit(SOLID_VPHYSICS)
		trash:SetSolid(SOLID_VPHYSICS)
		
		trash:SetPos(v)
		trash:Spawn()
		
		local obbmins = trash:OBBMins()
		local newpos = v - Vector(0,0,obbmins.z)
		trash:SetPos(newpos)
		trash:SetMoveType(MOVETYPE_NONE)
		
		GAMEMODE:AppendEntToBin(trash)
		table.insert(self.Trashcans,trash)
		
		GAMEMODE:MakeAppearEffect( v )
	end
end

function WARE:EndAction()
	for _,v in pairs(ents.FindByClass("lua_run")) do
		v:Remove()
	end
end

function WARE:Think()
	if self.Trashcans then
		if not self.NextTrashThink or CurTime() > self.NextTrashThink then
		
			for l,w in pairs(self.Trashcans) do
			
				local bmin,bmax = w:WorldSpaceAABB()
				for _,v in pairs(ents.FindInBox(bmin + Vector(12,12,14),bmax - Vector(12,12,10))) do
					if v:GetModel()=="models/props_junk/popcan01a.mdl" then
						local Owner = v.CanOwner
						if Owner and Owner:IsPlayer() then
							GAMEMODE:MakeAppearEffect(v:GetPos())
							v:Remove()
						
							Owner:StripWeapons()
							Owner:ApplyWin( )
						end
					end
				end
				
			end
			
			self.NextTrashThink = CurTime()+0.1
		end
	end
end
