extends Node3D

### EVERYTHING IN THIS SCRIPT IS FOR THE EXAMPLE AND NOT PART OF MAIN PROJECT

var speed : float = .4 # - speed of blue blox that spins around level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(speed * delta)
