extends CharacterBody3D

#var which_sprite

	#onready vars to connect nodes for code use
@onready var animated_sprite_2d = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var raycast = $head/RayCast3D
@onready var gunsound = $Gunsound
@onready var camera_3d = $head/Camera3D
@onready var sound_footsteps = $SoundFootsteps
@onready var gun_flash = $head/gun_flash
@onready var gun_flash2 = $head/gun_flash2
@onready var flash_timer = $Flash_Timer
@onready var ui_panel = $CanvasLayer/UI_Panel


	# Node Vars

@export var lookpoint : Node


## Players base speed
@export var SPEED : float = 10
## layers current speed
@export var SPEED_current : float = 10

## Players base jump strength
@export var jump_strength : float = 6
## Players current jump strength
@export var jump_strength_current : float = 6


## If the player can shoot
@export var can_shoot : bool = true


## Players mouse sensitivity as a float
@export var mouse_sensitivity = 0.002

## Players gamepad sensitivity as a float
@export var gamepad_sensitivity : float = 0.075
##Player gravity, how fast they fall downwards


	# mouse control vars
var mouse_captured : bool = true
var movement_velocity: Vector3
var rotation_target: Vector3
var input_mouse: Vector2

	# jump control cars
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var previously_floored : bool = false
var jump_single : bool = true
var jump_double : bool = true
var jump_triple : bool = true

	# speed control vars 
var normal_speed : bool = true
var normal_speed2 : bool = true
var normal_speed3 = true

var forward_held : bool = false

	#example project variables to aid example buttons
var which_sprite 

var pathkill_1
var pathkill_2

@onready var sprite_1 = get_tree().get_first_node_in_group("sprite_1").get_node("AnimatedSprite3D")
@onready var sprite_2 = get_tree().get_first_node_in_group("sprite_2").get_node("AnimatedSprite3D")

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
		# Hide any gun flashes
	gun_flash.hide()
	gun_flash2.hide()
	# Start flash timer, mount of seconds light is on when gun fires
	flash_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	sprite_chase_button()


func _physics_process(delta):
	if is_on_floor() and velocity.y < 1:
		jump_single = true

	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * SPEED_current
	velocity.z = movement_dir.z * SPEED_current


	if  Input.is_action_just_pressed("jump"):
		if jump_single or jump_double or jump_triple:
			Global_Audio.play("sounds/player/jump_a.ogg, sounds/player/jump_b.ogg, sounds/player/jump_c.ogg, sounds/player/jump1.wav")
			SPEED_current += .1
			jump_strength_current += .1
			
		
		if jump_triple:
			velocity.y += jump_strength_current
			jump_triple = false
			return
		
		if jump_double:
			velocity.y += jump_strength_current
			jump_double = false


		if(jump_single): action_jump(delta)

	move_and_slide()


	# Landing after jump or falling
	
	camera_3d.position.y = lerp(camera_3d.position.y, 1.5, delta * 5)
	
	if is_on_floor() and velocity.y < 1 and !previously_floored: # Landed
		Global_Audio.play("sounds/player/step2.wav")
		camera_3d.position.y -= 0.3

	previously_floored = is_on_floor()


	sound_footsteps.stream_paused = true
	
		# If player is on the ground then play walking sound
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			sound_footsteps.stream_paused = false
	
	# Falling/respawning
	
	if position.y < -10:
		get_tree().reload_current_scene()


func action_jump(_delta):
	jump_single = false;
	
	if is_on_floor():
		velocity.y = jump_strength_current
	# Turn sound off because it auto plays
		jump_single = false;
		jump_double = true;
		jump_triple = true;
	
func _input(event):
		# If player is dead do not allow movement
		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_3d.rotation.x = clampf(camera_3d.rotation.x, -deg_to_rad(70), deg_to_rad(70))


	# Fake Bunny Hop system function to return player to base speed
func normalspeed():
	normal_speed = true
	jump_strength_current = jump_strength
	SPEED_current = SPEED

	#Attack function
func shoot():
	#if player cannot shoot, as in cooldown, dont shoot
	if !can_shoot: return
	
	#muzzle flashes and shoot animation
	gun_flash.show()
	gun_flash2.show()
	animated_sprite_2d.play("shoot")
	gunsound.play()
	can_shoot = false


	#Light on end of gun when firing turn of when timer timesout function
func _on_flash_timer_timeout():
	gun_flash.hide()
	gun_flash2.hide()


	# When shooting animation is done allows player to shoot again
func _on_animated_sprite_2d_animation_finished():
	can_shoot = true


	### NOT PART OF MAIN PROJECT. MONSTER CHASE CONTROLS

func sprite_chase_button():
	if Input.is_action_just_pressed("sprite_chase_1"):
		which_sprite = sprite_1
		which_sprite.path_1_move_allow = false
		which_sprite.chase_toggle("path_1_move_allow")
		which_sprite.get_parent().which_sprite = sprite_1
		pathkill_1 = true 
		
		
	elif Input.is_action_just_pressed("sprite_chase_2"):
		which_sprite = sprite_2
		which_sprite.path_2_move_allow = false
		which_sprite.chase_toggle("path_2_move_allow")
		which_sprite.get_parent().which_sprite = sprite_2
		pathkill_2 = true
	
	### END OF MONSTER CHASE CONTROLS


