
//Server

Cactus.Hints = {}
Cactus.Hints.Types = {
"wiggle",
"caught"
}
Cactus.Hints.Humans = {}
Cactus.Hints.Humans.Generic = {
"Watch our for explosive(black) cacti!",
"Explosive(black) cacti make a ticking sound when they're close.",
--"Explosive(black) cacti give off sparks when they're about to explode.",
"The Golden(yellow) cactus gives you the most points!",
"Slow(blue) cacti give you the least points.",
--"Power-up(pink) cacti give you a random power-up when caught!",
--"Power-up(pink) cacti can give you weapons, upgrades, and traps.",
"Your Vacuum can pull in multiple cacti at once!",
--"Make good use of your traps!",
--"The Grappling Gun can grab cacti at long distances.",
--"The Grappling Gun allows you to grapple to any surface by using secondary fire.",
"Cacti can boost out of your vacuum's suck cone."
}

Cactus.Hints.Cacti = {}
Cactus.Hints.Cacti.Generic = {
"Slow(blue) cacti my be slow, but they pack a punch.",
"Explosive(black) cacti have a timed self-destruct.",
"Don't get caught as the Golden(yellow) cactus!",
"Fast(red) cacti are fast, and are worth a lot of points.",
"Normal(green) cacti have balanced abilities.",
--"Power-up(pink) cacti give a power-up to whoever catches them.",
--"Humans drop cactus power-ups when you kill them!",
--"When you get a weapon upgrade, your boosting ability will go away.",
"Use your primary attack to escape from vacuums.",
"Primary attack propels yourself forward and does damage.",
"Cacti can only fly so high.",
"The Golden(yellow) cactus is the most value to humans."
}


//All sounds
Cactus.Sounds = {
"cactus/cactus_low.mp3",
"cactus/cactus_nerd.mp3",
"cactus/5cacti.mp3",
"cactus/andcactus.mp3",
"cactus/uhcactus.mp3",
"cactus/cactuscactus.mp3",
"cactus/evilcactus.mp3",
"Buttons.snd14"
}
//Insert all the cactus#.mp3's so I don't have to manually.
for i=1,10 do
	table.insert(Cactus.Sounds,"cactus/cactus"..tostring(i)..".mp3")
end

GM.WinSound = "cactuscactus_2.mp3"
GM.LoseSound = "cactuspie.mp3"

for k,v in pairs(Cactus.Sounds) do
	resource.AddFile("sound/"..v)
end


