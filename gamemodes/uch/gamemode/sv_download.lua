
local function AddFolder(path)
	for k, v in pairs(file.Find("../" .. path .. "*")) do
		resource.AddFile(path .. v);
	end
end


AddFolder("sound/UCH/music/");
AddFolder("sound/UCH/music/cues/");
AddFolder("sound/UCH/music/voting/");
AddFolder("sound/UCH/custom/");
AddFolder("sound/UCH/chimera/");
AddFolder("sound/UCH/pigs/");

AddFolder("materials/UCH/");
AddFolder("materials/UCH/logo/");
AddFolder("materials/UCH/scoreboard/");
AddFolder("materials/UCH/ranks/");
AddFolder("materials/UCH/killicons/");
AddFolder("materials/UCH/hud/");

AddFolder("materials/models/uch/uchimera/");
AddFolder("materials/models/uch/pigmask/");
AddFolder("materials/models/uch/mghost/");
AddFolder("materials/models/uch/birdgib/");

for k, v in pairs(file.Find("../models/uch/*.mdl")) do
	resource.AddFile("models/uch/" .. v);
end

resource.AddFile("materials/models/uch/flat.vtf");
resource.AddFile("materials/models/uch/flat.vmt");

resource.AddFile("materials/models/uch/flat2.vtf");
resource.AddFile("materials/models/uch/flat2.vmt");


resource.AddFile("resource/fonts/apple_kid.TTF");
resource.AddFile("resource/fonts/twoson.TTF");

resource.AddFile("scripts/sounds/bit.bite.txt");
resource.AddFile("scripts/sounds/gril.growl.txt");
resource.AddFile("scripts/sounds/riar.roar.txt");
resource.AddFile("scripts/sounds/stip.stomp.txt");
