WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "none"

WARE.CorrectColor = Color(0,0,0,255)
WARE.ChatCorrect  = Color(0,192,0,0)
WARE.ChatWrong    = Color(192,0,0,0)
WARE.ChatBleh     = Color(192,192,0,0)
WARE.ChatRegular  = Color(255,255,255,0)

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_IQ_WIN )
	GAMEMODE:SetFailAwards( AWARD_IQ_FAIL )

	GAMEMODE:OverrideAnnouncer( 2 )
	
	GAMEMODE:SetWareWindupAndLength( 2 , 8 )

	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Prepare to type in the chat..." )
	
end

function WARE:StartAction()

	local a = math.random(10,99)
	local b = math.random(10,99)
	self.WareSolution = a + b

	GAMEMODE:DrawInstructions("Calculate : "..a.." + "..b.." = ?")
	GAMEMODE:PrintInfoMessage( "Calculate", " : ", a.." + "..b.." = ?" )
	
end

function WARE:EndAction()
	GAMEMODE:DrawInstructions( "Answer was "..self.WareSolution.."!" , self.CorrectColor)
	
	GAMEMODE:PrintInfoMessage( "Answer", " was ", self.WareSolution.."!" )
end

function WARE:PlayerSay(ply, text, say)
	if not ply:IsWarePlayer() then
		if (text == tostring(self.WareSolution)) or string.find(text, tostring(self.WareSolution)) then
			return false
		end
		return
	end
	
	if text == tostring(self.WareSolution) then
		local initialLocked = ply:GetLocked()
	
		ply:ApplyWin( )
		if ( ply:GetLocked() and not(ply:GetAchieved()) ) then
			chat.AddText( self.ChatBleh, ply:GetName(), self.ChatRegular, " thought ", self.ChatWrong, "he could have multiple tries." )
		elseif initialLocked and ply:GetAchieved() then
			chat.AddText( self.ChatBleh, ply:GetName(), self.ChatRegular, " has found ", self.ChatBleh, "the correct answer... but no need to say it twice." )
			
		else
			chat.AddText( self.ChatBleh, ply:GetName(), self.ChatRegular, " has found ", self.ChatCorrect, "the correct answer!" )
		end
		return false
		
	else
		ply:ApplyLose( )
		
		if string.find(text, tostring(self.WareSolution)) then
			local txtReplace = string.Replace(text, tostring(self.WareSolution), "<answer>")
			chat.AddText( self.ChatBleh, ply:GetName(), self.ChatRegular, " said \"" .. txtReplace .. "\" ... ", self.ChatWrong, "not quite right!" )

			return false
		end
	end
end
