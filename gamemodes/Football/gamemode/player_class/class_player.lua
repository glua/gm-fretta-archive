local CLASS = {}  
  
CLASS.DisplayName           = "Player Class"  
CLASS.WalkSpeed             = 250  
CLASS.CrouchedWalkSpeed     = 0.2  
CLASS.RunSpeed              = 350  
CLASS.DuckSpeed             = 0.4  
CLASS.JumpPower             = 175  
CLASS.DrawTeamRing          = true  
CLASS.MaxHealth				= 100
CLASS.StartHealth			= 100
CLASS.Description           = ""

CLASS.RespawnTime           = 3 
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= false
CLASS.AvoidPlayers			= true 

function CLASS:Loadout( pl )  
    pl:Give( "weapon_physcannon")
end  

player_class.Register( "player", CLASS )  