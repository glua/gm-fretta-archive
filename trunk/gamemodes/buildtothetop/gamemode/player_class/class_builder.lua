local CLASS = {}  
  
CLASS.DisplayName           = "Builder Class"  
CLASS.WalkSpeed             = 250  
CLASS.CrouchedWalkSpeed     = 0.2  
CLASS.RunSpeed              = 350  
CLASS.DuckSpeed             = 0.4  
CLASS.JumpPower             = 175  
CLASS.DrawTeamRing          = true  
CLASS.MaxHealth				= 150
CLASS.StartHealth			= 150
CLASS.Description           = ""

CLASS.RespawnTime           = 3 
CLASS.DropWeaponOnDie		= false
CLASS.TeammateNoCollide 	= true
CLASS.AvoidPlayers			= true 

function CLASS:Loadout( pl )  
   
    pl:Give( "crate_spawner" ) 
    pl:Give( "weapon_physgun")
end  
     
player_class.Register( "Builder", CLASS )  