function HnsBuy(ply, cmd, args)
	--ply:AddFrags(100)
	local num = tonumber(args[1])
	if not ShopTable[num] then return end
	local plytable = ply.Loadout or {}
	if table.HasValue(plytable, num) then
		ply:ChatPrint("You already bought this")
		return
	end
	if ply:Frags() < ShopTable[num][5] then
		ply:ChatPrint("You don't have enough frags")
		return
	end
	if ShopTable[num][7] then
		if ShopTable[num][8] == "invis" then
			InvisRestore(ply)
		end
	else
	table.insert(plytable, num)
	ply.Loadout = plytable
	ply:Give(ShopTable[num][3])
	end
	ply:ChatPrint("You are successfully bought this")
	ply:AddFrags(ShopTable[num][5]*-1)
	//if ply:AddGPoints then
	//	ply:AddGPoints(ShopTable[num][5]) //Adding ga points for purchase
	//end
end
concommand.Add("hns_buy", HnsBuy)