extends Panel

	### EVERYTHING IN THIS SCRIPT IS FOR THE EXAMPE AND NOT PART OF THE MAIN PROJECT

	## Vars connecting button toggoles to the us, connecting,. 
	## Using strings for look spot of monster - spot1 ,spot 2, and spot_connector
	##spot_1 and spot_2 hold var data, spot_connector connects to the sprite_as3d script
	
var spot1 : String = "path"
var spot2 : String = "path"
var spot_connector : String 

	## bool for chase_1 and chase_2 toggles
var ui_chase_1 : bool = false
var ui_chase_2 : bool = false

	#Var onready for node links
@onready var player : Node = get_tree().get_first_node_in_group("player")
@onready var sprite_1 : Node = get_tree().get_first_node_in_group("sprite_1")
@onready var sprite_2 : Node = get_tree().get_first_node_in_group("sprite_2")


func _process(_delta):
	## function to make the ui control keys change color when the key is presssed
	change_key_color()
	
	
	## Is chasing: in UI
	if ui_chase_1:
		$chase1.text = "yes"
	else:
		$chase1.text = "no"
		
	if ui_chase_2:
		$chase2.text = "yes"
	else:
		$chase2.text = "no"
		

	## Moving on path
	## when chase is enabled the path is disabled until restart, so when this happens display disabled
	## for moving on path:
	if player.pathkill_1: $pathallow1.text = "disabled"
	elif sprite_1.sprite3d.path_1_move_allow: $pathallow1.text = "yes"
	else:
		$pathallow1.text = "no"
		
	if player.pathkill_2: $pathallow2.text = "disabled"
	elif sprite_2.sprite3d.path_2_move_allow: $pathallow2.text = "yes"
	else:
		$pathallow2.text = "no"
	
	
		## Looking At: in UI
		## when the path is disabled we change path on the direction list to STOPPED
		## I set it to make sure player speed was also set to 0 as well as the toggles being on
		## to prevent it from switching to stopped if player was on path when they clicked chase
		## as the player does not stop moving when that happens, that way once it actually comes to
		## a stop it will start to say STOPPED
	
	if ui_chase_1 == true and player.pathkill_1 and spot1 == "path" and sprite_1.current_speed == 0:
		spot1 = "stopped"
	else:
		$lookpoint1.text = spot1

	if ui_chase_2 == true and player.pathkill_2 and spot2 == "path" and sprite_2.current_speed == 0:
		spot2 = "stopped"
	else:
		$lookpoint2.text = spot2
	
	
func change_key_color():
	if Input.is_action_just_pressed("sprite_chase_1"):
		$white_keys/i.visible = false
		$red_keys/i.visible = true
	if Input.is_action_just_released("sprite_chase_1"):
		$white_keys/i.visible = true
		$red_keys/i.visible = false
		
		
	if Input.is_action_just_pressed("change_lookpoint_1"):
		$white_keys/j.visible = false
		$red_keys/j.visible = true
	if Input.is_action_just_released("change_lookpoint_1"):
		$white_keys/j.visible = true
		$red_keys/j.visible = false
		
		
	if Input.is_action_just_pressed("sprite_path_move_1"):
		$white_keys/n.visible = false
		$red_keys/n.visible = true
	if Input.is_action_just_released("sprite_path_move_1"):
		$white_keys/n.visible = true
		$red_keys/n.visible = false
		
		
	if Input.is_action_just_pressed("sprite_chase_2"):
		$white_keys/o.visible = false
		$red_keys/o.visible = true
	if Input.is_action_just_released("sprite_chase_2"):
		$white_keys/o.visible = true
		$red_keys/o.visible = false
		
	if Input.is_action_just_pressed("change_lookpoint_2"):
		$white_keys/k.visible = false
		$red_keys/k.visible = true
	if Input.is_action_just_released("change_lookpoint_2"):
		$white_keys/k.visible = true
		$red_keys/k.visible = false
		
		
	if Input.is_action_just_pressed("sprite_path_move_2"):
		$white_keys/m.visible = false
		$red_keys/m.visible = true
	if Input.is_action_just_released("sprite_path_move_2"):
		$white_keys/m.visible = true
		$red_keys/m.visible = false
		
		### END OF EXAMPLE UI SCRIPT
