local meta = FindMetaTable("Player")
if !meta then return end

//////////////////////////////////////////////
// SQUADS
	function meta:SetSquad(squad)
		self._Squad = squad
	end

	function meta:GetSquad() 
		return self._Squad or false
	end

	function meta:SetLeader()
		self._Lead = true
	end

	function meta:RemoveLeader()
		self._Lead = false
	end

	function meta:IsLeader()
		return self._Lead or false
	end

//////////////////////////////////////////////
// DISPENSERS
	function meta:SetDispenser( ent )
		self._Dispenser = ent
	end
	
	function meta:SetDispenserTime( n )
		self._DispenserCreate = n
	end

	function meta:GetDispenser()
		return self._Dispenser or nil
	end

	function meta:GetDispenserTime()
		return self._DispenserCreate or 0
	end