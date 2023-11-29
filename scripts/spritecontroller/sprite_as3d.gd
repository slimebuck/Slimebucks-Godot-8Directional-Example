extends Global_Sprite_Rotate


	## get positions of 3 points to use math to figure out angles and degrees
var player_position : Vector3
var lookpoint_position : Vector3
var sprite_position : Vector3
var sprite_select : Node
var cam_pos : Vector3
var lookpoint : Node

@export var enemy_degrees : float


	## vars for example program. This toggles the move paths

@export var path_1_move_allow : bool = true
@export var path_2_move_allow : bool = true



	### these vars are apart of the example
	### NOT APART OF MAIN PROJECT
	### connect sprite object to its pribate lookpoint - used to make it look at the right direction
	### when on the path
@onready var s_lookpoint : Node = $"../private_lookpoint"


	##make vars then in sprite_rotate script set sprite rotate process stuff
	## TO sprite.
func _ready():
	
	## set lookpoint information so the sprite looks the correct way on spawn
	sprite = self
	lookpoint = s_lookpoint

func _process(delta):
	sprite_process(delta) # - connects to Sprite_Rotate.gd
	

	### THIS IS FOR THE EXAMPLE, NOT PART OF THE MAIN PROJECT
	### Function that change lookpoint func in sprite rotate connects to,

func change_lookpoint(spot):
	get_parent().current_speed = Global_Sprite_Rotate.SPEED
	player.ui_panel.spot_connector = spot
	if spot == "red":
		lookpoint = lookat_red
	elif spot == "blue":
		lookpoint = lookat_blue
	elif spot == "player":
		lookpoint = player
	elif spot == "path":
		if sprite_select == sprite_1.sprite3d:
			if player.pathkill_1:
				sprite_select.get_parent().current_speed = 0
				
		if sprite_select == sprite_2.sprite3d:
			if player.pathkill_2:
				sprite_select.get_parent().current_speed = 0
				
		lookpoint = s_lookpoint
	elif spot == "other_sprite":
		if sprite_select == sprite_1.sprite3d:
			change_lookpoint("other_sprite_1")
		if sprite_select == sprite_2.sprite3d:
			change_lookpoint("other_sprite_2")
	elif spot == "other_sprite_2":
		lookpoint = sprite_1
	else:
		lookpoint = sprite_2
		
	if sprite_select == Global_Sprite_Rotate.sprite_1.sprite3d:
		player.ui_panel.spot1 = spot
	if sprite_select == Global_Sprite_Rotate.sprite_2.sprite3d:
		player.ui_panel.spot2 = spot

	### end of change lookpoint function
	
func move_path_allow(delta):
	var path : Node
	if sprite == sprite_1.sprite3d:
		path = get_tree().get_first_node_in_group("sprite_path_1")


		path.progress += path_speed + delta
	if sprite == sprite_2.sprite3d:
		path = get_tree().get_first_node_in_group("sprite_path_2")

		path.progress += path_speed + delta
