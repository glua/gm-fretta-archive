

function GM:PlayerStartVoice(ply)
	
	self.BaseClass:PlayerStartVoice(ply);
	
	ply.PiggyWiggle = true;
	
end

function GM:PlayerEndVoice(ply)
	
	self.BaseClass:PlayerEndVoice(ply);
	
	ply.PiggyWiggle = false;
	
end
