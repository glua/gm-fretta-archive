
GM.Balls = {}

// this is the funnction used to add a ball to the list.
// params: SENT name, Print Name, Kills needed to earn ball, Chance of earning ball (from 0 to 1)
// the balls with higher chances are more likely to be given to players

local function AddBall( class, name, ammo, rof, kills )

	local tbl = { Class = class, Name = name, Ammo = ammo, ROF = rof, Kills = kills }
	table.insert( GM.Balls, tbl )
	
end 

// set up the ball upgrade progression

AddBall( "ball_base", "Rubber Ball", 2, 0.5, 0 ) //the default starter ball

AddBall( "ball_bouncy", "Bouncy Ball", 1, 0.5, 1 )
AddBall( "ball_turtle", "Turtle Ball", 1, 0.5, 1 )
AddBall( "ball_zerograv", "Zero-Gravity Ball", 1, 0.5, 1 )

AddBall( "ball_rapidfire", "Rapidfire Balls", 10, 0.15, 2 )
AddBall( "ball_zerograv", "Zero-Gravity Balls", 2, 0.5, 2 )
AddBall( "ball_shotgun", "Ball Shotgun", 1, 0.5, 2 )

AddBall( "ball_wrench", "Wrenches", 3, 0.5, 3 )
AddBall( "ball_rapidfire", "Improved Rapidfire Balls", 15, 0.1, 3 )
AddBall( "ball_shotgun", "Improved Ball Shotgun", 3, 0.7, 3 )

AddBall( "ball_wrench", "More Wrenches", 5, 0.3, 4 )
AddBall( "ball_boomer", "Baby Boomer", 1, 0.5, 4 )
AddBall( "ball_bananabomb", "Banana Bomb", 1, 0.5, 4 )

AddBall( "ball_bananabomb", "Banana Bombs", 5, 0.3, 5 )
AddBall( "ball_homing", "Homing Ball", 1, 0.5, 5 )
AddBall( "ball_fruitsalad", "Fruit Salad Bomb", 1, 0.5, 5 )

AddBall( "ball_homing", "Homing Balls", 3, 0.2, 6 )
AddBall( "ball_skull", "Murray", 1, 0.5, 6 )
AddBall( "ball_criticalmass", "Critical Mass Ball", 1, 0.5, 6 )

AddBall( "ball_dynamite", "Dynamite", 1, 0.5, 7 )

AddBall( "ball_car", "Car Launcher", 1, 0.5, 8 )

AddBall( "ball_missile", "Missile Launcher", 1, 0.5, 9 )

AddBall( "ball_minigun", "Ball Minigun", 100, 0.08, 10 )