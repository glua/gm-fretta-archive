RoundTimer = {}
RoundTimer.RoundTime = 600
RoundTimer.GraceTime = 15
RoundTimer.CurrentTime = 0

function RoundTimer.TimerUpdate(msg)
    RoundTimer.CurrentTime = msg:ReadLong()
end
usermessage.Hook("TimerUpdate", RoundTimer.TimerUpdate)

function RoundTimer.GetCurrentTime()
	return RoundTimer.CurrentTime
end 