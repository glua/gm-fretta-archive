ENT.Type = "point"

OUTPUTLIST = { "OnStartWarmup", "OnStartRound", "OnEndRound","OnBlueWins", "OnRedWins" } //Define all the possible outputs

function ENT:KeyValue(key, value)
	for i=1,#OUTPUTLIST do //For all the outputs
		if (key == OUTPUTLIST[i]) then //We found the key!
			self:StoreOutput(key, value) //Store it
		end
	end
end

function ENT:SendStartWarmup() self:TriggerOutput( "OnStartWarmup") end
function ENT:SendStartRound() self:TriggerOutput( "OnStartRound") end
function ENT:SendEndRound() self:TriggerOutput( "OnEndRound") end
function ENT:SendBlueWins() self:TriggerOutput( "OnBlueWins") end
function ENT:SendRedWins() self:TriggerOutput( "OnRedWins") end
