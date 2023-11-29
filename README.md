# Slimebucks-Godot-8Directional-Example
1) Intro
2) Controls of example project
3) Overview of what this multi directional Animated Sprite 3D Controller does and how it does it.
4) Credits

1 ) godot 4.2 3D example project showcasing how to control sprites and enemy movement

Greetings! This is Slimebuck here, coming at you with a first in series of free tutorial and learning example projects.

This project is aimed to help people learn 2 fundemenals of Godot 3D.
1) 8 and 4 directional sprites 
2) Character movement controls

Anyone wishing to make a 3D shooter using sprites and want to learn how, this example project is aimed to you.

I spent a lot of time perfecting the code making it as tight, efficent and short as possible. 

2) Controls:
W - Forward
S - Backward
A - Left
D - Right

Space - Jump

Left Mouse Button - shoot animation (does nothing, just for lols)
Right Mouse Button - Change Sprites Animation type, There is walk, attack_1 and attack_2

R - Restart
ESC - Quit

OVERLORD Controls:

I - Toggle Chase Mode

J - Change Look Direction  - directions to choose from = Red box - Blue box - Player - Path (Stopped after chase mode actived) and the other sprite.

N -Start or stop Path Movement. (Note, when chase mode enabled the path is disabled. To re use the paths press R to restart)


THORNED HULK Controls:

O - Toggle chase mode

K - Change Look Direction - directions to choose from = Red box - Blue box - Player - Path (Stopped after chase mode actived) and the other sprite.

M - Start or stop Path Movement. (Note, when chase mode enabled the path is disabled. To re use the paths press R to restart)


	
3)	this Project is a 8 directional sprite controller that controls getting positions, vectors between positions those positions,
	then using that info to get angles, which can then be used to control the direction of the spirte, and the character body of the sprite.

   Getting all these points, then vertors between those points allows us to do calculations.
	 this gives us a range of 0 to 360, which we force to be a postive number between 0 and 360.

  the way the calculations work is that there is always a triangle between player postion, sprite position, center 0,0,0.
  we can use this an input 2 angles values of that triangle into an equasion to get a a value, we can then force to be between 0 and 360.
  THis is because there is 180 degrees in the triangle between the spots, but 
  there is also the flipped negative version of that triangle where all its values go in the negatives.
  This gives us a triangle with 180 degrees, and another one with -180 equaling a total of 360 degrees to work with.
	
	
	 So by calculating 2 of the angles in the triangle, and getting the final number
	 of something between 0 and 360 we can then use a circle divided into 8 sections
	 to decide what sprite to show the player.
	
	 degrees 337.6 to 360 front (first half)
	 degrees 0 - 22.5 = front (second half)
	 degrees 22.6 to 67.5 = front_right
	 degrees  67.6 to 112.5 right
	 degrees 112.6 to 157.5 back_right
	 degrees 157.6 to 202.5 back
	 degrees 202.6 to 247.5 back_left
	 degrees 247.6 to 292.5 left
	 degrees 292.6 to 337.5 front_left
	
	
	 so for example, if the 2 angles = -90 and the other one is 130, then final number will be 40.
	 This means, the front right side of the monster is facing the player 
	 
	
	 What needs to be edited to make this system work, is the AnimatedSprite3D of the
	 sprite object must be in group "sprite" for the system to see it and know it must deal with it.
	 Secondly, the object (so when you call place a enemy scene in the world scene, the enemy scene)
	 needs to have a unique group name sprite_#, where # is sprite number.
	
	 the object needs this unique group name so that every sprite 
	 can operate independly of each other.
	 
	 Then you need to make an @onready variable in this script for every sprite_# you have.
	 This example has 2 sprites, so there is sprite_1 and sprite_2

  
	 Any code that is apart of the example and not actually part of the Slimebuck_sprite_rotation system
	 will be between comments made out of 3 hash tags (###) and will say not part of main project
	 then when the example code part is done, it will end with another 3 hash tag comment.
	
	so if you want to use this project and get rid of all the example stuff
   just search ### and delete the code assosicated with it.


 4)  Credits
   
   2.5d Godot 4 project by styroxx. his syste, while flawed, is the starting point of my journey making this example. This project is owed to him
   gun sprite - gun sound - audio script - Miziziziz Tutorials - https://www.youtube.com/watch?v=jzbgH4AMtI8
   Godot Discord Dev Chat
   ChatGPT - interactive documentation and info look up.
   Overlord sprite - Duke Nukem 3D. 3D Realms made that art, I don't know who owns it now
   Thorned Hulk - Diablo 2 - Blizzard North 
   beta ground texture - Kenney beta textures
   Michael
   my amazing wife, none of this would be possible without her support
   shout out to the GKillers! ill hit yal up behind the dollar store and we play some fortnite - RIP CS GO - *in radio voice* MICHEAL! MICHAEL, DON'T LEAVE ME! MICHAEL!!"
   
