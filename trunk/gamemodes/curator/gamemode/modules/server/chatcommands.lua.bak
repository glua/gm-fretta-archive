
/*---------------------------------------------------------
  ChatCommand system
---------------------------------------------------------*/

local ChatCommands = {}
local AllCmds = {}

function RegisterChatCmd(cmd,tbl)
         ChatCommands[cmd] = tbl
		 print("ChatCmds Registered!")
		 table.insert(AllCmds,cmd)
end

function RunChatCmd(ply,...)
	if #arg > 0 and ChatCommands[string.lower(arg[1])] != nil then 
		local cmd = string.lower(arg[1])
		table.remove(arg,1)
		ChatCommands[cmd]:Run( ply, unpack(arg) )
		return ""
	end
end

function CheckForChatCmd(ply,text,all)
	local text2 = string.Explode(" ", text)
	RunChatCmd( ply, unpack(text2) )
end

hook.Add( "PlayerSay", "CuratorSayHook", CheckForChatCmd )

/*---------------------------------------------------------
  Help
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "!help"
CHATCMD.Desc = "- lists chat cmds"
function CHATCMD:Run( ply, ... )
	if arg[1] and ChatCommands[arg[1]] then
		ply:PrintMessage( HUD_PRINTTALK, arg[1]..":\n Usage: "..(ChatCommands[arg[1]].Usage or "No arguments").."\n Description: "..(ChatCommands[arg[1]].Desc or "No Description") )
	else
		ply:PrintMessage( HUD_PRINTTALK, "Chat Commands: "..table.concat(AllCmds, ", ") )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
  bug
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "!submitbug"
CHATCMD.Desc = "- Submit a bug to the server"
CHATCMD.Usage = "(description of bug)"
function CHATCMD:Run( ply, ... )
	if arg[1] then
		local text = table.concat(arg," ")
		text = os.date().." - "..text
		if not file.Exists("CuratorBugs\\"..ply:Nick()..".txt") then
			file.Write("CuratorBugs\\"..ply:Nick()..".txt",text)
		else
			text = text.."\n\n-------------------------------------------------------------------------------\n\n"..file.Read("CuratorBugs\\"..ply:Nick()..".txt")
			file.Write("CuratorBugs\\"..ply:Nick()..".txt",text)
		end
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
  bug
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "!sb"
CHATCMD.Desc = "- Submit a bug to the server"
CHATCMD.Usage = "(description of bug)"
function CHATCMD:Run( ply, ... )
	if arg[1] then
		local text = table.concat(arg," ")
		text = os.date().." - "..text
		if not file.Exists("CuratorBugs\\"..ply:Nick()..".txt") then
			file.Write("CuratorBugs\\"..ply:Nick()..".txt",text)
		else
			text = text.."\n\n-------------------------------------------------------------------------------\n\n"..file.Read("CuratorBugs\\"..ply:Nick()..".txt")
			file.Write("CuratorBugs\\"..ply:Nick()..".txt",text)
		end
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
  RunLua
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "!runlua"
CHATCMD.Desc = "- Runs Lua -Admin Only"
function CHATCMD:Run( ply, ... )
	local luaStr = table.concat( {...}, " " )
	if ply:IsAdmin() then
		local err = RunString( luaStr )
		if err then
			ply:ChatPrint("Running Lua has failed because of "..err)
		else
			ply:ChatPrint("Command run sucessfully!")
		end
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)



/*---------------------------------------------------------
vote kick
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "!votekick"
CHATCMD.Desc = "- Starts a vote to kick someone"
function CHATCMD:Run( ply, ... )
	local name = table.concat( {...}, " " )
	local found;
	for k,v in ipairs(player.GetAll()) do
		if string.find(string.lower(v:Nick()),string.lower(name)) then
			found = v
			break
		end
	end
	if not GAMEMODE.ActiveVoting and found then
		local OnPass = function() 
			if found and found:IsValid() then
				PrintMessage( HUD_PRINTTALK,"The vote to kick"..found:Nick().." has passed!")
				found:Kick("Votekicked.")
			end
		end
		local OnFail = function() 
			PrintMessage( HUD_PRINTTALK,"The vote to kick"..found:Nick().." has failed!")
		end
		GAMEMODE:SetupVote("Kicking "..found:Nick(), 30, (4/5), OnPass, OnFail) --Name, Duration, OnPass, OnFail
	elseif not found then
		ply:PrintMessage( HUD_PRINTTALK, "Player "..name.." could not be found.")
	else
		ply:PrintMessage( HUD_PRINTTALK, "A vote is already in progress!")
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
vote new round
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "!votenewround"
CHATCMD.Desc = "- Starts a vote start a new round"
function CHATCMD:Run( ply, ... )
	if not GAMEMODE.ActiveVoting then
		local OnPass = function() 
			PrintMessage( HUD_PRINTTALK,"The vote to start a new round has passed!")
			GAMEMODE.Curator = nil
		end
		local OnFail = function() 
			PrintMessage( HUD_PRINTTALK,"The vote to start a new round has failed!")
		end
		GAMEMODE:SetupVote("Starting a new round", 30, (1/3), OnPass, OnFail) --Name, Duration, OnPass, OnFail
	else
		ply:PrintMessage( HUD_PRINTTALK, "A vote is already in progress!")
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"Yes!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "yes"
CHATCMD.Desc = "- A yes vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your yes vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.Yes = GAMEMODE.CurrentVote.Yes + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"No!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "no"
CHATCMD.Desc = "- A no vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your no vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.No = GAMEMODE.CurrentVote.No + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"Yes!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "y"
CHATCMD.Desc = "- A yes vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your yes vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.Yes = GAMEMODE.CurrentVote.Yes + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"Yes!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "yeah"
CHATCMD.Desc = "- A yes vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your yes vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.Yes = GAMEMODE.CurrentVote.Yes + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"Yes!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "sure"
CHATCMD.Desc = "- A yes vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your yes vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.Yes = GAMEMODE.CurrentVote.Yes + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"Yes!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "yah"
CHATCMD.Desc = "- A yes vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your yes vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.Yes = GAMEMODE.CurrentVote.Yes + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"Yes!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "yar"
CHATCMD.Desc = "- A yes vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your yes vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.Yes = GAMEMODE.CurrentVote.Yes + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"No!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "n"
CHATCMD.Desc = "- A no vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your no vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.No = GAMEMODE.CurrentVote.No + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"No!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "nay"
CHATCMD.Desc = "- A no vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your no vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.No = GAMEMODE.CurrentVote.No + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
"No!"
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "never"
CHATCMD.Desc = "- A no vote."
function CHATCMD:Run( ply, ... )
	if ply.HasVoted then return end
	if GAMEMODE.ActiveVoting == true then
		ply:PrintMessage( HUD_PRINTTALK, "Your no vote has been recorded.")
		ply.HasVoted = true
		GAMEMODE.CurrentVote.No = GAMEMODE.CurrentVote.No + 1
		PrintMessage( HUD_PRINTTALK, "The Vote For "..GAMEMODE.CurrentVote.Name.." is now at "..GAMEMODE.CurrentVote.Yes.." with yes to "..GAMEMODE.CurrentVote.No.." with no." )
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
Gimmeh
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "gimmeh"
CHATCMD.Desc = "- A complex command for a friend"
function CHATCMD:Run( ply, ... )
	if string.find(string.lower(table.concat({...}," ")),"new round pl0x") then
		if not GAMEMODE.ActiveVoting then
			local OnPass = function() 
				PrintMessage( HUD_PRINTTALK,"The vote to start a new round has passed!")
				GAMEMODE.Curator = nil
			end
			local OnFail = function() 
				PrintMessage( HUD_PRINTTALK,"The vote to start a new round has failed!")
			end
			GAMEMODE:SetupVote("Starting a new round", 30, (1/3), OnPass, OnFail) --Name, Duration, OnPass, OnFail
		else
			ply:PrintMessage( HUD_PRINTTALK, "A vote is already in progress!")
		end
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)

/*---------------------------------------------------------
I
---------------------------------------------------------*/
local CHATCMD = {}

CHATCMD.Command = "I"
CHATCMD.Desc = "- A complex command for a friend"
function CHATCMD:Run( ply, ... )
	if string.find(string.lower(table.concat({...}," ")),"can has new round") then
		if not GAMEMODE.ActiveVoting then
			local OnPass = function() 
				PrintMessage( HUD_PRINTTALK,"The vote to start a new round has passed!")
				GAMEMODE.Curator = nil
			end
			local OnFail = function() 
				PrintMessage( HUD_PRINTTALK,"The vote to start a new round has failed!")
			end
			GAMEMODE:SetupVote("Starting a new round", 30, (1/3), OnPass, OnFail) --Name, Duration, OnPass, OnFail
		else
			ply:PrintMessage( HUD_PRINTTALK, "A vote is already in progress!")
		end
	end
end
RegisterChatCmd(CHATCMD.Command,CHATCMD)