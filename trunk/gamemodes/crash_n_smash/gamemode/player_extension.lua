
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:OnSpawn()

	if self:GetPowerup() == "none" then
		self:SetWalkSpeed( 300 )
		self:SetRunSpeed( 300 )
		self:SetCrouchedWalkSpeed( 0.3 )
	end
	
	self:SetHealth( 100 )
	self:SetMaxHealth( 100 )

	self:AllowFlashlight( true )
	self:ShouldDropWeapon( false )
	self:SetNoCollideWithTeammates( true )
	self:SetAvoidPlayers( true )
end

function meta:OnLoadout()

	// Do not give weapons at round end
	if not GAMEMODE:InRound() and GetGlobalInt( "RoundResult", 0 ) > 0 then return end
	
	// Testing purposes
	if self:IsListenServerHost() then
		self:Give("weapon_physgun")
		self:Give("weapon_physcannon")
	end
	
	self:Give("weapon_crowbar")
	self:Give("weapon_playercannon")
	self:ForceSelectWeapon("weapon_playercannon")
end

function meta:OnPlayerModel()

	if self.ModelChoosen and table.HasValue(teaminfo[self:Team()].Models, self.ModelChoosen) then
		return
	end
	
	self.ModelChoosen = table.Random(teaminfo[self:Team()].Models)
	
	if (string.match(string.lower(self.ModelChoosen), "alyx")
		or string.match(string.lower(self.ModelChoosen), "mossman")) then
		
		self:SetNWString("gender","female")
	else
		self:SetNWString("gender","male")
	end
		
	self:SetModel( self.ModelChoosen )

end

function meta:UpdatePropCount()

	umsg.Start("update_propcount",self)
		umsg.Short(teaminfo[TEAM_RED].PropCount)
		umsg.Short(teaminfo[TEAM_RED].TotalPropValue)
		umsg.Short(teaminfo[TEAM_BLUE].PropCount)
		umsg.Short(teaminfo[TEAM_BLUE].TotalPropValue)
	umsg.End()
	
end

function meta:ForceSelectWeapon( weapon )

	self:SelectWeapon(weapon)
	umsg.Start("force_use", self)
		umsg.String(weapon)
	umsg.End()
	
end

function meta:RestorePlayer( pos )

	// Restore player after absorbing them with the player cannon
	self.HackySpawn = true
	self:Spectate(OBS_MODE_NONE)
	self:UnSpectate()
	self:Spawn()
	self:SetPos(pos)
	self:SetModel( self.ModelChoosen )
	self:OnSpawn()
	self:SetHealth( self.PrevHealth )
	
	self:SetNWBool("isabsorbed", false)
	self:SetNWEntity("absorber", Entity())
	
	for k, weapon in pairs( self.WeaponsStored ) do
		self:Give(weapon)
	end
	timer.Simple(2, function( ply ) ply:CheckPlayerLoadout() end, self)

end

function meta:DisallowTrajectoryBreaking()

	self:SetNWBool("tjbreakblock", true)

end

function meta:CanBreakTrajectory()

	return !self:GetNWBool("tjbreakblock")

end

function meta:ResetScores()

	self:SetFrags(0)
	self:SetDeaths(0)
	self.PropsBroken = 0
	self.PlayersLaunched = 0
	self.TotalFallDamage = 0
	self:SetPoints(0)
	self:SetAssistPoints(0)
	self.PropsBrokenChain = 0
	self.PropsBrokenChainRecord = 0
	
end

/*
	--- Player score chaining stuff ---
*/

// In order to gain assist points from a chain, players must launch others within CHAIN_TIME seconds
// Score multiplied by higher chains
/* Scenario:

* Fred fires Bob to other side
* Fred fires Ed to other side right after that
* Bob fires Ed higher up within 15 seconds after he himself was fired
* Ed breaks a prop of value 5
* Chain of 2 shots
* Ed gains 2 * 5 points
* Bob gains 2 * 5 assist points
* Fred gains 2 * 5 assist points

*/


if SERVER then

	CHAINS = {}
	// Amount of seconds allowed (between firing player and breaking a prop) before chain breaks
	CHAIN_TIME = 15

	function meta:AddScore( amount )
		
		local totalpoints
		
		if self:HasChain() then
		
			totalpoints = self:GetChainSize() * amount
			self:AddPoints(totalpoints)
			for k, pl in pairs(CHAINS[self].previous) do
				if ValidEntity(pl) then
					pl:AddAssistPoints(totalpoints)
				end
			end
			
		else
		
			totalpoints = amount
			self:AddPoints(totalpoints)
			
		end
		
	end

	function meta:SetPoints( amount )
		self:SetNWInt("points", amount)
	end

	function meta:SetAssistPoints( amount )
		self:SetNWInt("assistpoints", amount)
	end
	
	function meta:AddPoints( amount )
		self:SetPoints(self:GetPoints()+amount)
	end

	function meta:AddAssistPoints( amount )
		self:SetAssistPoints(self:GetAssistPoints()+amount)
	end

	function meta:Notify( str, type, length )
		umsg.Start("gamenotify",self)
			umsg.String( str )
			umsg.Short( type or 0 )
			umsg.Short( length or 5 )
		umsg.End()
	end

	function ChainsThink()
	
		local toremove = {}
	
		for pl, chain in pairs(CHAINS) do
			if ValidEntity(pl) and pl:HasChain() and !pl:ValidChain() then
				table.insert(toremove, pl)
			end
		end
	
		for k, pl in pairs(toremove) do
			pl:RemoveChain()
		end
	
	end
	
	function ClearChains()
		for k, pl in pairs(player.GetAll()) do
			pl:RemoveChain()
		end
		CHAINS = {}
	end
	
	// Player (meta) was launched by other player (pl)
	function meta:ChainPlayer( pl )
		
		if !ValidEntity(pl) then return end
		if (self:Team() != pl:Team()) then return end
		
		if self:HasChain() then
		
			// Prevent looping chains
			if table.HasValue(CHAINS[self].previous, pl) then 
				self:RemoveChain()
				timer.Simple(0.1,function( ply )
					if ValidEntity(self) and ValidEntity(ply) then
						self:ChainPlayer(ply)
					end
				end, pl)
				return
			end
			
			CHAINS[self].lastupdate = CurTime()
			CHAINS[self].size = CHAINS[self].size+1
			
			local endtime = CurTime() + CHAIN_TIME
			table.insert(CHAINS[self].previous, pl)
			for k, ply in pairs(CHAINS[self].previous) do
				ply:ChainUpdate(self, CHAINS[self].size, endtime)
			end
			self:ChainUpdate(self, CHAINS[self].size, endtime)
			
			// Check if the longest chain record is broken
			local longestchain = table.Count(scoreinfo.LongestChain.players)
			if longestchain < table.Count(CHAINS[self].previous) then
				local chaininvolved = CHAINS[self].previous
				table.insert(chaininvolved, self)
				scoreinfo.LongestChain.players = {}
				for k, pl in pairs(chaininvolved) do
					table.insert(scoreinfo.LongestChain.players, pl:Name())
				end
				scoreinfo.LongestChain.numplayers = table.Count(chaininvolved)
				scoreinfo.LongestChain.team = self:Team()
			end
			
		else
			CHAINS[self] = { team = self:Team(), lastupdate = CurTime(), size = 1, previous = { pl }}
			// ChainStarted( chain player, end time )
			local endtime = CurTime() + CHAIN_TIME
			self:ChainUpdate(self, 1, endtime)
			pl:ChainUpdate(self, 1, endtime)
		end
		
	end

	function meta:RemoveChain()

		if !self:HasChain() then return end
		local recipcients = CHAINS[self].previous
		table.insert(recipcients,self)
		
		umsg.Start("chainbroken", recipcients)
			umsg.Entity(self)
		umsg.End()
		
		CHAINS[self] = nil

	end
	
	function meta:GetChainSize()

		return CHAINS[self].size

	end

	function meta:HasChain()

		return CHAINS[self]

	end

	function meta:ValidChain()
		
		return CHAINS[self].lastupdate >= CurTime()-CHAIN_TIME
		
	end
	
	function meta:ChainUpdate( pl, size, endtime )
		umsg.Start("chainupdate", self)
			umsg.Entity(pl)
			umsg.Short(size)
			umsg.Float(endtime)
		umsg.End()
	end
	
end

if CLIENT then
	CL_CHAINS = {}

	// Clients only need to store chains they're involved in
	function meta:UpdateChain(chainsize, chainendtime)
		//print("Player "..self:Name().."'s score chain updated to size "..chainsize)
		CL_CHAINS[self] = { size = chainsize, endtime = chainendtime }
		LocalPlayer().ChainUpdated = true // forces HUD to update
	end
	
	function meta:RemoveChain()
		//print("Player "..self:Name().."'s score chain broken")
		CL_CHAINS[self] = nil
		LocalPlayer().ChainUpdated = true // forces HUD to update
	end

	function meta:ValidChain()
		return CL_CHAINS[self].endtime >= CurTime()
	end
	
	function meta:GetChain()
		return CL_CHAINS[self]
	end
	
	function GetScoreChains()
		return CL_CHAINS
	end
end

function meta:GetPoints()
	return self:GetNWInt("points") or 0
end

function meta:GetAssistPoints()
	return self:GetNWInt("assistpoints") or 0
end

function meta:AddPropsBrokenChain( prop )
	self.PropsBrokenChain = self.PropsBrokenChain + 1
	umsg.Start("setpropsbroken",self)
		umsg.String(prop:GetModel())
	umsg.End()
end

function meta:RecordAndResetPropsBrokenChain()
	self.PropsBrokenChainRecord = math.max(self.PropsBrokenChain, self.PropsBrokenChainRecord)
	self.PropsBrokenChain = 0
	umsg.Start("resetpropsbroken",self)
	umsg.End()
end

/*
	--- Player absorbing stuff ---
*/
function meta:IsAbsorbed()

	return self:GetNWBool("isabsorbed")

end

function meta:GetAbsorber()

	return self:GetNWEntity("absorber")

end

function meta:SetAbsorbedPlayer( pl )

	self:SetNWEntity("absorbedpl", pl)

end

function meta:GetAbsorbedPlayer()

	return self:GetNWEntity("absorbedpl")

end

function meta:HasAbsorbedPlayer()
	
	return ValidEntity(self:GetNWEntity("absorbedpl"))
	
end

function meta:DropAbsorbedPlayer()

	if self:HasAbsorbedPlayer() then
		
		local absorbed = self:GetAbsorbedPlayer()
		absorbed:RestorePlayer( self:GetPos()+Vector(0,0,20) )
		
		// Invalidate the absorbed entity
		self:SetAbsorbedPlayer( Entity() )
		
	end

end

// Restores weapons if loadout is lost due to spawning in walls etc
function meta:CheckPlayerLoadout()

	if self:IsAbsorbed() then return end
	if not self:Alive() then return end
	if not GAMEMODE:InRound() then return end
	
	local weps = self:GetWeapons()
	local wepclasses = {}
	for k, v in pairs(weps) do
		table.insert(wepclasses, v:GetClass())
	end

	for k, weapon in pairs( self.WeaponsStored ) do
		if !table.HasValue(wepclasses, weapon) then
			self:Give(weapon)
		end
	end

end

function meta:SetPowerup( type )
	self:SetNWString("powerup",type)
end

function meta:GetPowerup()
	return self:GetNWString("powerup", "none")
end

function meta:CreateTrail()
	local powerup = GAMEMODE.Powerups["invisibility"]
	self.trail = util.SpriteTrail( self, self:LookupAttachment("chest"), powerup.trail.color, false, 64, 0, 10, 1/32 , powerup.trail.mat )
end

function meta:CreateEyeLaser()
	self.laser = ents.Create("cns_eyelaser")
	self.laser:SetOwner(self)
	self.laser:SetPos(self:GetPos())
	self.laser:Spawn()
end

function meta:RemoveTrail()
	if ValidEntity(self.trail) then
		self.trail:Remove()
	end
end

function meta:RemoveEyeLaser()
	if ValidEntity(self.laser) then
		self.laser:Remove()
	end
end

// On what team's territory is this player located?
function meta:TeamSide()

	return GAMEMODE:TeamSide(self:GetPos())

end

// HitTeamBoundary is called by the cns_team_boundary entity in the map
function meta:HitTeamBoundary()

	if not self.NotifyBreakStuff then
		self:Notify("Pull out your crowbar and go break stuff!", NOTIFY_GENERIC)
		self.NotifyBreakStuff = true
	end

end
