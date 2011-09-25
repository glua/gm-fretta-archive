if (SERVER) then
	
	function GM:GravGunPickupAllowed( ply, ent )
		if ent == NULL then return false end
		if (ent:GetClass() == "gmod_dodgeball") then
			if !ent.Punter then
				return true
			elseif ent.Punter:Team() == ply:Team() then
				if ent.PuntTime + 1 < CurTime() then
					return true
				end
			end
		end
		
		return false
	end
	
	function GM:GravGunOnPickedUp( ply, ent )
		
		if ent.Punter then
			if ent.Punter:Team() != ply:Team() then
				player_pup.Obtain( ent.Punter, "freeze" )
				player_pup.Obtain( ply, "point" )
			end
		end
		
		ply.holdingball = ent
		ent.eOwner = ply
		ent.Punter = nil
		ent.NoGrabPunt = false
		ent.wallkill = false
		
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		
		umsg.Start( "DodgeballOwner", rp )
			umsg.Entity( ent )
			umsg.Entity( ply )
		umsg.End( )
			
	end
	
	function GM:GravGunPunt( ply, ent )
		
		if !(ent.eOwner) then
			ent.NoGrabPunt = true
		end
		
		ent.Punter = ply
		ent.PuntTime = CurTime()
		--now it runs on dropped
		
		return true
		
	end
	
	function GM:GravGunOnDropped( ply, ent )
		
		ent.eOwner = nil
		ent.DeathTime = nil
		ply.holdingball = nil
		ent.NoGrabPunt = false
		ent.wallkill = false
		
		umsg.Start( "DodgeballDrop", rp )
			umsg.Entity( ent )
		umsg.End( )
		
		return true
		
	end
	
end

if (CLIENT) then
	
	function DodgeBallOwner( dmsg )
		local ball = dmsg:ReadEntity()
		local owner = dmsg:ReadEntity()
		ball.eOwner = owner
	end
	
	usermessage.Hook("DodgeballOwner", DodgeBallOwner)  
	
	function DodgeBallDrop( dmsg )
		local ball = dmsg:ReadEntity()
		ball.eOwner = nil
		ball.DeathTime = nil
		ball.BallMaterial = Material( "sprites/ball/sent_ball0" )
	end
	
	usermessage.Hook("DodgeballDrop", DodgeBallDrop)  
	
	function DodgeBallPunter( dmsg )
		local ball = dmsg:ReadEntity()
		local ply = dmsg:ReadEntity()
		ball.Punter = ply
		ball.eOwner = nil
		ball.DeathTime = nil
		ball.BallMaterial = Material( "sprites/ball/sent_ball0" )
	end
	
	usermessage.Hook("DodgeballPunter", DodgeBallPunter)
	
end
