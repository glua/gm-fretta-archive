pickup = {}

pickup.PickupTypes = {}

pickup.PickupTypes[1] = { name="gmdm_smg", 
					nicename="SMG",
					model="models/weapons/w_smg1.mdl",
					ammogive="SMG1",
					ammoamount="128" }
					
pickup.PickupTypes[2] = { name="gmdm_flamethrower", 
					nicename="Flamethrower",
					model="models/weapons/w_smg1.mdl",
					ammogive="SMG1",
					ammoamount="25" }
					
pickup.PickupTypes[3] = { name="gmdm_tripmine", 
					nicename="Tripmine",
					model="models/weapons/w_slam.mdl",
					customammo="TripMines",
					ammoamount=3 }

pickup.PickupTypes[4] = { name="gmdm_shotgun", 
					nicename="Shotgun",
					model="models/weapons/w_shotgun.mdl",
					ammogive="buckshot",
					ammoamount=32 }
					
pickup.PickupTypes[5] = { name="gmdm_egon", 
					nicename="Egon Cannon",
					model="models/weapons/w_physics.mdl",
					customammo="egonenergy",
					ammoamount=50 }
					
pickup.PickupTypes[6] = { name="gmdm_rail", 
					nicename="Railgun",
					model="models/weapons/w_IRifle.mdl", //ar2?
					customammo="Rails",
					ammoamount=16 }
					
pickup.PickupTypes[7] = { name="gmdm_crossbow", 
					nicename="Crossbow",
					model="models/weapons/w_crossbow.mdl",
					customammo="Bolts",
					ammoamount=10 }
					
pickup.PickupTypes[8] = { name="gmdm_electricity_nades", 
					nicename="Electricity Grenade",
					model="models/weapons/w_grenade.mdl",
					customammo="ElectricityGrenades",
					ammoamount=1 }
					
pickup.PickupTypes[9] = { 	name="gmdm_pistol",
					nicename = "Pistol",
					model = "models/weapons/w_pistol.mdl",
					ammogive="pistol",
					ammoamount = 30
				}
				
pickup.PickupTypes[10] = {	name = "gmdm_rpg",
					nicename = "RPG",
					model = "models/weapons/w_rocket_launcher.mdl",
					customammo = "RPGs",
					ammoamount = 2
				}
				
function pickup:Register( addtbl )
	Msg( "Registered " .. addtbl.name .. " to pickups list.\n" );
	table.insert( self.PickupTypes, addtbl );
end

function pickup:SimpleAdd( weapclass, printname, model, ammotype, ammoamount, iscustomammo )

	for k, v in pairs( self.PickupTypes ) do
		if( v.name == weapclass ) then
			return
		end
	end
	
	if( iscustomammo == nil ) then
		iscustomammo = false;
	end
	
	local newwtype = {};
	newwtype.name = weapclass;
	newwtype.nicename = printname;
	newwtype.model = model;
	
	if( iscustomammo == true ) then
		newwtype.customammo = ammotype;
	else
		newwtype.ammogive = ammotype;
	end
	
	newwtype.ammoamount = ammoamount;
	
	self:Register( newwtype );
end

function pickup:GetAll()
	return self.PickupTypes;
end

function pickup:GetPickupByIndex( i )
	return self.PickupTypes[i];
end

function pickup:GetPickupByName( name )
	for k,v in pairs( self.PickupTypes ) do
		if( name == v.name ) then
			return k, v;
		end
	end
	
	return;
end
