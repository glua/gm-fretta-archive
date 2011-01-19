
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:Resurrect()

	self:UnSpectate()
	self:Spawn()
	
	self:ChatPrint("A teammate pulled you back in!")
	
end

function meta:ResetScore()

	self:SetFrags(0)
	self:UpgradeBalls(0)
	
end

function meta:UpgradeBalls( num )

	if !num or num > 10 then return end //no more upgrades after 10 kills
	
	if num == 0 then
	
		self:SetBallType( GAMEMODE.Balls[1] )
		
		local gun = self:GetActiveWeapon()
		if gun:IsValid() and gun != NULL then
			gun:SetMaxAmmo(2)
			gun:SetFireDelay(0.5)
		end
		
		return
		
	end

	local tbl = {}
	
	for k,v in pairs(GAMEMODE.Balls) do
		if v.Kills == num then
			table.insert(tbl,v)
		end
	end
	
	local balltype = table.Random( tbl )
	
	self:SetBallType( balltype )
	self:ChatPrint("Gained Upgrade: "..balltype.Name)
	self:EmitSound(Sound("weapons/physgun_off.wav"))
	
	local gun = self:GetActiveWeapon()
	if gun:IsValid() and gun != NULL then
		gun:SetMaxAmmo( balltype.Ammo )
		gun:SetFireDelay( balltype.ROF )
	end
	
end

function meta:SetBallType( ball )
	self.BallType = ball
end

function meta:GetBallType()
	return self.BallType or GAMEMODE.Balls[1]
end
