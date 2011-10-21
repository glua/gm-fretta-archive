
local CLASS = {}

CLASS.DisplayName			= "Bomber"
CLASS.WalkSpeed 			= 200
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 200
CLASS.DuckSpeed				= 0.5
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= true
CLASS.CanUseFlashlight      = true
CLASS.MaxHealth				= 50
CLASS.StartHealth			= 50

function CLASS:Loadout( pl )

	pl:Give( "weapon_suicidal" )
	
	// Setup default positions, just in case
	local pos, ang = pl:GetPos() + Vector(0,0,40) + pl:GetForward() * -10, pl:GetForward():Angle() + Angle(20,0,0)
	
	// Attach to spine
	local boneid = pl:LookupBone("ValveBiped.Bip01_Spine2")
	if boneid then
		pos, ang = pl:GetBonePosition( BoneIndx )
	end
    
	local bomb = ents.Create( "sent_dynamite" )
	bomb:SetPos( pos )
	bomb:SetAngles( ang )
	bomb:SetParent( pl )
	bomb:SetOwner( pl )
	bomb:Spawn()
	
	pl:SetBomb( bomb )
	
end

function CLASS:OnDeath( pl, dmginfo )

	if ValidEntity( pl:GetBomb() ) then
	
		pl:GetBomb():Remove()
		
		local bomb = ents.Create( "sent_dynamite" )
		bomb:SetPos( pl:GetPos() + Vector(0,0,40) + pl:GetForward() * -10 )
		bomb:SetAngles( pl:GetForward():Angle() + Angle(20,0,0) )
		bomb:SetOwner( pl )
		bomb:Spawn()
		bomb:SetBombTime( math.Rand( 3, 6 ) )
	
	end

end

player_class.Register( "Suicidal", CLASS )