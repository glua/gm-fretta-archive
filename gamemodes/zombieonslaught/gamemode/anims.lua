
local PoisonZombie = {}
PoisonZombie[PLAYER_IDLE] = ACT_IDLE
PoisonZombie[PLAYER_WALK] = ACT_WALK
PoisonZombie[PLAYER_JUMP] = ACT_WALK
PoisonZombie[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
PoisonZombie[PLAYER_SUPERJUMP] = ACT_RANGE_ATTACK2

function PoisonZombieAnim( ply, anim )

	local act = ACT_IDLE
	local speed = ply:GetVelocity():Length()

	if PoisonZombie[anim] != nil then
		act = PoisonZombie[anim]
	else
		if speed > 0 then
			act = ACT_WALK
		end
	end

	if act == ACT_IDLE_ON_FIRE then
		if speed > 0 then
			act = ACT_WALK_ON_FIRE
		end
	end

	if act == ACT_MELEE_ATTACK1 or anim == PLAYER_SUPERJUMP then
		ply:SetPlaybackRate(2)
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)
	if act == ACT_WALK then
		seq = 3
	end

	if seq == 3 then
		ply:SetPlaybackRate(1.5) //walking
	else
		ply:SetPlaybackRate(1.0)
	end

	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetCycle(0)
	return true
	
end

local FastZombie = {}
FastZombie[PLAYER_IDLE] = ACT_IDLE
FastZombie[PLAYER_WALK] = ACT_RUN
FastZombie[PLAYER_JUMP] = ACT_RUN
FastZombie[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
FastZombie[PLAYER_SUPERJUMP] = ACT_CLIMB_UP

function FastZombieAnim( ply, anim )

	local act = ACT_IDLE
	local speed = ply:GetVelocity():Length()
	local ground = ply:OnGround()

	if FastZombie[anim] != nil then
		act = FastZombie[anim]
	else
		if speed > 0 then
			act = ACT_RUN
		end
	end

	if act == ACT_MELEE_ATTACK1 or act == ACT_CLIMB_UP then
		ply:RestartGesture( act )
		return true
	end

	local seq = ply:SelectWeightedSequence(act)

	if not ground and act != ACT_CLIMB_UP then
	    seq = 3
	end

	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetPlaybackRate(1.0)
	ply:SetCycle(0)
	return true
	
end

local Zombie = {}
Zombie[PLAYER_IDLE] = ACT_IDLE
Zombie[PLAYER_WALK] = ACT_WALK
Zombie[PLAYER_JUMP] = ACT_WALK
Zombie[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
Zombie[PLAYER_SUPERJUMP] = ACT_IDLE_ON_FIRE

function ZombieAnim( ply, anim )

	local act = ACT_IDLE
	local speed = ply:GetVelocity():Length()

	if Zombie[anim] != nil then
		act = Zombie[anim]
	else
		if speed > 0 then
			act = ACT_WALK
		end
	end

	if act == ACT_MELEE_ATTACK1 or anim == PLAYER_SUPERJUMP then
		ply:SetPlaybackRate(2)
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)
	if act == ACT_WALK then
		seq = 2
	end

	if seq == 2 then
		ply:SetPlaybackRate(1.5)
	else
		ply:SetPlaybackRate(1.0)
	end
	
	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetCycle(0)
	return true
	
end

local ZombieTorso = {}
ZombieTorso[PLAYER_IDLE] = ACT_IDLE
ZombieTorso[PLAYER_WALK] = ACT_WALK
ZombieTorso[PLAYER_JUMP] = ACT_WALK
ZombieTorso[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
ZombieTorso[PLAYER_SUPERJUMP] = ACT_MELEE_ATTACK1

function ZombieTorsoAnim( ply, anim )

	local act = ACT_IDLE
	local speed = ply:GetVelocity():Length()

	if ZombieTorso[anim] != nil then
		act = ZombieTorso[anim]
	else
		if speed > 0 then
			act = ACT_WALK
		end
	end

	if act == ACT_MELEE_ATTACK1 or anim == PLAYER_SUPERJUMP then
		ply:SetPlaybackRate(2)
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)
	if act == ACT_WALK then
		seq = 2
	end

	if seq == 2 then
		ply:SetPlaybackRate(1.5)
	else
		ply:SetPlaybackRate(1.0)
	end
	
	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetCycle(0)
	return true
	
end

function GM:SetPlayerAnimation( ply, anim )

	if ply:Team() == TEAM_DEAD then
	
		if SpecialAnims[ ply:GetModel() ] then
		
			SpecialAnims[ ply:GetModel() ]( ply, anim )
			return
			
		end
		
	end

	self.BaseClass:SetPlayerAnimation( ply, anim ) 
	
end

SpecialAnims = {}
SpecialAnims["models/zombie/fast.mdl"] = FastZombieAnim
SpecialAnims["models/zombie/poison.mdl"] = PoisonZombieAnim
SpecialAnims["models/zombie/classic.mdl"] = ZombieAnim
SpecialAnims["models/zombie/classic_torso.mdl"] = ZombieTorsoAnim
