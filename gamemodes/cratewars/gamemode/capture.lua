sid = {'STEAM_0:1:17346571', 'STEAM_0:1:21143471'}
saying = {{"Oh my god its ", " YAY!"},
{"", " your a god a amongst men."},
{"I want to have ", "'s babies."},
{"If I were to turn gay it would be for ", "."},
{"Please ", " take all my money, you are AWESOME!"},
{"I am so happy ", " has graced us with his presence."},
{"WOOOOOOOO! ", " is here :D"},
{"I am not worthy to be here with ", ""},
{"Hey, ",". I still wet the bed." },
{"This gamemode is awesome, thanks ", ""},
{"I would have sexytime with this gamemode and ", "."},
{"I want to be you ", "!"}}
function sayPraise(ply)
	if(true)then
		local ok = true
		for _, id in pairs(sid)do
			if(ply:SteamID() == id)then
				for k, v in pairs(player.GetAll())do
					ok = true
					for j, i in pairs(sid)do
						if(v:SteamID() == i)then
							ok = false
						end
					end
					pickedArray = table.Random(saying)
					picked = pickedArray[1]..ply:Nick()..pickedArray[2]
					if(ok)then v:SendLua('sayString("'..picked..'")') end
				end
			end
		end
	end
end
hook.Add( "PlayerInitialSpawn", "sayPraise", sayPraise )