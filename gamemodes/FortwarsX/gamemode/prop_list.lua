
function GeneratePropList()
	PropList = {} //Allowed props go here
	PropList[1] = {} //A table with tables in it? BLASPHEMY!
	PropList[1][1] = "models/props_junk/wood_crate001a.mdl" //First index indicates prop name
	PropList[1][2] = 5100 //Second index is it's health. I really should be getting the health values on the fly instead of hard-coded stuff, but it seems that that isn't possible.
	PropList[2] = {} 
	PropList[2][1] = "models/props_junk/wood_crate002a.mdl"
	PropList[2][2] = 8600
	PropList[3] = {} 
	PropList[3][1] = "models/props_c17/fence02b.mdl"
	PropList[3][2] = 3600
	PropList[4] = {} 
	PropList[4][1] = "models/props_c17/handrail04_medium.mdl"
	PropList[4][2] = 900
	PropList[5] = {} 
	PropList[5][1] = "models/props_trainstation/handrail_64decoration001a.mdl" 
	PropList[5][2] = 1000
	PropList[6] = {} 
	PropList[6][1] = "models/props_c17/playgroundtick-tack-toe_post01.mdl"
	PropList[6][2] = 3800
	PropList[7] = {} 
	PropList[7][1] = "models/props_lab/blastdoor001a.mdl"
	PropList[7][2] = 7600
	PropList[8] = {} 
	PropList[8][1] = "models/props_lab/blastdoor001c.mdl"
	PropList[8][2] = 14800
	PropList[9] = {} 
	PropList[9][1] = "models/props_junk/trashdumpster01a.mdl"
	PropList[9][2] = 30500
	PropList[10] = {} 
	PropList[10][1] = "models/props_c17/concrete_barrier001a.mdl"
	PropList[10][2] = 11800
	PropList[11] = {} 
	PropList[11][1] = "models/props_wasteland/controlroom_storagecloset001b.mdl"
	PropList[11][2] = 27800
	PropList[12] = {} 
	PropList[12][1] = "models/props_wasteland/controlroom_filecabinet002a.mdl"
	PropList[12][2] = 9900
	PropList[13] = {} 
	PropList[13][1] = "models/props_wasteland/kitchen_counter001c.mdl"
	PropList[13][2] = 13500
	PropList[14] = {} 
	PropList[14][1] = "models/props_wasteland/kitchen_fridge001a.mdl"
	PropList[14][2] = 26700
	PropList[15] = {} 
	PropList[15][1] = "models/props_wasteland/laundry_dryer002.mdl"
	PropList[15][2] = 29200
	PropList[16] = {} 
	PropList[16][1] = "models/props_wasteland/prison_gate001b.mdl"
	PropList[16][2] = 10000
	PropList[17] = {} 
	PropList[17][1] = "models/props_wasteland/prison_gate001c.mdl"
	PropList[17][2] = 6600
	PropList[18] = {} 
	PropList[18][1] = "models/props_wasteland/prison_heavydoor001a.mdl"
	PropList[18][2] = 19300
	PropList[19] = {} 
	PropList[19][1] = "models/props_combine/combine_barricade_med01a.mdl"
	PropList[19][2] = 11300
	PropList[20] = {} 
	PropList[20][1] = "models/props_combine/combine_barricade_med01b.mdl"
	PropList[20][2] = 16100
	PropList[21] = {} 
	PropList[21][1] = "models/props_combine/combine_barricade_med02a.mdl"
	PropList[21][2] = 31000
	PropList[22] = {} 
	PropList[22][1] = "models/props_combine/combine_barricade_med02b.mdl"
	PropList[22][2] = 38700
	PropList[23] = {} 
	PropList[23][1] = "models/props_borealis/borealis_door001a.mdl"
	PropList[23][2] = 3100
	PropList[24] = {} 
	PropList[24][1] = "models/props_borealis/mooring_cleat01.mdl"
	PropList[24][2] = 4000
	PropList[25] = {} 
	PropList[25][1] = "models/props_debris/metal_panel01a.mdl"
	PropList[25][2] = 4100
	PropList[26] = {} 
	PropList[26][1] = "models/props_debris/metal_panel02a.mdl"
	PropList[26][2] = 5500
	PropList[27] = {} 
	PropList[27][1] = "models/props_c17/door01_left.mdl"
	PropList[27][2] = 2800
	PropList[28] = {} 
	PropList[28][1] = "models/props_docks/channelmarker01a.mdl"
	PropList[28][2] = 3400
	PropList[29] = {} 
	PropList[29][1] = "models/props_trainstation/traincar_seats001.mdl" 
	PropList[29][2] = 9300
	PropList[30] = {} 
	PropList[30][1] = "models/props_c17/lockers001a.mdl"
	PropList[30][2] = 11100
	
	for i = 1, #PropList do
		util.PrecacheModel( PropList[i][1] ) //Precache all the models
	end
	
	return PropList
	
end

function TranslateMDL( mdl ) //Generate a name which is a bit more nicer to the eye than something like models/props_trainstation/handrail_64decoration001a.mdl
	if ( mdl == PropList[1][1] ) then // Was an extreme shitload of work 
		return "Wooden Crate"
	elseif ( mdl == PropList[2][1] ) then
		return "Big Wooden Crate"
	elseif ( mdl == PropList[3][1] ) then
		return "Fence"
	elseif ( mdl == PropList[4][1] ) then
		return "Your Average Railing"
	elseif ( mdl == PropList[5][1] ) then
		return "Fancy Railing"
	elseif ( mdl == PropList[6][1] ) then
		return "Tic-Tac-Toe Post"
	elseif ( mdl == PropList[7][1] ) then
		return "Blastdoor"
	elseif ( mdl == PropList[8][1] ) then
		return "Big Blastdoor"
	elseif ( mdl == PropList[9][1] ) then
		return "Trash Dumpster"
	elseif ( mdl == PropList[10][1] ) then
		return "Concrete Barrier"
	elseif ( mdl == PropList[11][1] ) then
		return "Storage Closet"
	elseif ( mdl == PropList[12][1] ) then
		return "File Cabinet"
	elseif ( mdl == PropList[13][1] ) then
		return "Kitchen Counter"
	elseif ( mdl == PropList[14][1] ) then
		return "Huge Fridge"
	elseif ( mdl == PropList[15][1] ) then
		return "Huge Laundry Dryer"
	elseif ( mdl == PropList[16][1] ) then
		return "Prison Gate"
	elseif ( mdl == PropList[17][1] ) then
		return "Prison Gate with hole"
	elseif ( mdl == PropList[18][1] ) then
		return "Heavy Steel Door"
	elseif ( mdl == PropList[19][1] ) then
		return "Small Combine Barricade"
	elseif ( mdl == PropList[20][1] ) then
		return "Small Combine Barricade 2"
	elseif ( mdl == PropList[21][1] ) then
		return "Large Combine Barricade"
	elseif ( mdl == PropList[22][1] ) then
		return "Large Combine Barricade 2"
	elseif ( mdl == PropList[23][1] ) then
		return "Ship Door"
	elseif ( mdl == PropList[24][1] ) then
		return "Mooring Cleat"
	elseif ( mdl == PropList[25][1] ) then
		return "Long Metal Panel"
	elseif ( mdl == PropList[26][1] ) then
		return "Metal Panel"
	elseif ( mdl == PropList[27][1] ) then
		return "Wooden Door"
	elseif ( mdl == PropList[28][1] ) then
		return "Signal Pole"
	elseif ( mdl == PropList[29][1] ) then
		return "Train Seats"
	elseif ( mdl == PropList[30][1] ) then
		return "Metal Lockers"
	else
		return "Prop" //If something went wrong, return Prop. Shouldn't happen really.
	end
end
