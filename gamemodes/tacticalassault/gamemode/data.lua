DB = {}

function DB.Init()
	if not file.Exists("ta_data.txt") then file.Write("ta_data.txt",glon.encode({})) end
	DB.Main = glon.decode(file.Read("ta_data.txt"))
end

function DB.Save()
	file.Write("ta_data.txt",glon.encode(DB.Main))
end

function DB.GetPoints(pl)
	for k,v in pairs(DB.Main) do
		if k == pl:SteamID() and v.Points then return v.Points end
	end
	return 0
end

function DB.GetPlays(pl)
	for k,v in pairs(DB.Main) do
		if k == pl:SteamID() and v.Plays then return v.Plays end
	end
	return 0
end

function DB.AddPlay(pl)
	for k,v in pairs(DB.Main) do
		if k == pl:SteamID() then v.Plays = v.Plays + 1 end
	end
end

function DB.SetPoints(pl,pts)
	for k,v in pairs(DB.Main) do
		if k == pl:SteamID() then v.Points = pts return end
	end
	DB.Main[pl:SteamID()] = {Points = pts, Plays = 0}
end

DB.Init()