extends RigidBody2D


var push_force = Vector2(1080,0)
var max_speed = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func push_start():
	$TheClamper.start()
	if $TestOverlay/left.button_pressed:
		add_constant_central_force(push_force)

	if $TestOverlay/right.button_pressed:
		add_constant_central_force(-push_force)

func push_end():
	$TheClamper.stop()
	constant_force.x = 0
	pass


func _on_the_clamper_timeout() -> void:
	
	if abs(linear_velocity.x) > max_speed :
		linear_velocity.x = clamp(linear_velocity.x,-max_speed,max_speed)
	pass # Replace with function body.
