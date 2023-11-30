extends AnimatedSprite3D


	##////////////////////////////////////////////
	## this is the heart and soul of this project. 
	##
	## Any code that is apart of the example and not actually part of the Slimebuck_sprite_rotation system
	## will be between comments made out of 3 hash tags (###) and will say not part of main project
	## then when the example code part is done, it will end with another 3 hash tag comment.
	##
	## so if you want to use this project and get rid of all the example stuff
	## just search ### and delete the code assosicated with it.
	## 
	##
	## this scipt controls getting positions, getting vectors between positions
	## then using that info to get angles between 3 objects.
	##
	## this creates a triange between the 3 points. 
	## There is 180 degrees in the triangle, and there is a -180 of the triangle flipped.
	## this gives us a range of 0 to 360, which we force to be a postive number between 0 and 360.
	##
	##
	## So by calculating 2 of the angles in the triangle, and getting the final number
	## of something between 0 and 360 we can then use a circle divided into 8 sections
	## to decide what sprite to show the player.
	##
	## degrees 337.6 to 360 front (first half)
	## degrees 0 - 22.5 = front (second half)
	## degrees 22.6 to 67.5 = front_right
	## degrees  67.6 to 112.5 right
	## degrees 112.6 to 157.5 back_right
	## degrees 157.6 to 202.5 back
	## degrees 202.6 to 247.5 back_left
	## degrees 247.6 to 292.5 left
	## degrees 292.6 to 337.5 front_left
	##
	##
	## so for example, if the 2 angles = -90 and the other one is 130, then final number will be 40.
	## This means, the front right side of the monster is facing the player 
	## 
	##
	## What needs to be edited to make this system work, is the AnimatedSprite3D of the
	## sprite object must be in group "sprite" for the system to see it and know it must deal with it.
	## Secondly, the object (so when you call place a enemy scene in the world scene, the enemy scene)
	## needs to have a unique group name sprite_#, where # is sprite number.
	##
	## the object needs this unique group name so that every sprite 
	## can operate independly of each other.
	## 
	## Then you need to make an @onready variable in this script for every sprite_# you have.
	## This example has 2 sprites, so there is sprite_1 and sprite_2
	##
@onready var sprite_1 : Node = get_tree().get_first_node_in_group("sprite_1")
@onready var sprite_2 : Node = get_tree().get_first_node_in_group("sprite_2")


const SPEED : int = 15


	## on ready vars to connect to lookpoint nodes to get postions and do math

	# connects sprites to player
@onready var player : Node = get_tree().get_first_node_in_group("player")
	# connects sprites to 3rd point in position triangle system
@onready var lookat_red : Node = get_tree().get_first_node_in_group("lookspot_red")

var player_to_sprite : Vector3
var sprite_to_lookpoint : Vector3 


	## vars to toggle chase on and off
var chase_1 :bool 
var chase_2 : bool

	## var that aid in functions to link look spots, or control states
var sprite : Node
var look_spot : int = 1
var enemy_state : String = "chase_"


	## Movement Vars
##Speed of the path the monsters start on
@export var path_speed : float = .3


	### These variables are for the example and not part of the main project
	### they are to connect the blue blox lookpoint and the path lookpoints
@onready var lookat_blue : Node = get_tree().get_first_node_in_group("lookspot_blue")

@onready var path_1 : Node = get_tree().get_first_node_in_group("lookspot_path_1")
@onready var path_2 : Node = get_tree().get_first_node_in_group("lookspot_path_2")


func sprite_process(delta):
	## get sprite rotation functions get_positions and state_animation
	get_positions()
	state_animation()
	change_lookpoint_selector()

	
	## change_state_test and Start_stop_move_test is for use with example 
	## and not part of main project.
	## Change_state - button to change animation
	change_sprite_state()
	## stop path movement of sprite
	start_stop_move_1()
	start_stop_move_2()
	

	###PART OF EXAMPLE - NOT PART OF MAIN PROJECT ###
	### controls the path speed if move is allowed
	#if sprite.path_move_allow:
		#sprite.move_path_allow(delta)

	#var path :Node
	if sprite_1.sprite3d.path_1_move_allow:
		for paths in get_tree().get_nodes_in_group("sprite_path_1"):
			paths.progress += path_speed + delta

	if sprite_2.sprite3d.path_2_move_allow:
		for paths in get_tree().get_nodes_in_group("sprite_path_2"):
			paths.progress += path_speed + delta

	### END OF PATH SPEED CONTROL EXAMPLE CODE ###




func get_positions():
	## get positions of 3 points to use math to figure out angles and degrees
	sprite.player_position = player.global_transform.origin
	sprite.lookpoint_position = sprite.lookpoint.global_transform.origin
	sprite.sprite_position = sprite.global_transform.origin


	### Billboards the sprite so it always looks at the player
	sprite.cam_pos = player.global_transform.origin
	sprite.look_at(sprite.player_position, Vector3(0, 1, 0))
	rotation.x = 0

	## Get Vectors between the 3 positions
	player_to_sprite = sprite.sprite_position - sprite.player_position
	sprite_to_lookpoint = sprite.sprite_position - sprite.lookpoint_position

	## get angle between vectors
	var angle_player_to_sprite : float = atan2(player_to_sprite.z, player_to_sprite.x)
	var angle_sprite_to_lookpoint : float = atan2(sprite_to_lookpoint.z, sprite_to_lookpoint.x)

	## use angle to get degrees
	angle_player_to_sprite = rad_to_deg(angle_player_to_sprite)
	angle_sprite_to_lookpoint = rad_to_deg(angle_sprite_to_lookpoint)

	## Math to figure out degrees of sprite to lookpoint
	var adjusted_degrees = angle_sprite_to_lookpoint - angle_player_to_sprite

	## Use fmod to force degrees between 0 and 360
	adjusted_degrees = fmod(adjusted_degrees + 360.0, 360.0)
	sprite.enemy_degrees = adjusted_degrees


func state_animation():
	
	## Here I split up the 360 degrees of a circle
	## in equal chunks so we get 8 even segments 
	## We input the angle of the sprite to the player from the lookpoint
	## and based on what degrees is inputed in, is what animation direction is shown
	##
	## degrees 337.6 to 360 front (first half)
	## degrees 0 - 22.5 = front (second half)
	## degrees 22.6 to 67.5 = front_right
	## degrees  67.6 to 112.5 right
	## degrees 112.6 to 157.5 back_right
	## degrees 157.6 to 202.5 back
	## degrees 202.6 to 247.5 back_left
	## degrees 247.6 to 292.5 left
	## degrees 292.6 to 337.5 front_left
	##
	##
	## for 4 directional sprites you would use these values
	##
	## degrees 292.6 to 360 front (first half)
	## degrees 0 to 67.5 = front_right
	## degrees  67.6 to 157.5 right
	## degrees 157.6 to 247.5 back
	## degrees 247.6 to 292.5 left
	
	if sprite.enemy_degrees >= 292.5 && sprite.enemy_degrees < 337.5:
		play(enemy_state + "front_left")
		
	elif sprite.enemy_degrees >= 22.5 && sprite.enemy_degrees < 67.5:
		play(enemy_state + "front_right")
		
	elif sprite.enemy_degrees >= 67.5 && sprite.enemy_degrees < 112.5:
		play(enemy_state + "right")

	elif sprite.enemy_degrees >= 112.5 && sprite.enemy_degrees < 157.5:
		play(enemy_state + "back_right")

	elif sprite.enemy_degrees >= 157.5 && sprite.enemy_degrees < 202.5:
		play(enemy_state + "back")

	elif sprite.enemy_degrees >= 202.5 && sprite.enemy_degrees < 247.5:
		play(enemy_state + "back_left")

	elif sprite.enemy_degrees >= 247.5 && sprite.enemy_degrees < 292.5:
		play(enemy_state + "left")
	
	elif sprite.enemy_degrees >= 337.5 || sprite.enemy_degrees > 360:
		play(enemy_state + "front")
		
	elif sprite.enemy_degrees >= 0 || sprite.enemy_degrees > 22.5:
		play(enemy_state + "front")


	### EVERYTHING BELOW IS JUST FOR THE EXAMPLE AND NOT APART OF THE MAIN PROJECT 
	### This includes functions for button presses to stop movement, change lookpoint 
	### and cycle animation 
	### change state changes animation 
func change_sprite_state():
	if Input.is_action_just_pressed("change_state"):
		if enemy_state == "chase_": enemy_state = "ra_attack_"
		elif enemy_state == "ra_attack_": enemy_state = "p_attack_"
		elif enemy_state == "p_attack_": enemy_state = "chase_"



	#### start stop move stops path movement of sprite. used in the example, not part of main project
func start_stop_move_1():
	if Input.is_action_just_pressed("sprite_path_move_1"):
		if player.pathkill_1: return 

		sprite.path_1_move_allow =!sprite.path_1_move_allow
			
func start_stop_move_2():
	if Input.is_action_just_pressed("sprite_path_move_2"):
		if player.pathkill_2: return
		sprite.path_2_move_allow =!sprite.path_2_move_allow


	### THIS IS PART OF THE EXAMPLE, CHANGE LOOKPOINT OF MONSTERS
		
func change_lookpoint_selector():
	if Input.is_action_just_pressed("change_lookpoint_1"):
		switch_lookpoint(sprite_1.sprite3d)
		player.ui_panel.ui_sprite_select = 1
	if Input.is_action_just_pressed("change_lookpoint_2"):
		switch_lookpoint(sprite_2.sprite3d)
		player.ui_panel.ui_sprite_select = 2
		
func switch_lookpoint(insert_look):
	insert_look.sprite_select = insert_look
	if look_spot == 1:
		insert_look.change_lookpoint("blue")
		look_spot = 2
	elif look_spot == 2:
		insert_look.change_lookpoint("red")
		look_spot = 3
	elif look_spot == 3:
		insert_look.change_lookpoint("player")
		look_spot = 4
	elif look_spot == 4:
		insert_look.change_lookpoint("path")
		look_spot = 5
	elif look_spot == 5:
		insert_look.change_lookpoint("other_sprite")
		look_spot = 1

	### End of monster look spot change button


	### NOT PART OF MAIN PROJECT, FOR THE EXAMPLE
	### Chase toggle function to switch some toggle controls on button press

func chase_toggle(which_path_off):
	if which_path_off == "path_1_move_allow":
		player.ui_panel.ui_chase_1 = !player.ui_panel.ui_chase_1
		sprite.get_parent().chase_1 =! sprite.get_parent().chase_1
	elif which_path_off == "path_2_move_allow":
		player.ui_panel.ui_chase_2 = !player.ui_panel.ui_chase_2
		sprite.get_parent().chase_2 =! sprite.get_parent().chase_2
	### end of chase variable toggle controller
