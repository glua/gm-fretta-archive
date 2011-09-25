//This file handles hints!
	
	//Here's what we're doing here
	//We first replace all line breaks with spaces.
	//Then we check total length
	//If it's too long, we explode the string with spaces
	//For each part of our string, we check the character count and add on each part until it's "too long"
	//Then we add a line break for each line that's too long.
	//That makes up our new string.
	//Then we explode by line breaks and send each of those over a user message seperately.

//This simply sends a hint
function GM:SendCactusHint(ply,str_Hint,typ,dieTime)
	
	ply.isHinting = ply:GetNWBool("isHinting") or false
	
	//Set up hint message string
	local hintMessage = string.gsub(str_Hint, "\n", " ")
	local msg = ""
	local chars = 0
	local counter = 1
	local maxlength = 65
	
	if string.len(hintMessage) > maxlength then --check if hint is too long for word bubble
		local splitter = string.Explode(" ", hintMessage) --explode string
		chars = string.len(splitter[1])
		for k,v in pairs(splitter) do --for each part
			if chars < maxlength then --check if string plus next installment is too long
				msg = msg.." "..v --add it back on
				chars = string.len(string.Explode("\n", msg)[counter]) or string.len(msg)
			else
				msg = msg.."\n" --separate with a line break
				chars = 0
				counter = counter+1
			end
		end
		print(msg)
		msg = string.Explode("\n", msg)
	else
		msg = {}
		msg[1] = hintMessage
	end
	ply:SetNWBool("isHinting", true)
	
	//Hint umsg
	umsg.Start("cactusHint", ply)
		umsg.Bool(true)
		umsg.Float(counter)
		for i=1,counter do
			umsg.String(msg[i])
		end
		umsg.String(typ)
	umsg.End()
	
	//Timer to hide it
	timer.Simple(dieTime,
		function()
			--if ply:GetNWBool("isHinting") then
			umsg.Start("cactusHint", ply)
				umsg.Bool(false)
			umsg.End()
			ply:SetNWBool("isHinting", false)
			--end
		end
	)

end

//This sends a notification action to cactus icon with the option of sending a hint as well
function GM:SendCactusNotification(ply,str_Hint,tbl_Style)
	
	//Table data
	ply.hType = tbl_Style.Type
	ply.hUrgent = tbl_Style.Urgency or 2
	ply.hData = tbl_Style.Data
	ply.hTime = tbl_Style.Time
	
	//Notification umsg
	umsg.Start("cactusIcon_"..string.upper(ply.hType), ply)
		umsg.Bool(true)
		umsg.Float(ply.hUrgent)
		if ply.hData then
			if ply.hData[1] then
				for i = 1, #ply.hData do
					if type(ply.hData[i]) == "number" then
						umsg.Float(ply.hData[i])
					elseif type(ply.hData[i]) == "string" then
						umsg.String(ply.hData[i])
					elseif type(ply.hData[i]) == "boolean" then
						umsg.Bool(ply.hData[i])
					end
				end
			else
				if type(ply.hData) == "number" then
					umsg.Float(ply.hData)
				elseif type(ply.hData) == "string" then
					umsg.String(ply.hData)
				elseif type(ply.hData) == "boolean" then
					umsg.Bool(ply.hData)
				end
			end
		end
	umsg.End()
	
	timer.Simple(ply.hTime.Notify,
		function()
			umsg.Start("cactusIcon_"..string.upper(ply.hType), ply)
				umsg.Bool(false)
			umsg.End()
		end
	)
	
	if str_Hint != nil then
		ply.hTime.Hint = ply.hTime.Hint or 5
		GAMEMODE:SendCactusHint(ply,str_Hint,ply.hType,ply.hTime.Hint)
	end

end
/*
function GM:SendHints()
	
	local hHumans = table.Random(Cactus.Hints.Humans.Generic)
	local hCacti = table.Random(Cactus.Hints.Cacti.Generic)
	
	local genericTable = {} --Hint table
	
	genericTable.Humans = {}
	genericTable.Humans["Type"] = "wiggle" --Type of notification for cactus icon to use
	genericTable.Humans["Urgency"] = 4 --How fast it wiggles - Ranges 1-10: ten being the highest
	genericTable.Humans["Time"] = {}
	genericTable.Humans["Time"]["Notify"] = 1.5 --Time in seconds for notification to stop
	genericTable.Humans["Time"]["Hint"] = 5 --Time in seconds before the hint to goes away
	
	genericTable.Cacti = {}
	genericTable.Cacti["Type"] = "wiggle" --Type of notification for cactus icon to use
	genericTable.Cacti["Urgency"] = 4 --How fast it wiggles - Ranges 1-10: ten being the highest
	genericTable.Cacti["Time"] = {}
	genericTable.Cacti["Time"]["Notify"] = 1.5 --Time in seconds for notification to stop
	genericTable.Cacti["Time"]["Hint"] = 5 --Time in seconds before the hint to goes away
	
	
	genericTable["Type"] = "wiggle" --Type of notification for cactus icon to use
	genericTable["Urgency"] = 4 --How fast it wiggles - Ranges 1-10: ten being the highest
	genericTable["Time"] = {}
	genericTable["Time"]["Notify"] = 1.5 --Time in seconds for notification to stop
	genericTable["Time"]["Hint"] = 5 --Time in seconds before the hint to goes away
	
	for k,v in pairs(player.GetAll()) do
		
		if v:IsHuman() then
			
			GAMEMODE:SendCactusHint(v,hHumans,"generic",genericTable)
			
		elseif v:IsCactus() then
			
			GAMEMODE:SendCactusHint(v,hCacti,"generic",genericTable)
			
		end
		
	end
	
end
*/









//////////////////////////////////////////////










function CactusSendHint(ply,cmd,args)
	local hint = args[1] or table.Random(Cactus.Hints.Humans.Generic)
	local dietime = args[2] or 5
	GAMEMODE:SendCactusHint(ply,hint)
end
concommand.Add("hint_test",CactusSendHint)

//Example
function wiggleHint(ply,cmd,args)
	local hint = {} --Hint table
	hint["Type"] = "wiggle" --Type of notification for cactus icon to use
	hint["Urgency"] = 1 --How fast it wiggles - Ranges 1-10: ten being the highest
	hint["Time"] = {}
	hint["Time"]["Notify"] = 1 --Time in seconds for notification to stop
	hint["Time"]["Hint"] = 4 --Time in seconds before the hint to goes away
	
	GAMEMODE:SendCactusNotification(ply,table.Random(Cactus.Hints.Humans.Generic),hint)
end
concommand.Add("wiggletest",wiggleHint)

function caughtHint(ply,cmd,args)
	local hint = {} --Hint table
	hint["Type"] = "caught" --Type of notification for cactus icon to use
	hint["Data"] = {} --Data table that contains info to send via usermessage
	hint["Data"][1] = "Normal" --Caught type
	hint["Data"][2] = Color(30,200,30,255) --Caught color
	hint["Data"][3] = nil --String name of another draw over function (just in case you caught an explosive cactus and wanna draw a fuse on it)
	hint["Time"] = {}
	hint["Time"]["Notify"] = 1 --Time in seconds for notification to stop
	hint["Time"]["Hint"] = 4 --Time in seconds before the hint to goes away
	
	GAMEMODE:SendCactusNotification(ply,"This is another hint!",hint)
end
concommand.Add("caughttest",caughtHint)