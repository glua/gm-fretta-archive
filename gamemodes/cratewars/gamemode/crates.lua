function GM:CheckForNeutrals()
	for k,v in pairs( ents.FindByModel( "models/props_junk/wood_crate001a.mdl" ) ) do
		if( v:GetClass( ) != "box_ent" ) then
			local pos = v:GetPos()
			v:Remove()
			CreateNeutralCrate(pos)
		end
	end
end

function GM:CheckForBuildings()
	for k,v in pairs( ents.FindByClass("cw_building") ) do
		local building = LoadRandomBuilding()
		local pos = v:GetPos()
		v:Remove()
		pos = pos-Vector(156-26,156-26,-26)
		for l=1,6 do
			for r=1,6 do
				for b=1,6 do
					if(building[l][r][b] == '1')then
						CreateNeutralCrate(pos+Vector(52*(b-1),52*(r-1),52*(l-1)))
					end
				end
			end
		end
	end
end

function LoadRandomBuilding()
	local buildings = file.Find("mhs/cw_buildings/*.txt")
	local building = "mhs/cw_buildings/" .. table.Random(buildings)
	//local building = "mhs/cw_buildings/blank.txt"
	local contents = file.Read(building)
	local BuildingArray = string.Explode("n", contents)
	for k,v in pairs(BuildingArray) do
		BuildingArray[k] = string.Explode(".", v)
		for j,i in pairs(BuildingArray[k]) do
			BuildingArray[k][j] = string.Explode(",", i)
		end
	end
	return BuildingArray
end

function CreateNeutralCrate(pos)
	local box = ents.Create("box_ent")
	box:SetPos(pos)
	box:Spawn()
	box:Activate()
	box:SetColor(255, 0, 255, 255)
	box.IsNeutral = true
end