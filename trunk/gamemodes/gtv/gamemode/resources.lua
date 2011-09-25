CreateConVar("sv_gtv_sendresources",1,FCVAR_ARCHIVE)

if GetConVarNumber("sv_gtv_sendresources") == 1 then
	resource.AddFile("particles/gtv.pcf")
	for k,v in pairs(file.Find("../gamemodes/gtv/content/materials/gtv/*")) do
		resource.AddFile("gamemodes/gtv/content/materials/gtv/*"..v)
	end
	for k,v in pairs(file.Find("../gamemodes/gtv/content/materials/gtv/banners/*")) do
		resource.AddFile("gamemodes/gtv/content/materials/gtv/banners/*"..v)
	end
	for k,v in pairs(file.Find("../gamemodes/gtv/content/materials/gtv/weapons/*")) do
		resource.AddFile("gamemodes/gtv/content/materials/gtv/weapons/*"..v)
	end
	resource.AddFile("gamemodes/gtv/content/materials/playercircle2.vmt")
	resource.AddFile("gamemodes/gtv/content/materials/playercircle2.vtf")
	resource.AddFile("gamemodes/gtv/content/materials/vgui/gtv.vmt")
	resource.AddFile("gamemodes/gtv/content/materials/vgui/gtv.vtf")
	resource.AddFile("gamemodes/gtv/content/materials/halflife/grate.vmt")
	resource.AddFile("gamemodes/gtv/content/sound/gtv/relief4.wav")
	
	resource.AddFile("materials/maps/gtv_duel.vmt")
	resource.AddFile("materials/maps/gtv_duel.vtf")
	
	resource.AddFile("materials/maps/gtv_hotshot.vmt")
	resource.AddFile("materials/maps/gtv_hotshot.vtf")
	
	resource.AddFile("materials/maps/gtv_neon.vmt")
	resource.AddFile("materials/maps/gtv_neon.vtf")
	
	resource.AddFile("materials/maps/gtv_simp_thegrid.vmt")
	resource.AddFile("materials/maps/gtv_simp_thegrid.vtf")
	
	resource.AddFile("materials/maps/gtv_simp_circle.vmt")
	resource.AddFile("materials/maps/gtv_simp_circle.vtf")
	resource.AddFile("wat")
end