extends CharacterBody3D

	# direction vars
var dir : Vector3
var player_to_sprite : Vector3

	#current speed, gets base from SPEED in Sprite_Rotate
var current_speed : int

	### Vars for the example program to toggle sprite body chase
var which_sprite
var chase_1 : bool = false
var chase_2 : bool = false
@onready var sprite3d : Node = $AnimatedSprite3D


var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
		# set speed
	current_speed = Global_Sprite_Rotate.SPEED

func _physics_process(delta):

	### apart of the example program and not main program. if chase toggle is on
	### allow movement code to run - sprite_chase
	if chase_1 or chase_2:
		sprite_chase(delta)


func sprite_chase(delta):

	# get direction to look. Like which sprite with designated lookpoint
	dir = which_sprite.sprite_to_lookpoint

	# correct direction
	dir *= -1
	dir = dir .normalized()
	dir.y = 0

	# make the body look at the sam direction as what the sprite is looking.
	look_at(global_transform.origin + dir, Vector3(0, 1, 0))

	# Move body towards lookpoint on the z axis
	position -= transform.basis.z.normalized() * current_speed * delta
	
	# add gravity
	velocity.y += -gravity * delta
	
	move_and_slide()
