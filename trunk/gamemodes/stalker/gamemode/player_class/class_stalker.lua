
local CLASS = {}

CLASS.DisplayName			= "Stalker"
CLASS.PlayerModel			= "models/player/charple01.mdl"
CLASS.WalkSpeed 			= 350
CLASS.CrouchedWalkSpeed 	= 0.5
CLASS.RunSpeed				= 350
CLASS.DuckSpeed				= 0.2
CLASS.JumpPower				= 300
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = false
CLASS.DieSound              = Sound( "npc/stalker/breathing3.wav" )

function CLASS:Loadout( pl )
	
	pl:Give( "weapon_stalker" )
	
end

function CLASS:OnSpawn( pl )

	local hp = 150 + 25 * math.Clamp( team.NumPlayers( TEAM_HUMAN ), 1, 20 )

	pl:SetMana( 100 )
	pl:SetHealth( hp )
	pl:SetMaxHealth( hp )
	pl:SetColor( 255, 255, 255, 10 )
	
	pl:SetNWInt( "MenuChoice", 1 )
	pl:SetNWBool( "Menu", true )
	
	pl.DrainTime = CurTime() + 5
	
end

function CLASS:OnDeath( pl )

	pl:EmitSound( self.DieSound )

end 

function CLASS:Think( pl )

	if not GAMEMODE:InRound() then return end
	
	for k,v in pairs( ents.FindByClass( "prop_*" ) ) do
	
		if ( v.Psycho or 0 ) > CurTime() then
		
			if ( v.Boost or 0 ) < CurTime() then
			
				v.Boost = CurTime() + math.Rand(1,3)
				v:EmitSound( table.Random( GAMEMODE.PsychoProp ), 100, math.random(100,120) )
				v:SetPhysicsAttacker( team.GetPlayers( TEAM_STALKER )[1] )
				
				local phys = v:GetPhysicsObject()
				
				if ValidEntity( phys ) then
				
					phys:ApplyForceCenter( VectorRand() * math.Clamp( phys:GetMass(), 50, 5000 ) ^ 3 ) 
					phys:AddAngleVelocity( Angle( math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000) ) )
					
				end
				
			end
			
		end
		
	end

	if ( pl.ManaTime or 0 ) < CurTime() and not pl:GetNWBool( "StalkerEsp", false ) then
	
		pl.ManaTime = CurTime() + 0.5
		pl:AddMana( 1 )
	
	end
	
	if ( pl.DrainTime or 0 ) < CurTime() and pl:GetNWInt( "Poison", 0 ) < 1 and GAMEMODE:ActivePlayers() > 1 then
	
		if pl:Health() == 1 and pl:Alive() then
			pl:Kill()
		end
	
		pl:SetHealth( math.Clamp( pl:Health() - 1, 1, 1000 ) )
		pl.DrainTime = CurTime() + 2.0
	
	end

end

function CLASS:OnKeyPress( pl, key )

	if CLIENT then return end
	
	if key == IN_USE then
	
		pl:SetNWBool( "Menu", !pl:GetNWBool( "Menu", false ) )
	
	end

	if key == IN_SPEED then
	
		if pl:OnGround() and ( pl.JumpTime or 0 ) < CurTime() then
		
			local jump = pl:GetAimVector() * 500 + Vector(0,0,400)
		
			pl:EmitSound( Sound( "npc/zombie/foot2.wav" ), 50, math.random(90,110) )
			pl:SetVelocity( jump )
			pl.JumpTime = CurTime() + 1
			
		else
		
			local tr = util.TraceLine( util.GetPlayerTrace( pl ) )
			
			if tr.HitPos:Distance( pl:GetShootPos() ) < 50 and not pl:OnGround() then
			
				pl:SetMoveType( MOVETYPE_NONE )
				
			elseif pl:GetMoveType() == MOVETYPE_NONE then
			
				pl:SetMoveType( MOVETYPE_WALK )
				pl:SetLocalVelocity( pl:GetAimVector() * 400 )
				
			end
			
		end
		
	elseif key == IN_JUMP and pl:GetMoveType() == MOVETYPE_NONE then
	
		pl:SetMoveType( MOVETYPE_WALK )
		pl:SetLocalVelocity( Vector(0,0,50) )
		
	end
	
end

player_class.Register( "Stalker", CLASS )
