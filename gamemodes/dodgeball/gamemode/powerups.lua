///////////////////////////////////////////////
////////+Jump
///////////////////////////////////////////////

local PUP = {}	
	PUP.Duration				= 40
	function PUP:Use( pl )
		pl:SetJumpPower( 400 )
	end
	function PUP:End( pl )
		pl:SetJumpPower( 250 )
	end
	
	player_pup.Register( "jump", PUP )

///////////////////////////////////////////////
////////+Speed
///////////////////////////////////////////////

local PUP = {}
	PUP.Duration				= 40
	function PUP:Use( pl )
		pl:SetWalkSpeed( 700 )
		pl:SetRunSpeed( 700 )
	end
	function PUP:End( pl )
		pl:SetWalkSpeed( 400 )
		pl:SetRunSpeed( 400 )
	end
	
	player_pup.Register( "speed", PUP )

///////////////////////////////////////////////
////////+Freeze
///////////////////////////////////////////////

local PUP = {}
	PUP.Duration				= 1
	function PUP:Use( pl )
		pl:IceFreeze( ) //Rambo
	end
	function PUP:End( pl )
		pl:Thaw( true )
	end
	player_pup.Register( "freeze", PUP )

///////////////////////////////////////////////
////////+Jailbreak
///////////////////////////////////////////////

local PUP = {}
	function PUP:Use( pl )
		GAMEMODE:JailBreak( pl:Team() )
	end
	
	player_pup.Register( "jailbreak", PUP )

///////////////////////////////////////////////
////////+Point
///////////////////////////////////////////////

local PUP = {}
	function PUP:Use( pl )
		pl:AddFrags( 1 )
	end
	
	player_pup.Register( "point", PUP )
