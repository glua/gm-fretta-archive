
function GM:CacheStuff()

	for k, v in pairs(file.Find("../uch/UchimeraGM.*")) do
		util.PrecacheModel("uch/" .. v);
	end

	for k, v in pairs(file.Find("../models/uch/birdgib.*")) do
		util.PrecacheModel("uch/" .. v);
	end

	for k, v in pairs(file.Find("../models/uch/pigmask.*")) do
		util.PrecacheModel("uch/" .. v);
	end

	
	for k, v in pairs(file.Find("../sound/UCH/music/*")) do
		util.PrecacheSound("UCH/music/" .. v);
	end

	for k, v in pairs(file.Find("../sound/UCH/music/cues/*")) do
		util.PrecacheSound("UCH/music/cues/" .. v);
	end

	for k, v in pairs(file.Find("../sound/UCH/music/voting/*")) do
		util.PrecacheSound("UCH/music/voting/" .. v);
	end

	for k, v in pairs(file.Find("../sound/UCH/custom/*")) do
		util.PrecacheSound("UCH/custom/" .. v);
	end

	for k, v in pairs(file.Find("../sound/UCH/chimera/*")) do
		util.PrecacheSound("UCH/chimera/" .. v);
	end

	for k, v in pairs(file.Find("../sound/UCH/pigs/*")) do
		util.PrecacheSound("UCH/pigs/" .. v);
	end

end
