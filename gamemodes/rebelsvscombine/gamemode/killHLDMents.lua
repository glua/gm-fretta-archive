function KillHLDM()
    for k,v in pairs(ents.FindByClass("weapon_*")) do
        v:Fire("kill",0,0)
    end
	for k,v in pairs(ents.FindByClass("item_*")) do
        v:Fire("kill",0,0)
    end
end
