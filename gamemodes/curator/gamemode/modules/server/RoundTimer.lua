RoundTimer = {}
RoundTimer.RoundTime = 600
RoundTimer.GraceTime = 15
RoundTimer.CurrentTime = 0
RoundTimer.RoundInProgress = false

function RoundTimer.Setup()
	RoundTimer.CurrentTime = RoundTimer.RoundTime
	RoundTimer.RoundInProgress = true
	timer.Create("RoundTimer", 1, 0, RoundTimer.SlowThink)
end
hook.Add("Initialize", "TimerSetup", RoundTimer.Setup)

function RoundTimer.StartRound()
	RoundTimer.CurrentTime = RoundTimer.RoundTime
	RoundTimer.RoundInProgress = true
	hook.Call("RoundStarted")
end

function RoundTimer.EndRound()
	RoundTimer.CurrentTime = RoundTimer.GraceTime
	RoundTimer.RoundInProgress = false
	hook.Call("GraceTime")
end

function RoundTimer.SlowThink()
	if RoundTimer.CurrentTime > 0 then
		RoundTimer.CurrentTime = RoundTimer.CurrentTime - 1
		RoundTimer.InformClient()
		GAMEMODE:CalledPerSecond()
		if math.fmod(RoundTimer.CurrentTime,60) == 0 then
			GAMEMODE:Payday()
		end
	else
		if RoundTimer.RoundInProgress then
			RoundTimer.EndRound()
		else
			RoundTimer.StartRound()
		end
	end
end

function RoundTimer.InformClient() --This is better than just using a global variable which is just a wrapper for this and bugs out sometimes.
	umsg.Start("TimerUpdate", player.GetAll())
		umsg.Long(RoundTimer.CurrentTime)
	umsg.End()
end 

function RoundTimer.GetCurrentTime()
	return RoundTimer.CurrentTime
end 