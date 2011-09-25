
local meta = FindMetaTable( "Entity" )
if (!meta) then return end 

function meta:Break()

	if self.Gibs then
	
		local handler = ents.Create( "gib_handler" )
		handler:SetPos( self:GetPos() )
		handler:SetAngles( self:GetAngles() )
		handler:SetModel( self:GetModel() )
		handler:SetGibs( self.Gibs )
		handler:Spawn()
		
	end
	
	self.HP = 9000
	self:Fire( "break", 0.05, 0.05 )
	
end

GM.Props = {}

local function AddProp( name, model, price, health, gibs, bonus )

	local tbl = { Name = name, Model = model, Price = price, HP = health }
	
	if gibs then
		tbl.Gibs = gibs
	end
	
	if bonus then
		tbl.Bonus = bonus
	end
	
	table.insert( GM.Props, tbl )
	
end

function GM:GetRandomPropInfo()
	return table.Random( GAMEMODE.Props )
end

// Big fucking list of props and their prices etc
// Taken from the original Asshole Physics

// Bonus Props 
AddProp( "Cash Crate", "models/props_junk/wood_crate001a.mdl", 10, 10, "cashcrate", "prop_cashbox" )  
AddProp( "Gnome", "models/props_junk/gnome.mdl", 10, 10, nil, "prop_gnome" )
AddProp( "Dynamite", "models/dav0r/tnt/tnt.mdl", 10, 10, nil, "prop_dynamite" ) 

// CS_Office
AddProp( "Computer", "models/props/cs_office/computer_caseb.mdl", 800, 70 )
AddProp( "LCD Monitor", "models/props/cs_office/computer_monitor.mdl", 500, 50 )
AddProp( "Keyboard", "models/props/cs_office/computer_keyboard.mdl", 20, 30 )
AddProp( "Mouse", "models/props/cs_office/computer_mouse.mdl", 30, 20 )
AddProp( "Projector", "models/props/cs_office/projector.mdl", 120, 120 )
AddProp( "Important Files", "models/props/cs_office/file_box.mdl", 200, 70 )
AddProp( "Phone", "models/props/cs_office/phone.mdl", 30, 50 )
AddProp( "The Spirit of Christmas", "models/props/cs_office/snowman_face.mdl", 0, 50 )
AddProp( "Plant", "models/props/cs_office/plant01.mdl", 60, 50 )
AddProp( "Radio", "models/props/cs_office/radio.mdl", 30, 40 )
AddProp( "Plasma TV", "models/props/cs_office/tv_plasma.mdl", 2000, 150 ) 
AddProp( "Coffee Table", "models/props/cs_office/table_coffee.mdl", 80, 130 )
AddProp( "File Cabinet", "models/props/cs_office/file_cabinet1.mdl", 90, 250, "cabinet" )
AddProp( "File Cabinet", "models/props/cs_office/file_cabinet2.mdl", 90, 250, "cabinet" )
AddProp( "File Cabinet", "models/props/cs_office/file_cabinet3.mdl", 90, 250, "cabinet" )
AddProp( "Microwave", "models/props/cs_office/microwave.mdl", 60, 200, "microwave" )
AddProp( "Painting", "models/props/cs_office/offpaintinga.mdl", 30, 50, "window" )
AddProp( "Painting", "models/props/cs_office/offpaintingb.mdl", 50, 50, "window" )
AddProp( "Painting", "models/props/cs_office/offpaintinge.mdl", 70, 50, "window" )
AddProp( "Painting", "models/props/cs_office/offpaintingd.mdl", 100, 50, "window" )
AddProp( "Painting", "models/props/cs_office/offpaintingf.mdl", 150, 50, "window" )

//CS_Militia
AddProp( "Stool", "models/props/cs_militia/barstool01.mdl", 100, 150 )

// DE_Inferno
AddProp( "Antique Chair", "models/props/de_inferno/chairantique.mdl", 300, 140 )
AddProp( "Antique Table", "models/props/de_inferno/tablecoffee.mdl", 400, 160 )
AddProp( "Clay Pot", "models/props/de_inferno/claypot01.mdl", 200, 100 )
AddProp( "Clay Pot", "models/props/de_inferno/claypot02.mdl", 200, 100 )
AddProp( "Wine Barrel", "models/props/de_inferno/wine_barrel.mdl", 100, 140 )

// DE_Tides
AddProp( "Menu Stand", "models/props/de_tides/menu_stand.mdl", 60, 100 )

// Computer junk
AddProp( "Computer", "models/props_c17/consolebox01a.mdl", 300, 50, "computer" )
AddProp( "Computer", "models/props_c17/consolebox03a.mdl", 200, 50, "computer" )
AddProp( "Computer", "models/props_c17/consolebox05a.mdl", 150, 50, "computer" )
AddProp( "Console", "models/props_lab/reciever01a.mdl", 100, 50, "computer" )
AddProp( "Console", "models/props_lab/reciever01b.mdl", 80, 50, "computer" )
AddProp( "Console", "models/props_lab/reciever01c.mdl", 80, 50, "computer" )
AddProp( "Console", "models/props_lab/reciever01d.mdl", 50, 50, "computer" )
AddProp( "Big Console", "models/props_lab/reciever_cart.mdl", 500, 80, "computer" )
AddProp( "Computer", "models/props_lab/harddrive01.mdl", 100, 50, "computer" )
AddProp( "Computer", "models/props_lab/harddrive02.mdl", 200, 50, "computer" )
AddProp( "CRT Monitor", "models/props_lab/monitor02.mdl", 200, 50, "monitor" )
AddProp( "LCD Monitor", "models/props_lab/monitor01a.mdl", 150, 50, "monitor" )
AddProp( "Small Monitor", "models/props_lab/monitor01b.mdl", 70, 50, "monitor" )
AddProp( "TV", "models/props_c17/tv_monitor01.mdl", 50, 50, "monitor" )
AddProp( "Keyboard", "models/props_c17/computer01_keyboard.mdl", 20, 20, "keyboard" )

// Wood Junk
AddProp( "Picture Frame", "models/props_c17/frame002a.mdl", 40, 10 )
AddProp( "Crate", "models/props_junk/wood_crate001a_damaged.mdl", 60, 200 ) 
AddProp( "Crate", "models/props_junk/wood_crate002a.mdl", 80, 220 )
AddProp( "Pallet", "models/props_junk/wood_pallet001a.mdl", 100, 200 )
AddProp( "Barrel", "models/props_c17/woodbarrel001.mdl", 50, 200 )

// Furniture
AddProp( "Chair", "models/props_c17/furniturechair001a.mdl", 150, 60 )
AddProp( "Chair", "models/props_interiors/furniture_chair01a.mdl", 150, 60 )
AddProp( "Bench", "models/props_c17/bench01a.mdl", 20, 60 )
AddProp( "Drawer", "models/props_c17/furnituredrawer001a.mdl", 100, 100 )
AddProp( "Drawer", "models/props_c17/furnituredrawer002a.mdl", 50, 80 )
AddProp( "Drawer", "models/props_c17/furnituredrawer003a.mdl", 50, 80 )
AddProp( "Dresser", "models/props_c17/furnituredresser001a.mdl", 120, 100 )
AddProp( "Shelf", "models/props_c17/furnitureshelf001a.mdl", 100, 80 )
AddProp( "Board", "models/props_c17/furnitureshelf001b.mdl", 10, 20 )
AddProp( "Table", "models/props_c17/furnituretable001a.mdl", 100, 60 )
AddProp( "Table", "models/props_c17/furnituretable002a.mdl", 100, 60 )
AddProp( "Coffee Table", "models/props_c17/furnituretable003a.mdl", 150, 80 )
AddProp( "Table", "models/props_wasteland/cafeteria_table001a.mdl", 150, 100 )
AddProp( "Bench", "models/props_wasteland/cafeteria_bench001a.mdl", 150, 50 )
AddProp( "Dresser", "models/props_interiors/furniture_cabinetdrawer01a.mdl", 300, 200 )
AddProp( "Dresser", "models/props_interiors/furniture_cabinetdrawer02a.mdl", 250, 200 )
AddProp( "Chair", "models/props_interiors/furniture_chair01a.mdl", 80, 100 )
AddProp( "Shelf", "models/props_interiors/furniture_shelf01a.mdl", 200, 250 )
AddProp( "Desk", "models/props_interiors/furniture_vanity01a.mdl", 300, 150 )
AddProp( "Desk", "models/props_interiors/furniture_desk01a.mdl", 150, 150 )
AddProp( "Chair", "models/props_wasteland/controlroom_chair001a.mdl", 50, 200, "smallmetal" )
AddProp( "Table", "models/props_wasteland/controlroom_desk001a.mdl", 120, 250, "metal" )
AddProp( "Table", "models/props_wasteland/controlroom_desk001b.mdl", 100, 250, "metal" )

// Random Junk
AddProp( "Pottery", "models/props_junk/terracotta01.mdl", 50, 20 )
AddProp( "Watermelon", "models/props_junk/watermelon01.mdl", 20, 20 )
AddProp( "Pumpkin", "models/props_outland/pumpkin01.mdl", 20, 40 )
AddProp( "Barricade", "models/props_wasteland/barricade001a.mdl", 60, 180 )
AddProp( "Barricade", "models/props_wasteland/barricade002a.mdl", 60, 180 )
AddProp( "Bust", "models/props_combine/breenbust.mdl", 150, 100 )
AddProp( "Vodka", "models/props_junk/garbage_glassbottle002a.mdl", 40, 10 )
AddProp( "Beer", "models/props_junk/garbage_glassbottle003a.mdl", 10, 10 )
AddProp( "Boat", "models/props_canal/boat001a.mdl", 80, 200 )
AddProp( "Boat", "models/props_canal/boat001b.mdl", 80, 200 )
AddProp( "Rowboat", "models/props_canal/boat002b.mdl", 100, 200 )
AddProp( "Recycling Bin", "models/props_junk/trashbin01a.mdl", 60, 200, "recycling" )
AddProp( "Toolbox", "models/props_lab/partsbin01.mdl", 30, 200, "smallmetal" )
AddProp( "File Cabinet", "models/props_wasteland/controlroom_filecabinet002a.mdl", 100, 400, "cabinet" )
AddProp( "File Cabinet", "models/props_wasteland/controlroom_filecabinet001a.mdl", 50, 400, "cabinet" )

// Barrels + canisters
AddProp( "Canister", "models/props_c17/canister01a.mdl", 50, 50 )
AddProp( "Canister", "models/props_c17/canister02a.mdl", 50, 50 )
AddProp( "Oil Drum", "models/props_c17/oildrum001.mdl", 80, 200, "oildrum" )

// Explosive
AddProp( "Oil Drum", "models/props_c17/oildrum001_explosive.mdl", 100, 100 )
AddProp( "Gas Tank", "models/props_junk/gascan001a.mdl", 80, 80 )

// AddProp( "PS3", "models/props_junk/ps3.mdl", -599, 200 ) 
